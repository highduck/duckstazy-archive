using System;
using UnityEngine;

[RequireComponent(typeof(MovableBody), typeof(Health))]
public class DuckState:MonoBehaviour {

	// settings
	public DuckSettings Data;

	// depends on
	MovableBody _body;
	Carrier _carrier;
	DiveDamager _diver;
	Health _health;
	private FlyControl _flyControl;

	// prev state
	public bool PrevDoubleJump;

	// flags
	public bool DoubleJump;
	public bool Running;
	public bool LongJump;
	public bool Shooting;
	public bool IsDead;

	public float LongJumpTimer;
	public sbyte MoveDirection; // base
	public sbyte LookDirection; // base

	// delegate
	public event Action OnJump;
	public event Action OnDoubleJump;
	
	void Awake() {
		_body = GetComponent<MovableBody>();
		_carrier = GetComponentInChildren<Carrier>();
		_diver = GetComponentInChildren<DiveDamager>();
		_health = GetComponent<Health>();
		_flyControl = GetComponent<FlyControl>();
	}

	void OnEnable() {
		_carrier.Dropped += OnItemDropped;
		_health.Respawned += Health_Respawned;
		_health.Damaged += OnDamage;
		_health.Kicked += OnKick;
		_health.Died += OnDie;
		_body.Landed += Body_Landed;
		_body.Moving += Body_Moving;
	}

	void OnDisable() {
		_carrier.Dropped -= OnItemDropped;
		_health.Respawned -= Health_Respawned;
		_health.Damaged -= OnDamage;
		_health.Kicked -= OnKick;
		_health.Died -= OnDie;
		_body.Landed -= Body_Landed;
		_body.Moving -= Body_Moving;
	}

	private void OnKick(Vector2 power) {
		_body.ApplyVelocity(new Vector2(-power.x*LookDirection, power.y));
	}

	private void OnDie() {
		IsDead = true;
	}

	private void OnDamage(int amount) {
		_carrier.DropDown();
	}

	private void OnItemDropped(IPickable obj) {
		var v = _body.Velocity;
		v.x += LookDirection*4f;
		v.y = 0f;
		obj.SetDropVelocity(v);
	}

	void Reset() {
		LongJumpTimer = 0f;
		MoveDirection = 0;

		// flags
		PrevDoubleJump = false;
		DoubleJump = false;
		Running = false;
		LongJump = false;
		Shooting = false;
	}

	private void Health_Respawned() {
		Reset();
		IsDead = false;
	}

	

	private bool IsDoubleJumpAvailable {
		get {
			if (_diver.IsBlocking || _carrier.IsCarrying) {
				return false;
			}
			return !DoubleJump;
		}
	}

	private void ResetLongJump() {
		LongJump = false;
		LongJumpTimer = 0f;
	}

	private void UpdateLongJump(float dt) {
		if(LongJump) {
			LongJumpTimer += dt;
			if(LongJumpTimer >= Data.LongJumpTime) {
				ResetLongJump();
			}
		}
	}

	public void StartJump(float velocity) {
		_body.Velocity.y = velocity;
		DoubleJump = false;
		StartLongJump();
	}

	private void DoJump() {
		StartJump(Data.JumpVelocity);
		if (OnJump != null) {
			OnJump();
		}
	}


	private void StartLongJump() {
		LongJump = true;
		LongJumpTimer = 0f;
	}

	private void DoDoubleJump() {
		DoubleJump = true;
		StartLongJump();
		_body.Velocity.x = XMath.AddByMod(_body.Velocity.x, GetTargetVelocityX(), Data.DoubleJumpHorAcceleration);
		_body.Velocity.y = Data.DoubleJumpVelocity;
		if (OnDoubleJump != null) {
			OnDoubleJump();
		}
	}


	public void Body_Moving(MovableBody body) {
		if (IsDead) {
			return;
		}
		var dt = Time.fixedDeltaTime;
		var velocity = body.Velocity;
		var vyMax = Data.GetMoveVerMax(_diver.IsActive);
		var ay = -GetGravity();
		var targetVx = GetTargetVelocityX();
		var hacc = GetHorizontalAcceleration();

		velocity.x = XMath.AddByMod(velocity.x, targetVx, hacc*dt);
		velocity.y = GetVelocityY(dt, ay, velocity.y);
		if(velocity.y > vyMax) {
			velocity.y = vyMax;
		}

		body.Velocity = velocity;
	}

	// data.getgravity(ljs);
	private float GetGravity() {
		return (LongJump && !_diver.IsActive) ? Data.GravityLong : Data.Gravity;
	}

	private float GetVelocityY(float dt, float ay, float vy) {
		if (_flyControl != null && _flyControl.IsFlying) {
			return _flyControl.FlowVelocity;
		}
		return vy + ay*dt;
	}

	private float GetTargetVelocityX()
	{
		var maxvx = Data.MoveHorVelocityMax;

		//if(_bonusSpeedup > 0.0)
		//{
		//	maxvx *= 1.5;
		//}
			
		if(_health.IsDead) {
			maxvx = 0f;
		}
			
		return MoveDirection*maxvx;
	}

	public float GetHorizontalAcceleration()
	{
		var result = 0f;
		if(_body.IsGrounded || _diver.IsActive) {
			result = Data.MoveHorAccelerationGround;
		}
		else {
			result = Data.MoveHorAccelerationAir;
		}

		if (_body.IsGrounded && MoveDirection == 0) {
			result *= Data.MoveHorAccelerationIdleMult;
		}
		
		if(_health.IsKicked)
		{
			result *= Data.MoveHorAccelerationKickedMult;
		}
			
		return result;
	}

	private void Body_Landed() {
		ResetLongJump();
		DoubleJump = false;
	}

	void Update() {
		// state chaining;
		var dt = Time.deltaTime;
		if (IsDead) {
			return;
		}

		SetPrevState();
		UpdateLongJump(dt);
	}

	private void SetPrevState() {
		PrevDoubleJump = DoubleJump;
	}


	public void SetMoveDirection(sbyte direction) {
		MoveDirection = direction;
		if (MoveDirection != 0) {
			LookDirection = MoveDirection;
		}
	}

	public float Scale {
		get { return Data.Scale; }
	}

	public bool IsCarrying {
		get { return _carrier.IsCarrying; }
	}

	public int GetJumpState() {
		var jumpState = 0;
		var doubleJump = DoubleJump;
		var lastDoubleJump = PrevDoubleJump;
		var vy = _body.Velocity.y;
		var lastVy = _body.PreviousVelocity.y;

		if (!_body.IsGrounded) {
			if (_flyControl != null && _flyControl.IsFlying) {
				jumpState = 1;
			}
			else {
				if (vy > 0f && doubleJump == lastDoubleJump) {
					jumpState = 1;
				}
				else {
					if (lastVy >= 0f) {
						jumpState = (doubleJump != lastDoubleJump) ? 2 : 1;
					}
					else {
						jumpState = (MoveDirection == 0) ? 2 : 0;
					}
				}
				if (vy <= -Data.FallVelocity) {
					jumpState = 2;
				}
			}
		}

		return jumpState;
	}

	public void Jump() {
		if(_body.IsGrounded) {
			DoJump();
		}
		else if(IsDoubleJumpAvailable) {
			DoDoubleJump();
		}
	}

	public void FinishJumping() {
		ResetLongJump();
	}
}
