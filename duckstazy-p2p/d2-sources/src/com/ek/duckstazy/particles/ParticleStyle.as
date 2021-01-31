package com.ek.duckstazy.particles
{
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.utils.ColorUtil;
	import com.ek.library.utils.ParserUtil;
	import com.ek.library.utils.easing.Quadratic;

	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * @author Elias Ku
	 */
	public class ParticleStyle implements IParticleStyle
	{
		private var _name:String;
		
		public var symbol:String;
		
		public var acceleration:Point = new Point();
		public var accelerationRange:Point = new Point();
		
		public var velocityFriction:Number = 1.0;
		public var velocityFrictionRange:Number = 0.0;
		
		public var rotationFriction:Number = 1.0;
		public var rotationFrictionRange:Number = 0.0;
		
		public var syncScale:Boolean = true;
		
		public var startScale:Point = new Point(1.0, 1.0);
		public var startScaleRange:Point = new Point(0.0, 0.0);
		public var endScale:Point = new Point(1.0, 1.0);
		public var endScaleRange:Point = new Point(0.0, 0.0);
		
		public var easeScaleX:Function;
		public var easeScaleY:Function;		
		
		public var startAlpha:Number = 1.0;
		public var startAlphaRange:Number = 0.0;
		public var endAlpha:Number = 1.0;
		public var endAlphaRange:Number = 0.0;
		public var easeAlpha:Function;
	
		public var startColorRange:Array = new Array();
		public var endColorRange:Array = new Array();
		public var syncColors:Array = new Array();
		public var easeColor:Function;
		
		public var lifeSpan:Number = 1.0;
		public var lifeSpanRange:Number = 0.0;

		public function ParticleStyle(name:String) {
			_name = name;
		}

		public function getName():String {
			return _name;
		}
		
		public function createParticle():IParticle {
			var p:Particle = new Particle();
			var mc:MovieClip;
			var t:Number;
			
			p.setStyleName(_name);
			p.data = this;
						
			if(symbol) {
				mc = AssetManager.getMovieClip(symbol);
				if(mc) {
					mc.mouseChildren = false;
					mc.mouseEnabled = false;
					mc.stop();
					p.content = mc;
				}
				
				/** COLORS **/
				if(syncColors) {
					generateColors(p, XRandom.random(), XRandom.random());
				}
				else {
					t = XRandom.random();
					generateColors(p, t, t);
				}
				
				p.easeColor = easeColor;
				
				/** ALPHA **/
				p.alpha = startAlpha + startAlphaRange*XRandom.random();
				p.alphaDelta = (endAlpha + endAlphaRange*XRandom.random()) - p.alpha;
				p.alphaEase = easeAlpha;
				
				/** ACCELERATION **/
				p.ax = acceleration.x + accelerationRange.x * XRandom.random();
				p.ay = acceleration.y + accelerationRange.y * XRandom.random();
				
				/** FRICTION **/
				p.velocityFriction = velocityFriction + velocityFrictionRange * XRandom.random();
				p.rotationFriction = rotationFriction + rotationFrictionRange * XRandom.random();
				
				/** SCALE **/
				if(syncScale) {
					t = XRandom.random();
					p.scaleX = startScale.x + startScaleRange.x * t;
					p.scaleY = startScale.y + startScaleRange.y * t;
					p.scaleXDelta = (endScale.x + endScaleRange.x * t) - p.scaleX;
					p.scaleYDelta = (endScale.y + endScaleRange.y * t) - p.scaleY;
				}
				else {
					p.scaleX = startScale.x + startScaleRange.x * XRandom.random();
					p.scaleY = startScale.y + startScaleRange.y * XRandom.random();
					p.scaleXDelta = (endScale.x + endScaleRange.x * XRandom.random()) - p.scaleX;
					p.scaleYDelta = (endScale.y + endScaleRange.y * XRandom.random()) - p.scaleY;
				}
				p.scaleXEase = easeScaleX;
				p.scaleYEase = easeScaleY;
				
				/** LIFE SPAN **/
				p.speed = 1.0 / (lifeSpan + lifeSpanRange * XRandom.random());
			}
			
			return p;
		}

		private function generateColors(particle:Particle, start:Number, end:Number):void
		{
			const startColorLength:int = startColorRange.length;
			const endColorLength:int = endColorRange.length;
			var position:Number;
			var index:int;
			
			if(startColorLength > 0) {
				if(startColorLength > 1) {
					position = start*(startColorLength-1);
					index = int(position);
					particle.startColor = ColorUtil.lerpARGB(startColorRange[index], startColorRange[index+1], position-index);
				}
				else {
					particle.startColor = startColorRange[0];
				}
			}
			else {
				particle.startColor = 0xffffffff;
			}
			
			if(endColorLength > 0) {
				if(endColorLength > 1) {
					position = end*(endColorLength-1);
					index = int(position);
					particle.endColor = ColorUtil.lerpARGB(endColorRange[index], endColorRange[index+1], position-index);
				}
				else {
					particle.endColor = endColorRange[0];
				}
			}
			else {
				particle.endColor = 0xffffffff;
			}
		}
		
		public function parseXML(xml:XML):void {
			
			var p:Point = new Point();
			var node:XML;
			var node2:XML;
			
			if(xml) {
				node = xml["symbol"][0];
				if(node) {
					if(node.hasOwnProperty("@value")) {
						symbol = node.@value.toString();
					}
				}
				
				node = xml["life-span"][0];
				if(node) {
					if(node.hasOwnProperty("@value")) {
						lifeSpan = node.@value;
					}
					
					if(node.hasOwnProperty("@range")) {
						lifeSpanRange = node.@range;
					}
				}
				
				node = xml["acceleration"][0];
				if(node)
				{
					if(node.hasOwnProperty("@value")) {
						ParserUtil.parsePoint(node.@value, "; ", acceleration);
					}
					
					if(node.hasOwnProperty("@range")) {
						ParserUtil.parsePoint(node.@range, "; ", accelerationRange);
					}
				}
				
				node = xml["scale"][0];
				if(node)
				{
					if(node.hasOwnProperty("@sync")) {
						syncScale = ParserUtil.parseBoolean(node.@sync);
					}
					
					if(node.hasOwnProperty("@easeX")) {
						easeScaleX = getEaseFunction(node.@easeX);
					}
					
					if(node.hasOwnProperty("@easeY")) {
						easeScaleY = getEaseFunction(node.@easeY);
					}
					
					if(node.hasOwnProperty("@ease")) {
						easeScaleX = 
						easeScaleY = getEaseFunction(node.@ease);
					}
					
					node2 = node["start"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							ParserUtil.parsePoint(node2.@value, "; ", startScale);
						}
						
						if(node2.hasOwnProperty("@range")) {
							ParserUtil.parsePoint(node2.@range, "; ", startScaleRange);
						}
					}
					
					node2 = node["end"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							ParserUtil.parsePoint(node2.@value, "; ", endScale);
						}
						
						if(node2.hasOwnProperty("@range")) {
							ParserUtil.parsePoint(node2.@range, "; ", endScaleRange);
						}
					}
				}
				
				node = xml["alpha"][0];
				if(node) {
					if(node.hasOwnProperty("@ease")) {
						easeAlpha = getEaseFunction(node.@ease);
					}
					
					node2 = node["start"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							startAlpha = node2.@value;
						}
						
						if(node2.hasOwnProperty("@range")) {
							startAlphaRange = node2.@range;
						}
					}
					
					node2 = node["end"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							endAlpha = node2.@value;
						}
						
						if(node2.hasOwnProperty("@range")) {
							endAlphaRange = node2.@range;
						}
					}
				}
				
				node = xml["colors"][0];
				if(node) {
					if(node.hasOwnProperty("@ease")) {
						easeColor = getEaseFunction(node.@ease);
					}
					
					node2 = node["start"][0];
					if(node2) {
						if(node2.hasOwnProperty("@range")) {
							getColorRange(node2.@range, startColorRange);
						}
					}
					
					node2 = node["end"][0];
					if(node2) {
						if(node2.hasOwnProperty("@range")) {
							getColorRange(node2.@range, endColorRange);
						}
					}
				}
				
				node = xml["friction"][0];
				if(node) {
					
					node2 = node["velocity"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							velocityFriction = node2.@value;
						}
						
						if(node2.hasOwnProperty("@range")) {
							velocityFrictionRange = node2.@range;
						}
					}
					
					node2 = node["rotation"][0];
					if(node2) {
						if(node2.hasOwnProperty("@value")) {
							rotationFriction = node2.@value;
						}
						
						if(node2.hasOwnProperty("@range")) {
							rotationFrictionRange = node2.@range;
						}
					}
				}
			}
		}
		
		private function getEaseFunction(name:String):Function {
			return null;
		}
		
		private function getColorRange(string:String, out:Array):void {
			var args:Array = string.split("; ");
			var arg:String;
			out.length = 0;
			for each (arg in args) {
				
		
				out.push(parseInt(arg));
			}
			
		}
	}
}