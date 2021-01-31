using System.Collections.Generic;
using GameKit.Commons;
using UnityEngine;

public class RandomShaker : MonoBehaviour {
	[Range(10, 60)]
	public float ShakesPerSecond = 30f;

	[Range(1, 8)]
	public float OffsetQuant = 1f;

	public AnimationCurve Attenuation = AnimationCurve.Linear(0f, 1f, 1f, 0f);

	private Vector2 _position;
	private Vector2 _offset;
	private float _shakeTimer;
	private float _shakeCounter;
	private readonly List<ShakeObject> _shakes = new List<ShakeObject>();

	public Vector2 Position {
		get { return _position; }
	}

	void Update() {
		float dt = Time.deltaTime;
		float value = 0f;
		int i = 0;

		while (i < _shakes.Count) {
			var shake = _shakes[i];
			value = Mathf.Max(value, shake.Strength*Attenuation.Evaluate(shake.Tween));
			shake.Tween += dt*shake.Speed;
			if (shake.Tween >= 1f) {
				_shakes.RemoveAt(i);
			}
			else {
				++i;
			}
		}

		if (value > 0f) {
			var rate = 1f/ShakesPerSecond;
			_shakeTimer += dt;
			while (_shakeTimer > rate) {
				++_shakeCounter;
				if ((_shakeCounter%2) > 0) {
					_offset.x = value*Mathf.Sign(FastMath.Random(-1f, 1f));
					_offset.y = value*Mathf.Sign(FastMath.Random(-1f, 1f));
				}
				else {
					_offset.Set(0f, 0f);
				}
				_shakeTimer -= rate;
			}

			_position.x = ((int) (_offset.x*OffsetQuant))/OffsetQuant;
			_position.y = ((int) (_offset.y*OffsetQuant))/OffsetQuant;
		}
		else {
			_position.Set(0f, 0f);
		}
	}

	public void Shake(float strength = 8f, float time = 1f) {
		_shakes.Add(new ShakeObject {
				Strength = strength,
				Time = time
			});
	}

	class ShakeObject {
		public float Tween;
		public float Speed;
		public float Strength;

		public float Time {
			get { return 1f/Speed; }
			set { Speed = 1f/value; }
		}
	}
}


