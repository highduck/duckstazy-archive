using System;
using System.Collections.Generic;
using UnityEngine;

public class Carrier : MonoBehaviour {
	private enum Command {
		Nothing,
		Pick,
		Drop
	};

	public float DropCheckOffset = 0.38f;

	public Arbiter Hands;

	private DuckState _state;
	private List<MonoBehaviour> _availableItems = new List<MonoBehaviour>();
	private LockBase _lockBase;
	private MonoBehaviour _pickedItem;

	private Transform _prevParent;
	private Command _command = Command.Nothing;

	public event Action<IPickable> Dropped;
	public event Action<IPickable> Picked;

	void Awake() {
		_state = GetComponent<DuckState>();
	}

	void OnEnable() {
		Hands.TriggerEntered += Collide;
		Hands.TriggerExited += CollideExit;
	}

	public void Collide(GameObject other) {
		//Debug.Log("enter: " + other.name);
		var item = other.GetComponent(typeof(IPickable)) as IPickable;
		if (item != null && !_availableItems.Contains(item as MonoBehaviour)) {
			_availableItems.Add(item as MonoBehaviour);
			return;
		}
		var lockBase = other.GetComponent<LockBase>();
		if (lockBase != null) {
			_lockBase = lockBase;
		}
	}

	public void CollideExit(GameObject other) {
		//Debug.Log("exit: " + other.name);
		var item = other.GetComponent(typeof(IPickable)) as IPickable;
		if (item != null) {
			_availableItems.Remove(item as MonoBehaviour);
			return;
		}
		var lockBase = other.GetComponent<LockBase>();
		if (lockBase == _lockBase) {
			_lockBase = null;
		}
	}

	public void FixedUpdate() {
		switch (_command) {
			case Command.Pick:
				DoPickUp();
				break;
			case Command.Drop:
				DoDropDown();
				break;
		}
		_command = Command.Nothing;
	}

	public void PickUp() {
		_command = Command.Pick;
	}

	private bool DoPickUp() {
		if (_pickedItem != null) {
			return false;
		}

		MonoBehaviour item = null;
		IPickable pickable = null;

		foreach (var it in _availableItems) {
			pickable = it as IPickable;
			item = it;
			if (pickable != null) {
				break;
			}
		}

		if (item == null && _lockBase != null) {
			pickable = _lockBase.ExtractPickable();
			item = pickable as MonoBehaviour;
		}

		if (item != null && pickable != null && pickable.Carrier == null) {
			pickable.Carrier = this;
			_prevParent = item.transform.parent;

			var tr = item.transform;
			tr.parent = Hands.transform;
			tr.localEulerAngles = Vector3.zero;
			tr.localPosition = Vector3.zero;
			tr.localScale = Vector3.one;

			_pickedItem = item;

			Hands.CollidersEnabled = false;
			_availableItems.Clear();
			_lockBase = null;
		}

		if (_pickedItem != null) {
			_availableItems.Remove(_pickedItem);
			if (Picked != null) {
				Picked(_pickedItem as IPickable);
			}
			return true;
		}
		return false;
	}

	public void DropDown() {
		_command = Command.Drop;
	}

	public bool DoDropDown() {
		var item = _pickedItem;
		var pickable = item as IPickable;
		if (pickable != null) {
			// reset parenting
			var tr = item.transform;
			tr.parent = _prevParent;

			// preserve penetration
			var dx = DropCheckOffset*_state.LookDirection;
			var p = tr.localPosition;
			p.x -= dx;
			tr.localPosition = p;
			var movement = item.GetComponent<Movement2D>();
			movement.Move(new Vector3(dx, 0f, 0f));

			// clear state
			pickable.Carrier = null;
			_pickedItem = null;
			_prevParent = null;

			// enable arbiter
			Hands.CollidersEnabled = true;

			// send message
			if (Dropped != null) {
				Dropped(pickable);
			}
			return true;
		}
		return false;
	}

	public bool IsCarrying {
		get { return _pickedItem != null; }
	}

	public void Toggle() {
		if (IsCarrying) {
			DropDown();
		}
		else {
			PickUp();
		}
	}
}
