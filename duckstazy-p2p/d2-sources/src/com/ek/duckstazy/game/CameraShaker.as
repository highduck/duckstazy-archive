package com.ek.duckstazy.game
{
	import com.ek.duckstazy.utils.XMath;
	import com.ek.library.core.CoreManager;

	/**
	 * @author eliasku
	 */
	public class CameraShaker
	{
		//public static const SHAKE_DIST:Number = 5.0;
		public static const SHAKE_RATE:int = int(1000.0/30.0);
		//public static const SHAKE_FADE_SPEED:Number = 2.0;
		public static const SHAKE_QUANT:Number = 8.0;
		
		private var _shakeX:Number = 0.0;
		private var _shakeY:Number = 0.0;
		private var _shakeTimer:int;
		private var _shakeCounter:int;
		
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		
		private var _shakes:Vector.<Shake>;
		
		public function CameraShaker()
		{
			_shakes = new Vector.<Shake>();
		}
		
		public function update():void
		{
			var ms:int = CoreManager.rawDeltaTime;
			var dt:Number = ms / 1000.0;
			var shake:Shake;
			var value:Number = 0.0;
			var i:int;
			
			while(i < _shakes.length)
			{
				shake = _shakes[i];
				value = Math.max(value, shake.strength * shake.tween);
				shake.tween -= dt*shake.speed;
				if(shake.tween <= 0.0)
					_shakes.splice(i, 1);
				else
					++i;
			}
			
			if(value > 0.0)
			{
				_shakeTimer += ms;
				while(_shakeTimer > SHAKE_RATE)
				{
					_shakeCounter++;
					if((_shakeCounter%2) > 0)
					{
						_shakeX = value * XMath.sign(0.5-Math.random());
						_shakeY = value * XMath.sign(0.5-Math.random());
					}
					else
					{
						_shakeX = 0.0;
						_shakeY = 0.0;
					}
					_shakeTimer -= SHAKE_RATE;
				}
			
				_x = int(_shakeX*SHAKE_QUANT)/SHAKE_QUANT;
				_y = int(_shakeY*SHAKE_QUANT)/SHAKE_QUANT;
			}
			else
			{
				_x = 0.0;
				_y = 0.0;
			}
		}

		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}
		
		public function shake(strength:Number = 8.0, time:Number = 1.0):void
		{
			_shakes.push(new Shake(strength, time));
			//if(value > _shake)
				//_shake = value;
		}

	}
}

class Shake
{
	public var tween:Number = 1.0;
	public var speed:Number = 2.0;
	public var strength:Number = 1.0;
	
	public function Shake(strength:Number, time:Number)
	{
		speed = 1.0 / time;
		this.strength = strength;
	}
}
