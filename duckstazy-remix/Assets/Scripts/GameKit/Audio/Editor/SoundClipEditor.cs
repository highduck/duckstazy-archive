using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.Linq;

[CustomEditor(typeof (SoundClip))]
public class SoundClipEditor : Editor {

	[MenuItem("Assets/Create/Sound Clip")]
	public static void CreateAssetFromFiles() {
		var audioClips = Selection.GetFiltered(typeof (AudioClip), SelectionMode.Assets).OfType<AudioClip>().ToArray();
		var soundClip = CustomAssetUtility.CreateAsset<SoundClip>();
		soundClip.AudioClips = audioClips;
		EditorUtility.SetDirty(soundClip);
	}

	[MenuItem("Assets/Create/Sound Clip Per File")]
	public static void CreateAssetPerFile() {
		var audioClips = Selection.GetFiltered(typeof (AudioClip), SelectionMode.Assets).OfType<AudioClip>().ToArray();
		foreach (var audioClip in audioClips) {
			var soundClip = CustomAssetUtility.CreateAsset<SoundClip>(audioClip.name);
			soundClip.AudioClips = new[] {audioClip};
			EditorUtility.SetDirty(soundClip);
		}
	}

	public override void OnInspectorGUI() {
		DrawDefaultInspector();
		var target = this.target as SoundClip;
		if (target == null) {
			return;
		}
		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.PrefixLabel("Preview");
		if (GUILayout.Button("Play", EditorStyles.miniButton)) {
			Play(target.Next(), target.NextVolume(), target.NextPan(), target.NextPitch());
		}
		EditorGUILayout.EndHorizontal();
	}

	private static readonly List<AudioSource> PreviewSources = new List<AudioSource>();
	public static void Play(AudioClip clip, float volume, float pan, float pitch) {
		if (pitch <= 0.001f) {
			return;
		}

		for (var i = 0; i < PreviewSources.Count; ++i) {
			var source = PreviewSources[i];
			if (!source.isPlaying) {
				DestroyImmediate(source.gameObject, false);
				PreviewSources.RemoveAt(i);
				continue; 
			}
			++i;
		}

		var gameObject = new GameObject("Preview Audio") {hideFlags = HideFlags.HideAndDontSave};
		var audioSource = gameObject.AddComponent<AudioSource>();
		audioSource.clip = clip;
		audioSource.volume = volume;
		audioSource.panStereo = pan;
		audioSource.pitch = pitch;
		audioSource.Play();
		PreviewSources.Add(audioSource);
	}
}
