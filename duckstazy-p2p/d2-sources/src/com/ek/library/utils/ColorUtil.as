package com.ek.library.utils
{
	import flash.geom.ColorTransform;

	/**
	 * @author eliasku
	 */
	public class ColorUtil 
	{
		
		public static function interpolateTransform(begin:ColorTransform, end:ColorTransform, t:Number, out:ColorTransform = null):ColorTransform
		{
			const inv:Number = 1.0 - t;
			
			if(!out) out = new ColorTransform();
			
			out.alphaMultiplier = inv * begin.alphaMultiplier + t * end.alphaMultiplier;
			out.redMultiplier = inv * begin.redMultiplier + t * end.redMultiplier;
			out.greenMultiplier = inv * begin.greenMultiplier + t * end.greenMultiplier;
			out.blueMultiplier = inv * begin.blueMultiplier + t * end.blueMultiplier;
			
			out.alphaOffset = inv * begin.alphaOffset + t * end.alphaOffset;
			out.redOffset = inv * begin.redOffset + t * end.redOffset;
			out.greenOffset = inv * begin.greenOffset + t * end.greenOffset;
			out.blueOffset = inv * begin.blueOffset + t * end.blueOffset;
			
			return out;
		}
				
		public static function getTransform(multiplyARGB:uint = 0xffffffff, addARGB:uint = 0x00000000, out:ColorTransform = null):ColorTransform
		{
			const m:Number = 1.0/255.0;
			
			if(!out) out = new ColorTransform();
			
			out.alphaMultiplier = m * ( ( multiplyARGB >> 24 ) & 0xFF );
			out.redMultiplier = m * ( ( multiplyARGB >> 16 ) & 0xFF );
			out.greenMultiplier = m * ( ( multiplyARGB >> 8) & 0xFF );
			out.blueMultiplier = m * ( multiplyARGB & 0xFF );
			
			out.alphaOffset = (addARGB >> 24) & 0xFF;
			out.redOffset = (addARGB >> 16) & 0xFF;
			out.greenOffset = (addARGB >> 8) & 0xFF;
			out.blueOffset = addARGB & 0xFF;
			
			return out;
		}
		
		public static function resetTransform(out:ColorTransform = null):ColorTransform
		{
			if(!out) out = new ColorTransform();
			
			out.alphaMultiplier = 
			out.redMultiplier = 
			out.greenMultiplier = 
			out.blueMultiplier = 1.0;
			
			out.alphaOffset = 
			out.redOffset = 
			out.greenOffset = 
			out.blueOffset = 0.0;
			
			return out;
		}
		
		public static function copyTransform(source:ColorTransform, dest:ColorTransform = null):ColorTransform
		{
			if(!dest) dest = new ColorTransform();
			
			dest.alphaMultiplier = source.alphaMultiplier;
			dest.redMultiplier = source.redMultiplier;
			dest.greenMultiplier = source.greenMultiplier;
			dest.blueMultiplier = source.blueMultiplier;
			dest.alphaOffset = source.alphaOffset;
			dest.redOffset = source.redOffset;
			dest.greenOffset = source.greenOffset;
			dest.blueOffset = source.blueOffset;
			
			return dest;
		}
		
		public static function lerpARGB(rgb1:uint, rgb2:uint, t:Number):uint
		{
			var a1:uint = (rgb1 >> 24) & 0xff;
			var r1:uint = (rgb1 >> 16) & 0xff;
			var g1:uint = (rgb1 >> 8) & 0xff;
			var b1:uint = rgb1 & 0xff;
			
			var a2:uint = (rgb2 >> 24) & 0xff;
			var r2:uint = (rgb2 >> 16) & 0xff;
			var g2:uint = (rgb2 >> 8) & 0xff;
			var b2:uint = rgb2 & 0xff;
			
			var a:uint = a1 + (a2 - a1)*t;
			var r:uint = r1 + (r2 - r1)*t;
			var g:uint = g1 + (g2 - g1)*t;
			var b:uint = b1 + (b2 - b1)*t;
			
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
	}
}
