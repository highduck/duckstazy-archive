using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Arbiter))]
public class Blast : MonoBehaviour {
	public Vector2 power = new Vector2(8f, 4f);

	private DuckState _owner;
	private Arbiter _arbiter;
	private readonly List<GameObject> _processed = new List<GameObject>();
	private int _counter;

		// Use this for initialization
	void Awake () {
		_arbiter = GetComponent<Arbiter>();
		_arbiter.CollidersEnabled = false;
		_owner = transform.parent.GetComponent<DuckState>();
	}

	void OnEnable() {
		_arbiter.TriggerEntered += Collide;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		if (_arbiter.CollidersEnabled) {
			++_counter;
			if (_counter > 4) {
				_arbiter.CollidersEnabled = false;
				_processed.Clear();
				_counter = 0;
			}
		}
	}

	public void Collide(GameObject other) {
		if (_processed.Contains(other)) {
			return;
		}
		_processed.Add(other);
		var otherTransform = other.transform;
		if (otherTransform == _owner.transform) {
			return;
		}
		var health = other.GetComponent<Health>();
		if (health == null || health.IsDead || health.IsKicked) {
			return;
		}
		
		var d = (otherTransform.position.x - transform.position.x)/(_arbiter.BoxCollider.size.x/2f);
		if (d > 0f) {
			d = 1f - d;
		}
		else if (d < 0f) {
			d = -1f - d;
		}
		var body = other.GetComponent<MovableBody>();
		if (body != null) {
			body.ApplyVelocity(new Vector2(power.x*d, power.y*Mathf.Abs(d)));
		}
	}

	public void Activate() {
		_arbiter.CollidersEnabled = true;
	}
}
