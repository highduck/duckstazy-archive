using System;
using UnityEngine;

public class DiveDamager : MonoBehaviour {
	public Vector2 KickPower = new Vector2(2f, 3f);
	public Arbiter Arbiter;
	
	public event Action Started;
	public event Action Landed;
	public event Action Hitted;

	private bool _active;
	private float _enterTime;
	private float _lockTime;
	
	private DuckSettings _data;
	private DuckState _state;
	private FlyControl _flyControl;
	private MovableBody _body;
	private Health _health;
	private Carrier _carrier;
	private Blast _blast;
	private bool _isDiving;

	public bool IsBlocking {
		get { return _active || _enterTime > 0f; }
	}

	public bool IsActive {
		get { return _active; }
	}

	// Use this for initialization
	void Awake () {
		_state = GetComponent<DuckState>();
		_health = GetComponent<Health>();
		_data = _state.Data;
		_carrier = GetComponentInChildren<Carrier>();
		_blast = GetComponentInChildren<Blast>();
		_body = GetComponent<MovableBody>();
		_flyControl = GetComponent<FlyControl>();
	}

	void OnEnable() {
		Arbiter.TriggerEntered += Collide;
		_body.Landed += Player_Landed;
	}

	private void Player_Landed() {
		
		_enterTime = 0f;
		_lockTime = 0f;

		if(_active) {
			CompleteDiving();
			
			if (Landed != null) {
				Landed();
			}

			if (_blast != null) {
				_blast.Activate();
			}
		}
		
	}

	void Reset() {
		_isDiving = _active = false;
		_enterTime = _lockTime = 0f;
	}

	void Update() {
		var dt = Time.deltaTime;
		if (_lockTime > 0f) {
			_lockTime -= dt;
		}
		if(_isDiving && IsAvailable) {
			_flyControl.StopFlying();
			_enterTime += dt;
			if (_enterTime >= _data.DiveEnterTime) {
				StartDiving();
			}
		}
		else
		{
			_enterTime = 0f;
			//onDiveExit();
		}
	}

	private void StartDiving() {
		_body.Velocity.y = -_data.MoveVerDive;
		_active = true;
		_enterTime = 0f;
		_carrier.DropDown();
		_flyControl.StopFlying();
		if (Started != null) {
			Started();
		}
	}

	private void CancelDiving() {
		_active = false;
		_lockTime = _enterTime = 0f;
	}
		
	private void CompleteDiving() {
		if (!_active) {
			return;
		}

		_active = false;
		_state.StartJump(_data.VelocityOnDiveLanding);
		_lockTime = _data.DiveLockTime;
	}

	private void Collide(GameObject other) {
		// need to be in active state
		if (!_active) {
			return;
		}

		// damage only if we are above of enemy
		if (transform.position.y <= other.transform.position.y) {
			return;
		}

		var health = other.GetComponent<Health>();
		if (!enabled || health == null || health.IsKicked || health.IsDead) {
			return;
		}
		if (health.gameObject == gameObject) {
			return;
		}
		if (Hitted != null) {
			Hitted();
		}
		health.Damage(10);
		health.Kick(KickPower);
		CompleteDiving();
	}

	public float EnterProgress {
		get { return _enterTime/_state.Data.DiveEnterTime; }
	}

	public bool IsAvailable
	{
		get {
			if (_active || _lockTime > 0f) {
				return false;
			}
			if (_body.IsGrounded || _health.IsKicked){
				return false;
			}
			return true;
		}
	}

	public bool IsDiving {
		get { return _isDiving; }
		set { _isDiving = value; }
	}
}
