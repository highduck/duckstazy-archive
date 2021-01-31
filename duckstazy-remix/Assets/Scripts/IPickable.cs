using UnityEngine;

public interface IPickable {
	MonoBehaviour Carrier { get; set; }
	void SetDropVelocity(Vector2 velocity);
}
