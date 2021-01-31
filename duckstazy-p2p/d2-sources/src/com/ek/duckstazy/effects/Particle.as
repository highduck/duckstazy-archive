package com.ek.duckstazy.effects
{
	import flash.display.DisplayObject;
	/**
	 * @author eliasku
	 */
	public class Particle
	{
		public var sprite:DisplayObject;

		public var x:Number = 0;
		public var y:Number = 0;
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		//public var data:BcParticleData;
		
		public var t:Number = 1.0;
		public var speed:Number = 1.0;
		
		public var scale:Number = 1.0;
		public var scaleDelta:Number = 0.0;
		
		public var alpha:Number = 1.0;
		public var alphaDelta:Number = 0.0;
		
		public var angle:Number = 0.0;
		public var rotation:Number = 0.0;
		
		public var gravity:Number = 0.0;
		public var velocityFriction:Number = 0.0;
		public var rotationFriction:Number = 0.0;
		
		
		//public var frame:uint;
		//public var frameTime:Number = 0;
	}
}
