#define DEBUG_CC2D_RAYS

using System;
using System.Collections.Generic;
using GameKit.Commons;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Movement2D : MonoBehaviour {

	[Range(0.001f, 0.3f)]
	public float SkinWidth = 0.02f;

	[Range(2, 20)]
	public int HorizontalRays = 4;

	[Range(2, 20)]
	public int VerticalRays = 4;

	public BoxCollider BoxCollider;
	
	public readonly MovementCollisionState CollisionState = new MovementCollisionState();

	public event Action<RaycastHit> CollidedEvent;

	private const float SkinWidthFloatFudgeFactor = 0.001f;

	private Transform _transform;
	private Rigidbody _rigidbody;
	private RaycastHit _raycastHit;
	private readonly List<RaycastHit> _raycastHitsThisFrame = new List<RaycastHit>(2);
	private float _verticalDistanceBetweenRays;
	private float _horizontalDistanceBetweenRays;
	private MovementRaycastOrigins _raycastOrigins;
	private MovementManager _manager;

	void Awake() {
		_manager = MovementManager.Instance;
		_transform = GetComponent<Transform>();
		_rigidbody = GetComponent<Rigidbody>();
		if (BoxCollider == null) {
			BoxCollider = GetComponent<BoxCollider>();
		}

		RecalculateDistanceBetweenRays();
	}

	public Vector2 Position {
		get { return _rigidbody.position; }
		set { _rigidbody.MovePosition(value); }
	}

	public void Move(Vector3 deltaMovement) {
		// save off our current grounded state
		bool wasGroundedBeforeMoving = CollisionState.Bottom;

		// clear our state
		CollisionState.Reset();
		_raycastHitsThisFrame.Clear();

		_raycastOrigins.Setup(_transform.position, GetColliderCenter(), GetColliderSize(), SkinWidth);
		RecalculateDistanceBetweenRays();

		// now we check movement in the horizontal dir
		if (!FastMath.Equals(deltaMovement.x, 0f)) {
			MoveHorizontally(ref deltaMovement);
		}

		if (wasGroundedBeforeMoving && deltaMovement.y <= 0f) {
			deltaMovement.y -= 0.01f;
		}

		// next, check movement in the vertical dir
		if (!FastMath.Equals(deltaMovement.y, 0f)) {
			MoveVertically(ref deltaMovement);
		}

		// move then update our state
		//_transform.Translate(deltaMovement, Space.World);

		// TODO: do we need to move actually? check a length of delta above zero
		_rigidbody.MovePosition(_rigidbody.position + deltaMovement);

		// set our becameGrounded state based on the previous and current collision state
		if (!wasGroundedBeforeMoving && CollisionState.Bottom) {
			CollisionState.BecameGroundedThisFrame = true;
		}

		// send off the collision events if we have a listener
		if (CollidedEvent != null) {
			for (int i = 0; i < _raycastHitsThisFrame.Count; ++i) {
				CollidedEvent(_raycastHitsThisFrame[i]);
			}
		}

		DrawBox();
	}

	#region Private Movement Methods

	private void RecalculateDistanceBetweenRays() {
		Vector2 size = GetColliderSize();
		float skin = 2f*SkinWidth;
		_verticalDistanceBetweenRays = (size.y - skin) / (HorizontalRays - 1);
		_horizontalDistanceBetweenRays = (size.x - skin) / (VerticalRays - 1);
	}

	[System.Diagnostics.Conditional("DEBUG_CC2D_RAYS")]
	private static void DrawRay(Vector3 start, Vector3 dir, Color color) {
		Debug.DrawRay(start, dir, color);
	}

	[System.Diagnostics.Conditional("DEBUG_CC2D_RAYS")]
	private void DrawBox() {
		var pos = (Vector2) _transform.localPosition;
		Vector2 hs = GetColliderSize()*0.5f;
		Vector2 center = GetColliderCenter();
		Debug.DrawLine(pos + center - hs, pos + center + hs, Color.green);
		Debug.DrawLine(pos + center - hs, pos + center - hs + new Vector2(_horizontalDistanceBetweenRays, 0f), Color.magenta);
	}

	


	private Vector2 GetColliderSize() {
		return new Vector2(BoxCollider.size.x*Mathf.Abs(_transform.localScale.x),
		                   BoxCollider.size.y*Mathf.Abs(_transform.localScale.y));
	}

	private Vector2 GetColliderCenter() {
		return new Vector2(BoxCollider.center.x*_transform.localScale.x, BoxCollider.center.y*_transform.localScale.y);
	}

	private void MoveHorizontally(ref Vector3 deltaMovement) {
		bool isGoingRight = deltaMovement.x > 0;
		float rayDistance = Mathf.Abs(deltaMovement.x) + SkinWidth;
		Vector2 rayDirection = isGoingRight ? Vector2.right : -Vector2.right;
		Vector3 initialRayOrigin = isGoingRight ? _raycastOrigins.BottomRight : _raycastOrigins.BottomLeft;
		LayerMask mask = _manager.Platforms & ~_manager.OneWayPlatform;

		for (int i = 0; i < HorizontalRays; i++) {
			var ray = new Vector2(initialRayOrigin.x, initialRayOrigin.y + i*_verticalDistanceBetweenRays);

			DrawRay(ray, rayDirection*rayDistance, Color.red);
			if (Physics.Raycast(ray, rayDirection, out _raycastHit, rayDistance, mask)) {
				// set our new deltaMovement and recalculate the rayDistance taking it into account
				deltaMovement.x = _raycastHit.point.x - ray.x;
				rayDistance = Mathf.Abs(deltaMovement.x);

				// remember to remove the skinWidth from our deltaMovement
				if (isGoingRight) {
					deltaMovement.x -= SkinWidth;
					CollisionState.Right = true;
				}
				else {
					deltaMovement.x += SkinWidth;
					CollisionState.Left = true;
				}

				_raycastHitsThisFrame.Add(_raycastHit);

				// we add a small fudge factor for the float operations here. if our rayDistance is smaller
				// than the width + fudge bail out because we have a direct impact
				if (rayDistance < SkinWidth + SkinWidthFloatFudgeFactor) {
					break;
				}
			}
		}
	}

	private void MoveVertically(ref Vector3 deltaMovement) {
		bool isGoingUp = deltaMovement.y > 0;
		float rayDistance = Mathf.Abs(deltaMovement.y) + SkinWidth;
		Vector2 rayDirection = isGoingUp ? Vector2.up : -Vector2.up;
		Vector3 initialRayOrigin = isGoingUp ? _raycastOrigins.TopLeft : _raycastOrigins.BottomLeft;

		// apply our horizontal deltaMovement here so that we do our raycast from the actual position we would be in if we had moved
		initialRayOrigin.x += deltaMovement.x;

		// if we are moving up, we should ignore the layers in oneWayPlatformMask
		LayerMask mask = _manager.Platforms;
		if (isGoingUp) {
			mask &= ~_manager.OneWayPlatform;
		}

		for (int i = 0; i < VerticalRays; i++) {
			var ray = new Vector2(initialRayOrigin.x + i*_horizontalDistanceBetweenRays, initialRayOrigin.y);

			DrawRay(ray, rayDirection*rayDistance, Color.red);
			if (Physics.Raycast(ray, rayDirection, out _raycastHit, rayDistance, mask)) {
				// set our new deltaMovement and recalculate the rayDistance taking it into account
				deltaMovement.y = _raycastHit.point.y - ray.y;
				rayDistance = Mathf.Abs(deltaMovement.y);

				// remember to remove the skinWidth from our deltaMovement
				if (isGoingUp) {
					deltaMovement.y -= SkinWidth;
					CollisionState.Top = true;
				}
				else {
					deltaMovement.y += SkinWidth;
					CollisionState.Bottom = true;
				}

				_raycastHitsThisFrame.Add(_raycastHit);

				// we add a small fudge factor for the float operations here. if our rayDistance is smaller
				// than the width + fudge bail out because we have a direct impact
				if (rayDistance < SkinWidth + SkinWidthFloatFudgeFactor) {
					return;
				}
			}
		}
	}
	#endregion

	#region internal types
	private struct MovementRaycastOrigins {
		public Vector3 TopRight;
		public Vector3 TopLeft;
		public Vector3 BottomRight;
		public Vector3 BottomLeft;

		public void Setup(Vector2 position, Vector2 center, Vector2 size, float skinWidth) {
			size = size*0.5f;

			TopRight = position + new Vector2(center.x + size.x, center.y + size.y);
			TopRight.x -= skinWidth;
			TopRight.y -= skinWidth;

			TopLeft = position + new Vector2(center.x - size.x, center.y + size.y);
			TopLeft.x += skinWidth;
			TopLeft.y -= skinWidth;

			BottomRight = position + new Vector2(center.x + size.x, center.y - size.y);
			BottomRight.x -= skinWidth;
			BottomRight.y += skinWidth;

			BottomLeft = position + new Vector2(center.x - size.x, center.y - size.y);
			BottomLeft.x += skinWidth;
			BottomLeft.y += skinWidth;
		}
	}

	public class MovementCollisionState {
		public bool Right;
		public bool Left;
		public bool Top;
		public bool Bottom;
		public bool BecameGroundedThisFrame;

		public bool HasCollision {
			get { return Bottom || Right || Left || Top; }
		}

		public void Reset() {
			Right = Left = Top = Bottom = BecameGroundedThisFrame = false;
		}

		public override string ToString() {
			return string.Format("[CollisionState] r: {0}, l: {1}, a: {2}, b: {3}", Right, Left, Top, Bottom);
		}
	}
	#endregion
}
