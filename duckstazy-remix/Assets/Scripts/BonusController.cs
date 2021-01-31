using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Arbiter))]
public class BonusController : MonoBehaviour {

	public SoundClip sfxCollect;
	public Arbiter Arbiter;

	void Awake() {
		Arbiter = GetComponent<Arbiter>();
	}

	void OnEnable() {
		Arbiter.TriggerEntered += Collide;
	}

	public void Collide(GameObject other) {
		if (sfxCollect != null) {
			sfxCollect.PlayAtSource(other.GetComponent<AudioSource>());
		}
		other.GetComponent<PlayerView>().PlayPulse();
		Destroy(gameObject);
	}
}
