using UnityEngine;

public class DuckAnimationEvents : MonoBehaviour {

	public GameObject master;

	void PlayFlySound() {
		master.SendMessage("PlayFlySound");
	}

	void PlayStepSound() {
		master.SendMessage("PlayStepSound");
	}
}
