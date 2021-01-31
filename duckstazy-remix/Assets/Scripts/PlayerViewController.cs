using UnityEngine;
using System.Collections;


[RequireComponent(typeof (DuckState), typeof (PlayerView), typeof (Health))]
[RequireComponent(typeof (MovableBody), typeof (DiveDamager))]
public class PlayerViewController : MonoBehaviour {

	private DuckState _state;
	private MovableBody _body;
	private PlayerView _view;
	private Health _health;
	private PlayerData _playerData;
	private DiveDamager _diver;
	private Carrier _carrier;
	private FlyControl _flyControl;

	private void Awake() {
		_view = GetComponent<PlayerView>();
		_state = GetComponent<DuckState>();
		_health = GetComponent<Health>();
		_diver = GetComponent<DiveDamager>();
		_body = GetComponent<MovableBody>();
		_carrier = GetComponent<Carrier>();
		_flyControl = GetComponent<FlyControl>();
	}

	private void OnEnable() {
		_health.Respawned += Health_Respawned;
		_health.Damaged += OnDamage;
		_health.Died += OnDeath;

		_body.Landed += Body_Landed;

		_state.OnJump += OnJump;
		_state.OnDoubleJump += OnDoubleJump;

		_diver.Landed += Diver_Landed;
		_diver.Started += Diver_Started;
	}

	private void OnDisable() {
		_health.Respawned -= Health_Respawned;
		_health.Damaged -= OnDamage;
		_health.Died -= OnDeath;

		_body.Landed -= Body_Landed;

		_state.OnJump -= OnJump;
		_state.OnDoubleJump -= OnDoubleJump;

		_diver.Landed -= Diver_Landed;
		_diver.Started -= Diver_Started;
	}

	private void OnDeath() {
		_view.Visible = false;
	}

	private void OnDamage(int amount) {
		_view.PlayHitEffect(amount);
	}


	private void Update() {
		if (_health.IsDead) {
			return;
		}
		_view.SetJumpState(_state.GetJumpState());
		_view.MoveDirection = _state.MoveDirection;
		_view.Carrying = _carrier.IsCarrying;
		_view.Scale = _state.Scale;
		_view.Shooting = _state.Shooting;
		_view.Grounded = _body.IsGrounded;
		_view.Flying = _flyControl != null && _flyControl.IsFlying;
		_view.Dive = _diver.IsActive;
		_view.DiveEnterProgress = _diver.EnterProgress;
	}

	private void Diver_Landed() {
		Camera.main.GetComponent<RandomShaker>().Shake(8f, 0.5f);
		_view.SoundDiveLanding.PlayAtSource(GetComponent<AudioSource>());
	}

	private void Diver_Started() {
		_view.PlayDivingStart();
		//_stats.onDiveEnter();
	}

	public void Health_Respawned() {
		_view.Visible = true;
		_view.PlaySqueeze();
	}

	private void Body_Landed() {
		_view.PlayLandingEffect(_body.Velocity);
	}

	private void OnJump() {
		_view.PlayJump();
	}

	private void OnDoubleJump() {
		_view.PlayDoubleJump(_body.Velocity);
	}

	public void ConnectPlayerData(PlayerData playerData) {
		_playerData = playerData;
	}

	public PlayerData PlayerData {
		get { return _playerData; }
	}

}

