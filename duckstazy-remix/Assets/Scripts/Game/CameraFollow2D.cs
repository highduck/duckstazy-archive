using System;
using System.Collections.Generic;
using GameKit.Commons;
using UnityEngine;

[RequireComponent(typeof(Camera), typeof(RandomShaker))]
class CameraFollow2D : MonoBehaviour {
	public Transform[] Targets;
	public Vector2 LookForward = new Vector2(1f, 1f);
	public Vector2 LookForwardMax = new Vector2(100f, 100f);

	public float MoveSpeed = 3f;
	public float ZoomSpeed = 3f;
	public float FollowSpeed = 3f;

	private Transform _cachedTransform;
	private Camera _cachedCamera;

	private Vector2 _targetOffset;
	private Vector2 _currentOffset;
	private Vector2 _position;

	private float _zoom = 1f;
	private RandomShaker _randomShaker;

	private const float ToPixel = 0.01f;

	void Start() {
		_cachedTransform = GetComponent<Transform>();
		_cachedCamera = GetComponent<Camera>();
		_randomShaker = GetComponent<RandomShaker>();
		_currentOffset = GetNewOffset();
		_position = GetNewPosition();
		_zoom = GetNewZoom();
		UpdateTransform();
		
	}

	public RandomShaker RandomShaker {
		get { return _randomShaker; }
	}

	void LateUpdate() {
		// Наведение фокуса камеры
		
		float dt = Time.deltaTime;

		// Наводим камеру на новое место
		_targetOffset = GetNewOffset();
		_currentOffset = Vector2.Lerp(_currentOffset, _targetOffset, MoveSpeed*dt);
		
		// Если камера навелась на фокус - фиксируем положение
		if(Mathf.Abs(_targetOffset.x - _currentOffset.x) < 0.0025f)
			_currentOffset.x = _targetOffset.x;
		if(Mathf.Abs(_targetOffset.y - _currentOffset.y) < 0.0025f)
			_currentOffset.y = _targetOffset.y;
			
		var prevPosition = _position;
		_position = GetNewPosition();
		_position = Vector2.Lerp(prevPosition, _position, FollowSpeed*dt);
					
		//limitBounds(_position);

		_zoom = XMath.Lerp(_zoom, GetNewZoom(), ZoomSpeed*dt);
		_zoom = Mathf.Min(_zoom, 1f);

		UpdateTransform();
	}

	private void UpdateTransform() {
		var p = _cachedTransform.localPosition;
		p.x = _position.x + _randomShaker.Position.x * ToPixel;
		p.y = _position.y + _randomShaker.Position.y * ToPixel;
		_cachedTransform.localPosition = p;
		_cachedCamera.orthographicSize = (Screen.height*ToPixel*0.5f)/_zoom;
	}

	private Vector2 GetNewPosition() {
		Vector2 p = _currentOffset;
		if (Targets.Length > 0) {
			p += GetTargetsCenter();
		}
		return p;
	}

	Vector2 GetTargetsCenter() {
		var p = new Vector3();
		var count = 0f;
			
		foreach(var tr in Targets) {
			if (tr != null) {
				p += tr.localPosition;
				count += 1f;
			}
		}
			
		if(count > 0f)
		{
			p.x /= count;
			p.y /= count;
		}
			
		return new Vector2(p.x, p.y);
	}
		
	float GetNewZoom()
	{
		var zoom = 1f;

		float distance = 0f;
		Vector3 delta;
		float w = Screen.width;
		float h = Screen.height;
		float diag = Mathf.Sqrt(w*w + h*h) / 200f;
			
		foreach (var target1 in Targets)
		{
			foreach(var target2 in Targets)
			{
				if (target1 == target2 || target1 == null || target2 == null) {
					continue;
				}
				delta = target1.localPosition - target2.localPosition;
				delta.z = 0f;
				distance = Mathf.Max( delta.magnitude, distance);
			}
		}
			
		if(distance > diag)
		{
			zoom = diag / distance;
		}
			
		return zoom;
	}
		
	Vector2 GetTargetsVelocity()
	{
		Vector2 p = new Vector2();
		float count = 0f;
			
		foreach (var tr in Targets) {
			if (tr != null) {
				var rb = tr.GetComponent<MovableBody>();
				if (rb != null && rb.gameObject.activeSelf) {
					p += rb.Velocity;
					count += 1f;
				}
			}
		}
				
		if(count > 0f)
		{
			p.x /= count;
			p.y /= count;
		}
			
		return p;
	}

	Vector2 GetNewOffset() {
		Vector2 focus = _currentOffset;
		Vector2 c;
		if (Targets.Length > 0) {
			c = GetTargetsVelocity();

			focus += Vector2.Scale(c, LookForward);
			var mx = LookForwardMax.x / Targets.Length;
			var my = LookForwardMax.y / Targets.Length;
				
			if (focus.x > mx) {
				focus.x = mx;
			}
			else if (focus.x < -mx) {
				focus.x = -mx;
			}
			if (focus.y > my) {
				focus.y = my;
			}
			else if (focus.y < -my) {
				focus.y = -my;
			}
		}
		return focus;
	}
}