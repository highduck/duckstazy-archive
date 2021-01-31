using UnityEngine;

[RequireComponent(typeof(MovableBody))]
public class Key : MonoBehaviour, IPickable {

	public tk2dSprite TopSprite;

	private MovableBody _body;
	private MonoBehaviour _carrier;
	private LockBase _ownerLockBase;

	public MonoBehaviour Carrier {
		get {
			return _carrier;
		} 
		set {
			if (_carrier == value) {
				return;
			}
			_carrier = value;
			SetLockBase(value as LockBase);
			_body.IsKinematic = (_carrier != null);
		} 
	}

	private void SetLockBase(LockBase lockBase) {
		if (lockBase != null) {
			SetOwnerLockBase(lockBase);
		}
	}

	private void SetOwnerLockBase(LockBase lockBase) {
		_ownerLockBase = lockBase;
		TopSprite.color = (_ownerLockBase != null) ? _ownerLockBase.color : Color.white;
	}

	public void SetDropVelocity(Vector2 velocity) {
		_body.ApplyVelocity(velocity);
	}

	// Use this for initialization
	void Awake () {
		_body = GetComponent<MovableBody>();
	}
}
