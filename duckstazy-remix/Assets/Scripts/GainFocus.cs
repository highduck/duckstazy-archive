using UnityEngine;

public class GainFocus : MonoBehaviour {
	public bool paused = true;

    void OnGUI() {
	    if (paused) {
		    var sw = Screen.width;
		    var sh = Screen.height;
		    var w = 300f;
		    var h = 100f;
		    if (GUI.Button(new Rect((sw-w)/2f, (sh-h)/2f, w, h), "Game paused\nСlick anywhere to gain focus")) {
			    paused = false;
		    }
	    }
    }

    void OnApplicationFocus(bool focusStatus) {
        paused = !focusStatus;
    }
}
