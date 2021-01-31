using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Arbiter : MonoBehaviour {

	public string[] tags;
	public GameObject externalMaster = null;

	public bool triggerMode = true;
	public bool startEnabled = true;
	public bool receiveCollisions = true;
	public string receiveTag;

	public event Action<GameObject> TriggerEntered;
	public event Action<GameObject> TriggerExited;

	private GameObject _master;
	private Collider[] _colliders;
	private BoxCollider _boxCollider;

	void Awake() {
		_master = externalMaster != null ? externalMaster : gameObject;
		_colliders = GetComponents<Collider>();
		_boxCollider = GetComponent<BoxCollider>();
		if (_colliders.Length == 0) {
			Debug.LogError("Collision Handler hasn't any colliders");
		}
		_collidersEnabled = startEnabled;
		foreach (var coll in _colliders) {
			coll.isTrigger = triggerMode;
			coll.enabled = startEnabled;
		}
	}

	private bool _collidersEnabled;
	public bool CollidersEnabled {
		get { return _collidersEnabled; }
		set {
			_collidersEnabled = value;
			foreach (var col in _colliders) {
				col.enabled = value;
			}
		}
	}

	public BoxCollider BoxCollider {
		get { return _boxCollider; }
	}

	void OnTriggerEnter(Collider other) {
		if (!receiveCollisions || TriggerEntered == null) {
			return;
		}
		var otherArbiter = other.GetComponent<Arbiter>();
		if (otherArbiter == null || otherArbiter._master == _master) {
			return;
		}
		if (otherArbiter.ContainsTag(receiveTag)) {
			TriggerEntered(otherArbiter._master);
		}
	}
	
	void OnTriggerExit(Collider other) {
		if (!receiveCollisions || TriggerExited == null) {
			return;
		}
		var otherArbiter = other.GetComponent<Arbiter>();
		if (otherArbiter == null || otherArbiter._master == _master) {
			return;
		}
		if (otherArbiter.ContainsTag(receiveTag)) {
			TriggerExited(otherArbiter._master);
		}
	}

	bool ContainsTag(string tag) {
		return string.IsNullOrEmpty(tag) || Array.IndexOf(tags, tag) >= 0;
	}
}