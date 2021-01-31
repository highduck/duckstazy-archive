using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;

[RequireComponent(typeof (Arbiter))]
public class LockBase : MonoBehaviour {
	private PlayerData _playerData;
	private Arbiter _arbiter;
	private List<Key> _touchList = new List<Key>();
	private List<Key> _keys = new List<Key>();
	private List<Transform> _slots = new List<Transform>();

	public event Action<LockBase> changed;

	private void Awake() {
		_arbiter = GetComponent<Arbiter>();
		for (var i = 1; i <= 4; ++i) {
			_slots.Add(transform.Find("Slot" + i));
		}
	}

	private void OnEnable() {
		_arbiter.TriggerEntered += TriggerEnter;
		_arbiter.TriggerExited += TriggerExit;
	}

	private void TriggerEnter(GameObject other) {
		var key = other.GetComponent<Key>();
		if (key != null)
			_touchList.Add(key);
	}

	private void TriggerExit(GameObject other) {
		var key = other.GetComponent<Key>();
		if (key != null)
			_touchList.Remove(key);
	}

	// Use this for initialization
	private void Start() {}

	// Update is called once per frame
	private void Update() {
		if (_keys.Count < 4 && _touchList.Count > 0) {
			var item = _touchList[0];
			if (item.Carrier == null) {
				InsertKey(item);
				_touchList.RemoveAt(0);
			}
		}
	}

	private void InsertKey(Key key) {
		key.Carrier = this;
		var slot = _slots[_keys.Count];
		key.transform.parent = slot;
		_keys.Add(key);
		key.transform.localEulerAngles = Vector3.zero;
		key.transform.localPosition = Vector3.zero;
		key.transform.localScale = Vector3.one;
		if (changed != null) {
			changed(this);
		}
	}

	public IPickable ExtractPickable() {
		if (_keys.Count > 0) {
			var lastIndex = _keys.Count - 1;
			var key = _keys[lastIndex];
			_keys.RemoveAt(lastIndex);
			key.transform.parent = null;
			key.Carrier = null;

			if (changed != null) {
				changed(this);
			}
			return key;
		}
		return null;
	}

	private void ConnectPlayerData(PlayerData pd) {
		_playerData = pd;
		GetComponent<tk2dSprite>().color = color;
	}

	public Color color {
		get { return _playerData != null ? _playerData.color : Color.white; }
	}

	public float openingProgress {
		get { return _keys.Count/4f; }
	}

	public bool isOpened {
		get { return _keys.Count >= 4; }
	}

}
