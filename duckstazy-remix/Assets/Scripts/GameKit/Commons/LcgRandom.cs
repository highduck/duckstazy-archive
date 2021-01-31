using System;

namespace GameKit.Commons {

	public sealed class LcgRandom {

		private const uint A = 16807;
		private const uint C = 12345;
		private const uint Mask = 0x7fffffff;
		private const double InvMax = 1.0/Mask;

		private int _seed;

		public LcgRandom(int seed = -1) {
			_seed = seed < 0 ? GenerateSeed() : seed;
		}

		public int Seed {
			get { return _seed; }
			set { _seed = value; }
		}

		public int Next() {
			_seed = (int) ((A*_seed + C) & Mask);
			return _seed;
		}

		// [0 .. length)
		public int Next(int length) {
			return (int) (InvMax*length*Next());
		}

		// [min .. max)
		public int Next(int min, int max) {
			return min + (int)(InvMax*(max-min)*Next());
		}

		// [0 .. 1)
		public float NextFloat() {
			return (float) (Next()*InvMax);
		}

		// [0 .. max)
		public float NextFloat(float max) {
			return (float) (max*Next()*InvMax);
		}

		// [min .. max)
		public float NextFloat(float min, float max) {
			return (float) (min + (max - min)*Next()*InvMax);
		}


		private static int _globalSeedIndex;
		private static int GenerateSeed() {
			return (int) ((new Random((int)((DateTime.UtcNow.Ticks + 500*(_globalSeedIndex++)) & 0xffffffff))).Next() & Mask);
		}
	}

}