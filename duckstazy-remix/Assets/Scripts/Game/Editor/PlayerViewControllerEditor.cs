using UnityEditor;
using UnityEngine;

[CustomEditor(typeof (PlayerViewController))]
public class PlayerViewControllerEditor : Editor {
	public override void OnInspectorGUI() {
		DrawDefaultInspector();
		
		if (GUILayout.Button("Respawn")) {
			if (target != null) {
				(target as PlayerViewController).GetComponent<Health>().Respawn();
			}
		}

		if (GUILayout.Button("Shake")) {
			Camera.main.GetComponent<RandomShaker>().Shake(10f, 0.5f);
		}
	}
}