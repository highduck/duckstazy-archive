using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class XMath {
	public static float AddByMod(float current, float end, float mod)
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

	public static float Lerp(float start, float end, float time)
	{
		float result = start + (end - start)*time;
			
		if(start < end)
		{
			if(result > end) {
				return end;
			}
			if(result < start) {
				return start;
			}
		}
		else
		{
			if(result < end) {
				return end;
			}
			if(result > start) {
				return start;
			}
		}
			
		return result;
	}
}
