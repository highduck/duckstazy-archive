package com.ek.duckstazy.particles
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	/**
	 * @author Elias Ku
	 */
	public class ParticleEmitter
	{
		private var _particleManager:IParticleManager;
		
		private var _layer:DisplayObjectContainer;
		private var _object:DisplayObject;
		
		private var _active:Boolean = true;
		
		private var _prevX:Number = 0.0;
		private var _prevY:Number = 0.0;
		
		private var _smoothPath:Boolean = false;
		private var _velocityMultiplier:Number = 0.0;
		
		private var _channels:Vector.<ParticleChannel> = new Vector.<ParticleChannel>();
		
		public function ParticleEmitter(particleManager:IParticleManager, layer:DisplayObjectContainer, object:DisplayObject)
		{
			_particleManager = particleManager;
			_layer = layer;
			_object = object;
		}
		
		public function update(dt:Number):void {
			var count:int;
			var gen:Number;
			
			if(_active) {
				for each (var channel:ParticleChannel in _channels) {
					gen = channel.getGenerator() + dt*channel.getSpeed();
					count = int(gen);
					if(count > 0) {
						emitParticles(channel.getStyle(), count);
						gen -= count;
					}
					channel.setGenerator(gen);
				}
				
				if(_object) {
					_prevX = _object.x;
					_prevY = _object.y;
				}
			}
		}
		
		public function emitParticles(style:String, count:int):void {
			if(_smoothPath) {
				emitSmooth(style, count);
			}
			else {
				emitSimple(style, count);
			}
		}
		
		private function emitSmooth(style:String, count:int):void {
			var i:int;
			var p:IParticle;
			var fraction:Number;
			var dx:Number;
			var dy:Number;;
			
			if(_object) {
				dx = _object.x - _prevX;
				dy = _object.y - _prevY;
				fraction = 1.0/count;
			}
			
			while(i < count) {
				p = _particleManager.createParticle(style);
				
				if(p) {
					if(_object) {
						p.deltaPosition(_prevX + i*fraction*dx, _prevY + i*fraction*dy);
						
						if(_velocityMultiplier > 0.0) {
							p.deltaVelocity(-dx*_velocityMultiplier, -dy*_velocityMultiplier);
						}
					}
	
					_particleManager.addParticle(_layer, p);
					
					++i;
				}
				else break;
			}
		}
		
		private function emitSimple(style:String, count:int):void {
			var i:int;
			var p:IParticle;
			
			while(i < count) {
				p = _particleManager.createParticle(style);
		
				if(p) {
					if(_object) {
						p.deltaPosition(_object.x, _object.y);
						
						if(_velocityMultiplier > 0.0) {
							p.deltaVelocity((_prevX - _object.x)*_velocityMultiplier, (_prevY - _object.y)*_velocityMultiplier);
						}
					}
	
					_particleManager.addParticle(_layer, p);
					
					++i;
				}
				else break;
			}
		}

		public function get smoothPath():Boolean
		{
			return _smoothPath;
		}

		public function set smoothPath(smoothPath:Boolean):void
		{
			_smoothPath = smoothPath;
		}

		public function get velocityMultiplier():Number
		{
			return _velocityMultiplier;
		}

		public function set velocityMultiplier(velocityMultiplier:Number):void
		{
			_velocityMultiplier = velocityMultiplier;
		}
		
		public function addChannel(style:String, speed:Number):ParticleChannel {
			var channel:ParticleChannel = new ParticleChannel(style, speed);
			_channels.push(channel);
			return channel;
		}
		
		public function removeChannel(channel:ParticleChannel):void {
			var i:int = _channels.indexOf(channel);
			if(i >= 0) {
				_channels.splice(i, 1);
			}
		}

		public function getActive():Boolean
		{
			return _active;
		}

		public function setActive(active:Boolean):void
		{
			_active = active;
		}
	}
}
