using UnityEngine;

public class PlayerControl : MonoBehaviour {

	Health _health;
	DuckState _state;
	Carrier _carrier;
	DiveDamager _diver;
	private FlyControl _flyControl;

	protected virtual void Awake() {
		_state = GetComponent<DuckState>();
		_health = GetComponent<Health>();
		_carrier = GetComponent<Carrier>();
		_diver = GetComponent<DiveDamager>();
		_flyControl = GetComponent<FlyControl>();
	}

	public void Update() {
		if (IsDead) {
			return;
		}

		UpdateControl(Time.deltaTime);
	}

	protected virtual void UpdateControl(float deltaTime) {
		
	}

	public void SetShooting(bool value) {
		if (_state != null) {
			_state.Shooting = value && !_carrier.IsCarrying;
		}
	}

	public bool IsDead {
		get { return _health != null && _health.IsDead; }
	}

	public void SetMoveDirection(sbyte moveDirection) {
		if (_state != null) {
			_state.SetMoveDirection(moveDirection);
		}
	}

	public void ToggleCarrier() {
		if (_carrier != null) {
			_carrier.Toggle();
		}
	}
	public void Jump() {
		if (_state != null) {
			_state.Jump();
		}
	}

	public void FinishJumping() {
		if (_state != null) {
			_state.FinishJumping();
		}
	}

	public void SetFlying(bool value) {
		if(_flyControl != null && _flyControl.IsFlying != value) {
			if (value) {
				_flyControl.StartFlying();
			}
			else {
				_flyControl.StopFlying();
			}
		}
	}

	public void SetDiving(bool value) {
		if (_diver != null) {
			_diver.IsDiving = value;
		}
	}
}

