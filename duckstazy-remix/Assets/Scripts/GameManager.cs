using System.Collections.Generic;
using UnityEngine;

public class GameManager: MonoBehaviour {

	public PlayerData[] players;

	void Awake() {
		var characterList = new List<Transform>();
		var index = 0;
		foreach (var player in players) {
			characterList.Add(player.character);
			player.index = index;
			player.character.SendMessage("ConnectPlayerData", player);
			player.lockBase.SendMessage("ConnectPlayerData", player);
			player.door.SendMessage("ConnectPlayerData", player);
			++index;
		}
		Camera.main.GetComponent<CameraFollow2D>().Targets = characterList.ToArray();
	}

	private static GameManager _instance;
	public static GameManager instance {
		get { return _instance; }
	}

	void OnEnable() {
		_instance = this;
	}

	public void OnPlayerExit(PlayerData playerData) {
		Application.LoadLevel(0);
	}
}
