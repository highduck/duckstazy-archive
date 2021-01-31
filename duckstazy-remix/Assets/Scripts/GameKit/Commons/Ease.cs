using UnityEngine;

public class Ease {
	public delegate float Function(float ratio);

	public static float backOut(float ratio, float s = 1.70158f) {
		return (ratio -= 1.0f)*ratio*((s + 1.0f)*ratio + s) + 1.0f;
	}

	public static float cubicOut(float ratio) {
		return (ratio -= 1)*ratio*ratio + 1;
	}

	public static float cubicIn(float ratio) {
		return ratio*ratio*ratio;
	}

	public static float CubicInOut(float ratio) {
		return (ratio < 0.5) ? 4f*ratio*ratio*ratio : 4f*(ratio -= 1f)*ratio*ratio + 1f;
	}

	public static float quadraticIn(float ratio) {
		return ratio*ratio;
	}

	public static float quadraticOut(float ratio) {
		return -ratio*(ratio - 2);
	}

	public static float quadraticInOut(float ratio) {
		return (ratio < 0.5) ? 2*ratio*ratio : -2*ratio*(ratio - 2) - 1;
	}

	public static float linear(float ratio) {
		return ratio;
	}

	public static float expIn(float ratio) {
		return (ratio > 0f) ? Mathf.Pow(2f, 10f*(ratio - 1f)) : 0f;
	}

	public static float expOut(float ratio) {
		return (ratio >= 1.0f) ? 1.0f : 1.0f - Mathf.Pow(2.0f, -10.0f*ratio);
	}

	public static float expInOut(float ratio) {
		if (ratio <= 0.0f || ratio >= 1.0f) {
			return ratio;
		}
		if (0.0f > (ratio = ratio*2.0f - 1.0f)) {
			return 0.5f*Mathf.Pow(2.0f, 10f*ratio);
		}
		return 1.0f - 0.5f*Mathf.Pow(2.0f, -10f*ratio);
	}


	public static float QuintIn(float ratio) {
		return ratio*ratio*ratio*ratio*ratio;
	}

	public static float QuintOut(float ratio) {
		return 1f + (ratio -= 1f)*ratio*ratio*ratio*ratio;
	}

	public static float QuintInOut(float ratio) {
		return (ratio < 0.5f) ? 16f*ratio*ratio*ratio*ratio*ratio : 16f*(ratio -= 1f)*ratio*ratio*ratio*ratio + 1f;
	}
}
