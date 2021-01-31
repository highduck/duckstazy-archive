using System;
using UnityEngine;

public class Health : MonoBehaviour {

	[Range(0f, 1f)]
	public float TimeoutMultiplier = 1f;
	public int HitPointsMax;
	public float DefaultTimeout = 1f;
	public Arbiter Arbiter;
	public int RespawnTime = 0;

	private int _hitPoints;
	private float _timeout;
	private float _respawnTimer;

	private Vector2 _startPosition;
	private Transform _startParent;

	public event Action Respawned;
	public event Action<int> Damaged;
	public event Action Died;
	public event Action<Vector2> Kicked;
	
	void Awake() {
		
	}

	void Start() {
		_startPosition = transform.localPosition;
		_startParent = transform.parent;

		Respawn();
	}

	public void Respawn() {
		_hitPoints = HitPointsMax;
		_respawnTimer = 0f;

		if (_startParent != transform.parent) {
			transform.parent = _startParent;
		}
		
		var body = GetComponent<MovableBody>();
		if (body != null) {
			body.ApplyVelocity(Vector2.zero);
			//body.TeleportTo(_startPosition);
			GetComponent<Movement2D>().Position = _startPosition;
		}
		else {
			transform.localPosition = _startPosition;
		}

		if (Respawned != null) {
			Respawned();
		}
	}

	void FixedUpdate() {
		var dt = Time.deltaTime;
		if (_timeout > 0f) {
			_timeout -= dt;
			if (_timeout <= 0f) {
				_timeout = 0f;
				if (Arbiter != null) {
					Arbiter.CollidersEnabled = true;
				}
			}
		}
		if (_respawnTimer > 0f) {
			_respawnTimer -= dt;
			if (_respawnTimer <= 0f) {
				Respawn();
			}
		}
	}

	public bool IsDead {
		get { return HitPointsMax > 0 && _hitPoints <= 0; }
	}

	public bool IsKicked {
		get { return _timeout > 0f; }
	}

	public bool Damage(int amount, float withTimeOut = -1f) {
		if (IsDead || IsKicked) {
			return false;
		}
		DoDamage(amount, withTimeOut);
		return true;
	}

	private void DoDamage(int amount, float withTimeOut = -1f) {
		_hitPoints = Mathf.Clamp(_hitPoints - amount, 0, HitPointsMax);
		if (Damaged != null) {
			Damaged(amount);
		}
		if (_hitPoints == 0) {
			Kill();
		}
	}

	private void Kill() {
		_respawnTimer = RespawnTime;
		if (Died != null) {
			Died();
		}
		if (RespawnTime == 0) {
			Respawn();
		}
	}

	public void Kick(Vector2 power, float timeout = -1f) {
		if (IsDead) {
			return;
		}
		_timeout = (timeout >= 0f ? timeout : DefaultTimeout)*TimeoutMultiplier;
		if (_timeout > 0f && Arbiter != null) {
			Arbiter.CollidersEnabled = false;
		}
		if (Kicked != null) {
			Kicked(power);
		}
	}

	public void Die() {
		Damage(_hitPoints);
	}

	public int HitPoints {
		get { return _hitPoints; }
	}

	public static bool CheckForDamage(Health health) {
		return health != null && !health.IsDead && !health.IsKicked;
	}
}

