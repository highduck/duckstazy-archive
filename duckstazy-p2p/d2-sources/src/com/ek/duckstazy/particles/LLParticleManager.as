package com.ek.duckstazy.particles
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author eliasku
	 */
	public class LLParticleManager implements IParticleManager
	{
		private var _headNode:ParticleNode;
		private var _particlesPool:Object = new Object();
		private var _activeParticlesCount:int;
		private var _particlesPoolLength:int;
		
		private var _styles:Object = new Object();
		private var _styleFactory:IParticleStyleFactory;
		
		public function update(dt:Number):void
		{
			var node:ParticleNode = _headNode;
			var particle:IParticle;
			
			_activeParticlesCount = 0;
			
			while (node)
			{
				particle = node.particle;
				
				particle.tick(dt);
				
				if(particle.isAlive()) {
					node = node.next;
					++_activeParticlesCount;
				}
				else {
					node = removeNode(node);
				}
			}
		}

		private function removeNode(node:ParticleNode):ParticleNode
		{
			var next:ParticleNode;
			var particle:IParticle = node.particle;
			var styleName:String = particle.getStyleName();
			var pool:Vector.<ParticleNode>;
			
			if(styleName) {
				pool = _particlesPool[styleName];
				pool.push(node);
				_particlesPoolLength++;
			}
			
			if(_headNode == node) {
				_headNode = node.next;
				if(_headNode) {
					_headNode.prev = null;
				}
				node.prev = null;
				node.next = null;
				next = _headNode;
			}
			else {
				next = node.next;
				
				if(node.prev) {
					node.prev.next = node.next;
				}
				if(node.next) {
					node.next.prev = node.prev;
				}
				node.next = null;
				node.prev = null;
			}
			
			return next;
		}
		
		public function addParticle(target:DisplayObjectContainer, particle:IParticle):void
		{
			var content:DisplayObject;
			var node:ParticleNode;
			
			if(particle) {
				content = particle.getContent();
				node = particle.getNode();
				
				if(content) {
					target.addChild(content);
					
					node.next = _headNode;
					node.prev = null;
					
					if(_headNode) {
						_headNode.prev = node;
					}
					
					_headNode = node;
				}
			}
		}

		public function cleanup():void
		{
			while (_headNode) {
				removeNode(_headNode);
			}
		}
		
		public function getActiveParticlesCount():int {
			return _activeParticlesCount;
		}
		
		public function getParticlesPoolLength():int {
			return _particlesPoolLength;
		}
		
		public function createParticle(styleName:String):IParticle {
			var style:IParticleStyle = _styles[styleName];
			var particle:IParticle;
			var pool:Vector.<ParticleNode>;
			var node:ParticleNode;
			
			if(style) {
				pool = _particlesPool[styleName];
				if(!pool) {
					pool = new Vector.<ParticleNode>();
					_particlesPool[styleName] = pool;
				}
				
				if(pool.length > 0) {
					_particlesPoolLength--;
					particle = pool[0].particle;
					pool.shift();
					
					particle.reset();
				}
				else {
					particle = style.createParticle();
					if(particle) {
						node = new ParticleNode();
						node.particle = particle;
						particle.setNode(node);
						
						particle.reset();
					}
				}
			}

			return particle;
		}
		
		public function addStyle(style:IParticleStyle):void {
			_styles[style.getName()] = style;
		}

		public function setStyleFactory(styleFactory:IParticleStyleFactory):void {
			_styleFactory = styleFactory;
		}
		
		public function createStyle(name:String, type:String):IParticleStyle {
			var style:IParticleStyle;
			
			if(_styleFactory) {
				style = _styleFactory.createStyle(name, type);
				if(style && style.getName()) {
					addStyle(style);
					return style;
				}
			}
			
			return null;
		}
		
		public function reserveParticles(styleName:String, count:int):void {
			var i:int;
			var particle:IParticle;
			var pool:Vector.<ParticleNode>;
			var style:IParticleStyle;
			var node:ParticleNode;
			
			if(styleName) {
				style = _styles[styleName];
				
				if(style) {
					pool = _particlesPool[styleName];
		
					if(!pool) {
						pool = new Vector.<ParticleNode>();
						_particlesPool[styleName] = pool;
					}
					
					while(i < count) {
						particle = style.createParticle();
						if(particle) {
							node = new ParticleNode();
							node.particle = particle;
							particle.setNode(node);
							pool.push(particle.getNode());
							_particlesPoolLength++;
							++i;
						}
						else {
							break;
						}
					}
				}
			}
		}
		
		public function addStylesFromXML(xml:XML):void {
			var node:XML;
			var style:IParticleStyle;
			
			if(xml) {
				for each(node in xml["style"]) {
					style = createStyle(node.@name, node.@type);
					if(style) {
						style.parseXML(node);
					}
				}
			}
		}
		
		public function getStyle(name:String):IParticleStyle {
			return _styles[name];
		}
		
	}
}
