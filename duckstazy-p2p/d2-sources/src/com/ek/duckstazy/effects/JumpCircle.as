package com.ek.duckstazy.effects
{
	import com.ek.library.asset.AssetManager;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.easing.Cubic;

	import flash.display.MovieClip;

	/**
	 * @author eliasku
	 */
	public class JumpCircle extends GameObject
	{
		private var _content:MovieClip;
		
		private var _speed:Number = 2.0;
		private var _time:Number = 0.0;
		
		private var _beginScaleX:Number = 0.25;
		private var _beginScaleY:Number = 0.0;
		private var _deltaScaleX:Number = 0.5;
		private var _deltaScaleY:Number = 0.75;
		
		private var _beginAlpha:Number = 1.0;
		private var _deltaAlpha:Number = -1.0;
		
		public function JumpCircle()
		{
			_content = AssetManager.getMovieClip("mc_jump_circle");
			
			scaleX = _beginScaleX;
			scaleY = _beginScaleY;
			alpha = _beginAlpha;
			
			addChild(_content);
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_time+=dt*_speed;
			
			if(_time > 1.0)
			{
				parent.removeChild(this);
				return;
			}
			
			var t:Number = Cubic.easeOut(_time, 0,0,0);
			
			scaleX = _beginScaleX + _deltaScaleX*t;
			scaleY = _beginScaleY + _deltaScaleY*t;
			
			alpha = _beginAlpha + _deltaAlpha*_time;
		}
	}
}
