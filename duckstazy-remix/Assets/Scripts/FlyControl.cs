using GameKit.Commons;
using UnityEngine;

[RequireComponent(typeof(MovableBody))]
public class FlyControl :MonoBehaviour {

	[Range(0f, 2f)]
	public float FlowAmount = 1f;

	private MovableBody _body;
	private DiveDamager _diver;
	private Carrier _carrier;
	private Health _health;

	private bool _isFlying;
	private float _cycle;


	void Awake() {
		_body = GetComponent<MovableBody>();
		_diver = GetComponent<DiveDamager>();
		_carrier = GetComponent<Carrier>();
		_health = GetComponent<Health>();
	}

	void OnEnable() {
		_body.Landed += Body_Landed;
	}


	void Update() {
		if (!_isFlying || IsDead) {
			return;
		}
		_cycle += Time.deltaTime*2.25f;
		if (_cycle > 1f) {
			_cycle -= (int) _cycle;
		}
	}

	private float FlyOffset {
		get { return Mathf.Sin(-_cycle*FastMath.PiTwo); }
	}

	protected bool IsDead {
		get { return _health != null && _health.IsDead; }
	}

	private void Body_Landed() {
		StopFlying();
	}

	public void StartFlying() {
		if (IsFlyingAvailable) {
			SetFlying(true);
		}
	}

	public void StopFlying() {
		SetFlying(false);
	}

	private void SetFlying(bool state) {
		if (_isFlying == state) {
			return;
		}
		if (state) {
			_body.Velocity.y = 0f;
		}
		_isFlying = state;
	}

	private bool IsFlyingAvailable {
		get {
			if (_diver != null && _diver.IsBlocking) {
				return false;
			}
			if (_carrier != null && _carrier.IsCarrying) {
				return false;
			}
			if (_health != null && _health.IsKicked) {
				return false;
			}
			return !_isFlying && !_body.IsGrounded && _body.Velocity.y < 0f;
		}
	}

	public bool IsFlying {
		get { return _isFlying; }
	}

	public float FlowVelocity {
		get { return FlyOffset*FlowAmount; }
	}
}
