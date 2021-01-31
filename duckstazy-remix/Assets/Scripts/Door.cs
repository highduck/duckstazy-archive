using UnityEngine;
using System.Collections;

public class Door : MonoBehaviour {

	public tk2dSprite spriteBody;
	public tk2dSprite spriteTop;

	private Arbiter _arbiter;
	private PlayerData _playerData;
	private bool _opened;
	
	void Awake () {
		_arbiter = GetComponentInChildren<Arbiter>();
	}

	void OnEnable() {
		_arbiter.TriggerEntered += Collide;
	}

	private void Collide(GameObject other) {
		if (_playerData.character == other.transform && _opened) {
			GameManager.instance.OnPlayerExit(_playerData);
		}
	}

	void ConnectPlayerData(PlayerData pd) {
		_playerData = pd;
		if (pd.lockBase != null) {
			pd.lockBase.changed += LockBase_Changed;
		}
		spriteBody.color = pd.color;
	}

	private void LockBase_Changed(LockBase sender) {
		_opened = sender.isOpened;

		spriteTop.scale = new Vector3(1f - 0.5f*sender.openingProgress, 1f);
		spriteTop.GetComponent<Renderer>().enabled = !_opened;
	}
}
