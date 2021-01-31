package com.ek.duckstazy.game
{
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.easing.Back;
	import com.ek.library.utils.easing.Cubic;

	import flash.text.AntiAliasType;
	import flash.text.TextField;

	public class FightTimer extends GameObject
	{
		private var _time:Number = 0.0;
		private var _tfDebug:TextField;
		
		public function FightTimer()
		{
			_tfDebug = DisplayUtils.createTextField(64);
			_tfDebug.antiAliasType = AntiAliasType.NORMAL;
			
			x = Config.WIDTH*0.5;
			y = Config.HEIGHT*0.5;
			
			addChild(_tfDebug);
			
			updateTween();
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_time += dt;
			
			if(_time >= 2.0)
			{
				parent.removeChild(this);
			}
			else
			{
				if(_time < 1.0)
				{
					_tfDebug.text = 'READY!';
				}
				else
				{
					if(ModeManager.instance.settings.type == ModeType.VERSUS_ESCAPING)
					{
						_tfDebug.text = 'RUN!';
					}
					else
					{
						_tfDebug.text = 'FIGHT!';
					}
				}
				
				updateTween();
			}
		}
		
		private function updateTween():void
		{
			var odd:Number = _time - int(_time);
			var sc:Number = Back.easeOut(Math.min(0.5, odd)*2.0, 0, 0, 0);
			var al:Number = Cubic.easeIn((Math.max(0.5, odd)-0.5)*2.0, 0, 0, 0);
			
			_tfDebug.x = -0.5*_tfDebug.textWidth;
			_tfDebug.y = -0.5*_tfDebug.textHeight;
				
			alpha = 1.0-al;
			scaleX = 
			scaleY = sc;
		}
	}
}
