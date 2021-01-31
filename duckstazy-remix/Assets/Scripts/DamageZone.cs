using UnityEngine;

[RequireComponent(typeof(Arbiter))]
public class DamageZone : MonoBehaviour {

	public int DamageAmount;
	public float KickTimeOut = -1f;
	public Vector2 KickPower = new Vector2(2f, 3f);
	Arbiter _arbiter;

	// Use this for initialization
	void Awake () {
		_arbiter = GetComponent<Arbiter>();
	}

	void OnEnable() {
		_arbiter.TriggerEntered += Collide;
	}

	public void Collide(GameObject other) {
		var health = other.GetComponent<Health>();
		if (Health.CheckForDamage(health)) {
			health.Damage(DamageAmount);
			health.Kick(KickPower, KickTimeOut);
		}
	}
}
