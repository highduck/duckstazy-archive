package com.ek.duckstazy.particles
{
	/**
	 * @author Elias Ku
	 */
	public class ParticleChannel
	{
		private var _style:String;
		private var _speed:Number = 1.0;
		private var _generator:Number = 0.0;
		
		public function ParticleChannel(style:String, speed:Number) {
			_style = style;
			_speed = speed;
		}

		public function getSpeed():Number
		{
			return _speed;
		}

		public function setSpeed(speed:Number):void
		{
			_speed = speed;
		}

		public function getStyle():String
		{
			return _style;
		}

		public function setStyle(style:String):void
		{
			_style = style;
		}

		public function getGenerator():Number
		{
			return _generator;
		}
		
		public function setGenerator(generator:Number):void
		{
			_generator = generator;
		}

	}
}
