package com.ek.duckstazy.effects
{
	import com.ek.library.asset.AssetManager;
	import com.ek.library.utils.ColorUtil;

	import flash.display.Sprite;

	public class FeatherParticle
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var fx:Number;
		public var fy:Number;
		public var oa:Number;
		public var life:Number;
		public var t:Number;
		public var scale:Number;
		public var sprite:Sprite;

		public function FeatherParticle(color:uint = 0xffffff)
		{
			sprite = AssetManager.getMovieClip("mc_feather");
			x = 0;
			y = 0;
			oa = Math.random() * 6.28;
			t = 0;
			
			sprite.transform.colorTransform = ColorUtil.getTransform(0xff000000 | color);
		}
	}
}