using System.Collections;
using UnityEngine;using System;

[RequireComponent(typeof(Movement2D))]
public class MovableBody : MonoBehaviour {

	[SerializeField]
	private bool _isKinematic;
	public bool IsKinematic {
		get { return _isKinematic; }
		set {
			_isKinematic = value;
			ApplyVelocity(Vector2.zero);
		}
	}

	[NonSerialized]
	public Vector2 PreviousVelocity;
	[NonSerialized]
	public Vector2 Velocity;
	[NonSerialized]
	public bool IsGrounded;

	public event Action Landed;
	public event Action<MovableBody> Moving;

	private MovementManager _manager;
	private Movement2D _movement;

	private Vector2 _teleportPosition;
	private bool _teleporting;

	void Awake() {
		_manager = MovementManager.Instance;
		_movement = GetComponent<Movement2D>();
	}

	void Reset() {
		PreviousVelocity = Velocity = Vector2.zero;
		IsGrounded = false;
	}

	void FixedUpdate() {
		var dt = Time.fixedDeltaTime;

		if (_teleporting) {
			_teleporting = false;
			_movement.Position = _teleportPosition;
		}

		PreviousVelocity = Velocity;

		if (!IsKinematic) {
			Velocity += _manager.Gravity*dt;
			var damping = _manager.GetDamping(IsGrounded);
			if (damping > 0f) {
				Velocity *= Mathf.Exp(-damping*dt);
			}
		}

		OnMoving();

		//_movement.Move((PreviousVelocity + Velocity)*dt/2f);
		_movement.Move(Velocity*dt);
		UpdateGrounded();
		CheckCollisions();
	}

	private void OnMoving() {
		if (Moving != null) {
			Moving(this);
		}
	}

	private void CheckCollisions() {
		var state = _movement.CollisionState;
		if (state.Left && Velocity.x < 0f) {
			Velocity.x = 0f;
		}
		if (state.Right && Velocity.x > 0f) {
			Velocity.x = 0f;
		}
		if (state.Top && Velocity.y > 0f) {
			Velocity.y = 0f;
		}
		if (state.Bottom && Velocity.y < 0f) {
			Velocity.y = 0f;
		}
	}

	private void UpdateGrounded() {
		var state = _movement.CollisionState;
		var wasGrounded = IsGrounded;
		IsGrounded = state.Bottom;
		if (IsGrounded == wasGrounded) {
			return;
		}

		if (IsGrounded && state.BecameGroundedThisFrame) {
			OnLanding();
		}
	}

	private void OnLanding() {
		if (Landed != null) {
			Landed();
		}
	}

	public void ApplyVelocity(Vector2 velocity) {
		PreviousVelocity = Velocity = velocity;
	}

	public void TeleportTo(Vector2 position) {
		_teleporting = true;
		_teleportPosition = position;
	}
}
