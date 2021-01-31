package com.ek.duckstazy.utils
{
	/**
	 * @author eliasku
	 */
	public class XRandom
	{
		private static var _seed:int;
		private static const A:uint = 16807;
		private static const C:uint = 12345;
		private static const MASK:uint = 0x7fffffff;
		
		public static function shuffle():void
		{
			_seed = int((new Date()).time);
		}
		
		public static function set seed(value:Number):void
		{
			_seed = value & 0x7fffffff;
		}
 
 		public static function random(min:Number = 0.0, max:Number = 1.0):Number
 		{
 			_seed = (A * _seed + C) & MASK;
			return min + (max - min) * Number(_seed / 0x7fffffff);
		}

		static public function get seed():Number
		{
			return _seed;
		}
	}
}
