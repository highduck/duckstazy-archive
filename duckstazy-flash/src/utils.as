package
{
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	public class utils
	{

		public static function lerp(x:Number, a:Number, b:Number):Number
		{
			return a + x*(b - a);
		}
	
		public static function vec2angle(v1:Point, v2:Point):Number
		{
			return Math.atan2(v1.y, v1.x) - Math.atan2(v2.y, v2.x);
		}
		
		public static function vec2norm(vec:Point):Point
		{
			var inv_len:Number = 1.0 / Math.sqrt(vec.x*vec.x + vec.y*vec.y);
			
			return new Point(vec.x*inv_len, vec.y*inv_len);
		}
		
		public static function vec2lenSqr(vec:Point):Number
		{
			return vec.x*vec.x + vec.y*vec.y;
		}
		
		public static function vec2distSqr(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return dx*dx + dy*dy;
		}
		
		public static function vec2norm2(vec1:Point, vec2:Point):Point
		{
			var dx:Number = vec1.x - vec2.x;
			var dy:Number = vec1.y - vec2.y;
			var inv_len:Number = 1.0 / Math.sqrt(dx*dx + dy*dy);
			
			return new Point(dx*inv_len, dy*inv_len);
		}
		
		public static function vec2multScalar(vec:Point, a:Number):Point
		{
			var dx:Number = a*vec.x;
			var dy:Number = a*vec.y;
	
			return new Point(dx, dy);
		}

	
		public static function pos2pan(x:Number):Number
		{
			var p:Number = (x-320.0)/320.0;
			
			if(p>1) p=1;
			else if(p<-1) p=-1;
			
			return p;
		}

		public static function lerpColor(fromColor:uint, toColor:uint, progress:Number):uint
		{
			var q:Number = 1 - progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;
	
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;
			
			var resultA:uint = fromA*q + toA*progress;
			var resultR:uint = fromR*q + toR*progress;
			var resultG:uint = fromG*q + toG*progress;
			var resultB:uint = fromB*q + toB*progress;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			
			return resultColor;		
		}
		
		public static function mixAlpha(color:uint, alpha:Number):uint
		{
			var a:uint = (color >> 24) & 0xFF;
			var rgb:uint = color & 0xFFFFFF;
			
			var resultA:uint = a*alpha;
			
			var resultColor:uint = resultA << 24 | rgb;
			
			return resultColor;		
		}
		
		public static function multColorScalar(color:uint, value:Number):uint
		{
			var a:uint = (color >> 24) & 0xFF;
			var r:uint = (color >> 16) & 0xFF;
			var g:uint = (color >>  8) & 0xFF;
			var b:uint =  color        & 0xFF;
				
			var resultA:uint = a*value;
			var resultR:uint = r*value;
			var resultG:uint = g*value;
			var resultB:uint = b*value;
			
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			
			return resultColor;
		}
		
		public static function ctSetRGB(ct:ColorTransform, rgb:uint):void
		{
			ct.redMultiplier = ((rgb >> 16) & 0xFF)/255.0;
			ct.greenMultiplier = ((rgb >> 8) & 0xFF)/255.0;
			ct.blueMultiplier = (rgb & 0xFF)/255.0;
		}
		
		public static function ARGB2ColorTransform(argb:uint, ct:ColorTransform):void
		{
			var a:uint = (argb >> 24) & 0xFF;
			var r:uint = (argb >> 16) & 0xFF;
			var g:uint = (argb >>  8) & 0xFF;
			var b:uint =  argb        & 0xFF;
			
			ct.redMultiplier = r*0.0039216;
			ct.greenMultiplier = g*0.0039216;
			ct.blueMultiplier = b*0.0039216;
			ct.alphaMultiplier = a*0.0039216;
		}
		
		public static function calcARGB(r:Number, g:Number, b:Number, a:Number):uint
		{
			var resultA:uint = a*255.0;
			var resultR:uint = r*255.0;
			var resultG:uint = g*255.0;
			var resultB:uint = b*255.0;
			
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			
			return resultColor;
		}
		
		public static function splineInter(v0:Number, v1:Number, v2:Number, v3:Number, x:Number):Number
		{ 
			var P:Number = (v3 - v2) - (v0 - v1); 
			var Q:Number = (v0 - v1) - P; 
			var R:Number = v2 - v0; 
			var S:Number = v1; 
		
			var x2:Number = x*x;
			
			return (P*(x2*x)) + (Q*(x2)) + (R*x) + S; 
		}


		public static function rnd_bool():Boolean
		{
			return Math.random()>=0.5;
		}
		
		// [x1, x2)
		public static function rnd_float(x1:Number, x2:Number):Number
		{
			return Math.random()*(x2 - x1) + x1;
		}
		
		//[x1, x2]
		public static function rnd_int(x1:int, x2:int):int
		{
			return int(rnd_float(x1, x2+1));
		}
		
		//[x1, x2]
		public static function playSound(snd:Sound, vol:Number, x:Number):void
		{
			var p:Number = (x-320.0)/320.0;
			
			if(p>1) p=1;
			else if(p<-1) p=-1;
			
			var tr:SoundTransform = new SoundTransform(vol, p);
			snd.play(49, 0, tr);
		}
	}
}