using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace GameKit.Commons {

	public static class FastMath {

		public const float Epsilon = 0.00001f;
		public const float Pi = 3.1415927f;
		public const float PiTwo = Pi*2f;
		public const float PiHalf = Pi*0.5f;
		public const float RadiansToDegrees = 180f/Pi;
		public const float DegreesToRadians = Pi/180f;
		//public const float nanoToSec = 1 / 1000000000f;

		private const float NearlyOne = 0.9999999f;
		private const float RadFull = PiTwo;
		private const float DegFull = 360f;
		private const float RadToIndex = SinCount/RadFull;
		private const float DegToIndex = SinCount/DegFull;

		private const int SinBits = 14; // 16KB. Adjust for accuracy.
		private const int SinMask = ~(-1 << SinBits);
		private const int SinCount = SinMask + 1;
		private static readonly float[] _sinTable = new float[SinCount];

		private const int Atan2Bits = 7; // Adjust for accuracy.
		private const int Atan2Bits2 = Atan2Bits << 1;
		private const int Atan2Mask = ~(-1 << Atan2Bits2);
		private const int Atan2Count = Atan2Mask + 1;
		private static readonly int Atan2Dim = (int) Math.Sqrt(Atan2Count);
		private static readonly float Atan2InvDimMinus1 = 1.0f/(Atan2Dim - 1);
		private static readonly float[] _atan2Table = new float[Atan2Count];

		private static readonly LcgRandom Generator = new LcgRandom();

		static FastMath() {
			// sin table
			for (int i = 0; i < SinCount; ++i) {
				_sinTable[i] = (float) Math.Sin((i + 0.5f)/SinCount*RadFull);
			}
			for (int i = 0; i < 360; i += 90) {
				_sinTable[(int) (i*DegToIndex) & SinMask] = (float) Math.Sin(i*DegreesToRadians);
			}

			// atan2 table
			for (int i = 0; i < Atan2Dim; ++i) {
				for (int j = 0; j < Atan2Dim; ++j) {
					float x0 = (float) i/Atan2Dim;
					float y0 = (float) j/Atan2Dim;
					_atan2Table[j*Atan2Dim + i] = (float) Math.Atan2(y0, x0);
				}
			}
		}

		public static float Sin(float radians) {
			return _sinTable[(int) (radians*RadToIndex) & SinMask];
		}

		public static float Cos(float radians) {
			return _sinTable[(int) ((radians + PiHalf)*RadToIndex) & SinMask];
		}

		public static float SinDeg(float degrees) {
			return _sinTable[(int) (degrees*DegToIndex) & SinMask];
		}

		public static float CosDeg(float degrees) {
			return _sinTable[(int) ((degrees + 90)*DegToIndex) & SinMask];
		}

		public static float Atan2(float y, float x) {
			float add, mul;
			if (x < 0f) {
				if (y < 0f) {
					y = -y;
					mul = 1f;
				}
				else {
					mul = -1f;
				}
				x = -x;
				add = -Pi;
			}
			else {
				if (y < 0f) {
					y = -y;
					mul = -1f;
				}
				else {
					mul = 1f;
				}
				add = 0f;
			}
			float invDiv = 1f/((x < y ? y : x)*Atan2InvDimMinus1);

			if (float.IsPositiveInfinity(invDiv)) {
				return ((float) Math.Atan2(y, x) + add)*mul;
			}

			var xi = (int) (x*invDiv);
			var yi = (int) (y*invDiv);
			return (_atan2Table[yi*Atan2Dim + xi] + add)*mul;
		}

		private const int ApproxSqrtBit1 = 1 << 23;
		private const int ApproxSqrtBit2 = 1 << 29;
		private const int ApproxSqrtMagicBits = 0x5f375a86;
		private static readonly FloatBits FloatBitsConverter = new FloatBits(0f);

		public static float SqrtRough(float f) {
			if (f <= 0.0f) {
				return 0.0f;
			}
			FloatBits fb = FloatBitsConverter;
			fb.Value = f;
			fb.Bits = ((fb.Bits - ApproxSqrtBit1) >> 1) + ApproxSqrtBit2;
			return fb.Value;
		}

		public static float Sqrt(float f) {
			FloatBits fb = FloatBitsConverter;
			fb.Value = f;
			fb.Bits = ApproxSqrtMagicBits - (fb.Bits >> 1);
			return f*fb.Value*(1.5f - 0.5f*f*fb.Value*fb.Value);
		}

		public static int Abs(int x) {
			return x < 0 ? -x : x;
		}

		public static float Abs(float x) {
			return x < 0f ? -x : x;
		}

		public static float Min(float a, float b) {
			return a < b ? a : b;
		}

		public static int Min(int a, int b) {
			return a < b ? a : b;
		}

		public static float Max(float a, float b) {
			return a > b ? a : b;
		}

		public static int Max(int a, int b) {
			return a > b ? a : b;
		}

		public static int Floor(float x) {
			return x >= 0f ? (int) x : (int) (x - NearlyOne);
		}

		public static int FloorPositive(float x) {
			return (int) x;
		}

		public static int Ceil(float x) {
			return x > 0f ? (int) (x + NearlyOne) : (int) (x);
		}

		public static int CeilPositive(float x) {
			return (int) (x + NearlyOne);
		}

		public static int Round(float x) {
			return x > 0f ? (int) (x + 0.5f) : (int) (x - 0.5f);
		}

		/** Returns the closest integer to the specified float. This method will only properly round floats that are positive. */

		public static int RoundPositive(float x) {
			return (int) (x + 0.5f);
		}

		public static bool Equals(float a, float b) {
			return (a > b ? a - b : b - a) <= float.Epsilon;
		}

		public static bool Equals(Vector2 a, Vector2 b) {
			return Equals(a.x, b.x) && Equals(a.y, b.y);
		}

		/*
		// [0 .. length-1]
		public static int Roll(int length)
		{
			return Random.Roll(length);
		}

		// [0 .. max]
		public static float Range(float max)
		{
			return Random.Range(max);
		}

		// [0 .. 1]
		public static float Range()
		{
			return Random.Range(1f);
		}

		// [min .. max]
		public static float Range(float min, float max)
		{
			return Random.Range(min, max);
		}

		// [min .. max]
		public static int Range(int min, int max)
		{
			return (min + Random.Roll(max - min + 1));
		}

		// [-bounds .. bounds]
		public static float Symmetric(float bounds)
		{
			return Random.Range(-bounds, bounds);
		}

		public static Vector2 Direction(float length = 1.0f)
		{
			return Random.Direction(length);
		}

		public static Vector2 SpreadDirection(Vector2 baseDirection, float angleSpread = 0f, float length = 1.0f)
		{
			return Random.SpreadDirection(baseDirection, angleSpread, length);
		}*/

		public static float Random() {
			return Generator.NextFloat();
		}

		public static float Random(float max) {
			return Generator.NextFloat(max);
		}

		public static float Random(float min, float max) {
			return Generator.NextFloat(min, max);
		}

		public static int Random(int length) {
			return Generator.Next(length);
		}

		public static int Random(int min, int max) {
			return Generator.Next(min, max);
		}

		public static int Clamp(int x, int min, int max) {
			return (x < min ? min : (x > max ? max : x));
		}

		public static float Clamp(float x, float min, float max) {
			return (x < min ? min : (x > max ? max : x));
		}


		[StructLayout(LayoutKind.Explicit)]
		private struct FloatBits {

			[FieldOffset(0)]
			public float Value;

			[FieldOffset(0)]
			public int Bits;

			public FloatBits(float v) {
				Bits = 0;
				Value = v;
			}

		}

	}

}
