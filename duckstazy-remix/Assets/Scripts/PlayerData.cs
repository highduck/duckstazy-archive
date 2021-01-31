using System;
using UnityEngine;

[Serializable]
public class PlayerData {
	public int index;
	public Color color = Color.white;
	public Transform character;
	public LockBase lockBase;
	public Door door;

	public void Connect() {
		if (character != null) {
			character.SendMessage("ConnectPlayerData", this);
		}
		if (lockBase != null) {
			lockBase.SendMessage("ConnectPlayerData", this);
		}
		if (door != null) {
			door.SendMessage("ConnectPlayerData", this);
		}
	}
}

