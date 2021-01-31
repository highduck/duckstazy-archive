using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

static class TweenHelper {

	public static bool Tween01(bool state, ref float currentTime, float time) {
		if (state && currentTime < 1.0f) {
			currentTime += time;
			if (currentTime > 1.0f) {
				currentTime = 1.0f;
			}
			return true;
		}

		if (!state && currentTime > 0.0f) {
			currentTime -= time;
			if (currentTime < 0.0f) {
				currentTime = 0.0f;
			}
			return true;
		}

		return false;
	}

	public static bool Tween01(bool state, ref float currentTime, float deltaTime, float upSpeed, float downSpeed) {
		if (state && currentTime < 1.0f) {
			currentTime += deltaTime*upSpeed;
			if (currentTime > 1.0f) {
				currentTime = 1.0f;
			}
			return true;
		}

		if (!state && currentTime > 0.0f) {
			currentTime -= deltaTime*downSpeed;
			if (currentTime < 0.0f) {
				currentTime = 0.0f;
			}
			return true;
		}

		return false;
	}
}

