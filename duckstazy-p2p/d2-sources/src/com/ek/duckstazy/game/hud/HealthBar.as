package com.ek.duckstazy.game.hud
{
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.DisplayUtils;
	import com.ek.duckstazy.utils.XMath;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.ColorUtil;
	import com.ek.library.utils.easing.Cubic;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class HealthBar extends GameObject
	{
		private var _tfName:TextField;
		private var _tfHealth:TextField;
		private var _tfFrags:TextField;
		private var _bar:Sprite;
		
		private static const WIDTH:int = 250;
		private static const HEIGHT:int = 24;
		private static const SPACE:int = 32;
		
		private var _respawnTime:Number = 0.0;
		
		private var _currentAmount:Number = 0.0;
		private var _prevAmount:Number = 0.0;
		private var _tween:Number = 1.0;
		
		private var _side:int;
		
		public function HealthBar()
		{
			super();
			
			_tfName = DisplayUtils.createTextField(16);
			_tfName.y = 48-10;
			_tfHealth = DisplayUtils.createTextField(20);
			_tfHealth.y = 20-10;
			_tfFrags = DisplayUtils.createTextField(16);
			_tfFrags.y = 48-10;
			_bar = new Sprite();
			_bar.y = 22-10;
			
			redrawBar();
			
			addChild(_bar);
			addChild(_tfHealth);
			addChild(_tfName);
			addChild(_tfFrags);
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			if(_tween < 1.0)
			{
				_tween += dt*3.0;
				if(_tween > 1.0) _tween = 1.0;
				
				redrawBar();
			}
		}
		
		public function set health(value:int):void
		{
			if(value != _currentAmount)
			{
				_prevAmount = _currentAmount;
				_currentAmount = value;
				_tween = 0.0;
			}
			
			_respawnTime = 0.0;
			
			redrawBar();
		}
		
		public function set respawn(value:Number):void
		{
			health = 0.0;
			_respawnTime = value;
			redrawBar();
		}
		
		private function redrawBar():void
		{
			var t:Number = Cubic.easeOut(_tween, 0,0,0);
			var pr:Number = XMath.lerp(_prevAmount, _currentAmount, t)/100.0;
			var g:Graphics = _bar.graphics;
			g.clear();
			
			g.lineStyle(2 + (1.0-t)*4.0, ColorUtil.lerpARGB(0xffffff, 0x333333, t));
			g.beginFill(0x773333);
			g.drawRoundRect(0, 0, WIDTH, HEIGHT, 4.0, 4.0);
			g.endFill();
			g.lineStyle();
			g.beginFill(0x77ccff);
			if(_side)
			{
				g.drawRoundRect(1+(WIDTH - 2)*(1-pr), 1, (WIDTH-2)*pr, HEIGHT-2, 4.0, 4.0);
			}
			else
			{
				g.drawRoundRect(1, 1, (WIDTH-2)*pr, HEIGHT-2, 4.0, 4.0);
			}
			g.endFill();
			
			if(_respawnTime > 0.0)
			{
				_tfHealth.text = _respawnTime.toFixed(1) + " sec";
			}
			else
			{
				_tfHealth.text = _currentAmount.toString();
			}
			
			_tfHealth.x = (WIDTH - _tfHealth.textWidth)*0.5;
		}
		
		public function set playerColor(value:uint):void
		{
			_tfName.textColor = value;
			_tfFrags.textColor = value;
		}
		
		public function set playerName(value:String):void
		{
			_tfName.text = value;
			side = _side;
		}
		
		public function set side(value:int):void
		{
			_side = value;
			if(_side==1)
			{
				x = Config.WIDTH - (WIDTH+SPACE);
				_tfName.x = WIDTH - _tfName.textWidth - 6;
				_tfFrags.x = 0;
			}
			else
			{
				x = SPACE;
				_tfName.x = 0;
				_tfFrags.x = WIDTH - _tfFrags.textWidth - 6;
			}
		}
		
		public function set frags(value:int):void
		{
			_tfFrags.text = value.toString();
			side = _side;
		}
	}
}
