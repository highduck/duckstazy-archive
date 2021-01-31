using System;
using UnityEngine;

public class MovementManager : MonoBehaviour {

	public Vector2 Gravity = new Vector2(0f, -20f);
	public LayerMask NormalPlatform = 0;
	public LayerMask OneWayPlatform = 0;
	public float DampingAir = 1f;
	public float DampingGround = 10f;

	[NonSerialized]
	public LayerMask Platforms;

	void Awake() {
		if (NormalPlatform == 0) {
			NormalPlatform = LayerMask.NameToLayer("Block");
		}
		if (OneWayPlatform == 0) {
			OneWayPlatform = LayerMask.NameToLayer("UpBlock");
		}
		Platforms = NormalPlatform | OneWayPlatform;
	}

	void OnEnable() {
		_instance = this;
	}

	private static MovementManager _instance;
	public static MovementManager Instance {
		get { return _instance; }
	}

	public float GetDamping(bool grounded) {
		return grounded ? DampingGround : DampingAir;
	}
}

