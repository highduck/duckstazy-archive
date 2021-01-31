package com.ek.duckstazy.utils {

	/**
	 * @author eliasku
	 */
	public class XMath 
	{
		public static function add(current:Number, mod:Number, min:Number, max:Number):Number
		{
			if(mod < 0.0)
			{
				if(current < min) {
					return current;
				}
				
				current += mod;
				if(current < min) {
					current = min;
				}
				
				return current;
			}
			
			if(current > max) {
				return current;
			}
			
			current += mod;
			if(current > max) {
				current = max;
			}
			
			return current;
		}
		
		public static function addByMod(current:Number, end:Number, mod:Number):Number
		{
			if(current < end)
			{
				current += mod;
				if(current > end) {
					current = end;
				}
				
				return current;
			}
			
			current -= mod;
			if(current < end) {
				current = end;
			}
			
			return current;
		}
		
		public static function lerp(begin:Number, end:Number, t:Number):Number
		{
			const result:Number = begin + (end - begin)*t;
			
			if(begin < end)
			{
				if(result > end) {
					return end;
				}
				else if(result < begin) {
					return begin;
				}
			}
			else
			{
				if(result < end) {
					return end;
				}
				else if(result > begin) {
					return begin;
				}
			}
			
			return result;
		}
		
		public static function sign(value:Number):Number
		{
			if(value >= 0.0) {
				return 1.0;
			}
			
			return -1.0;
		}
		
		public static function clamp(value:Number, min:Number = 0.0, max:Number = 1.0):Number
		{
			if(value > max) {
				return max;
			}
			
			else if(value < min) {
				return min;
			}
			
			return value;
		}
		
		
		
		
		
	}
}
