using GameKit.Commons;
using UnityEngine;

public class SoundClip : ScriptableObject {
	private static readonly LcgRandom Random = new LcgRandom();

	public AudioClip[] AudioClips = new AudioClip[0];
	public SoundClipMode Mode = SoundClipMode.Sequence;

	[Range(0f, 1f)]
	public float Volume = 1f;

	[Range(0f, 1f)]
	public float VolumeVariance = 0f;

	[Range(-1f, 1f)]
	public float Pan = 0f;

	[Range(0f, 1f)]
	public float PanVariance = 0f;

	[Range(0f, 10f)]
	public float Pitch = 1f;

	[Range(0f, 10f)]
	public float PitchVariance = 0f;

	private int _soundIndex;

	public AudioClip Next() {
		if (AudioClips.Length == 0) {
			return null;
		}

		AudioClip sound = AudioClips[_soundIndex];
		switch (Mode) {
			case SoundClipMode.Sequence:
				if (++_soundIndex >= AudioClips.Length) {
					_soundIndex = 0;
				}
				break;
			case SoundClipMode.Random:
				_soundIndex = Random.Next(AudioClips.Length);
				break;
		}
		return sound;
	}

	public float NextVolume() {
		if (VolumeVariance > 0f) {
			return Random.NextFloat(Volume - VolumeVariance, Volume + VolumeVariance);
		}
		return Volume;
	}

	public float NextPan() {
		if (PanVariance > 0f) {
			return Random.NextFloat(Pan - PanVariance, Pan + PanVariance);
		}
		return Pan;
	}

	public float NextPitch() {
		if (PitchVariance > 0f) {
			return Random.NextFloat(Pitch - PitchVariance, Pitch + PitchVariance);
		}
		return Pitch;
	}

	public void PlayAtSource(AudioSource source, float volume = 1f, float panOffset = 0f, float pitchOffset = 0f) {
		source.volume = NextVolume()*volume;
		source.panStereo = NextPan() + panOffset;
		source.pitch = NextPitch() + pitchOffset;
		source.PlayOneShot(Next());
	}
}

public enum SoundClipMode {
	Sequence,
	Random
}