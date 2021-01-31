package com.ek.duckstazy.particles
{
	import com.ek.library.utils.ColorUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	/**
	 * @author Elias Ku
	 */
	public class Particle implements IParticle
	{
		public var data:ParticleStyle;
		
		private var _styleName:String;	
		private var _node:ParticleNode;
		
		public var content:Sprite;
		
		public var startX:Number = 0;
		public var startY:Number = 0;
		public var startVelocityX:Number = 0;
		public var startVelocityY:Number = 0;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		//public var data:BcParticleData;
		
		public var t:Number = 1.0;
		public var speed:Number = 1.0;
		
		public var scaleX:Number = 1.0;
		public var scaleXDelta:Number = 0.0;
		public var scaleXEase:Function;
		
		public var scaleY:Number = 1.0;
		public var scaleYDelta:Number = 0.0;
		public var scaleYEase:Function;
		
		public var alpha:Number = 1.0;
		public var alphaDelta:Number = 0.0;
		public var alphaEase:Function;
		
		public var orientedType:String = "velocity";
		public var angle:Number = 0.0;
		public var rotation:Number = 0.0;
		
		public var ax:Number = 0.0;
		public var ay:Number = 0.0;
		
		public var velocityFriction:Number = 0.0;
		public var rotationFriction:Number = 0.0;
		
		public var startColor:uint = 0xffffff;
		public var endColor:uint = 0xffffff;
		public var easeColor:Function;
		
		
		public function Particle() {
			
		}
		
		public function reset():void {
			if(data && content) {

				x = 0.0;
				y = 0.0;
				
				vx = 0.0;
				vy = 0.0;
				
				content.x = x;
				content.y = y;
				content.rotation = angle;
				content.scaleX = scaleX;
				content.scaleY = scaleY;
				content.transform.colorTransform = ColorUtil.getTransform(startColor);
				content.alpha = alpha;
				
				t = 1.0;
			}
		}

		public function tick(dt:Number):void {
			t -= dt * speed;
			if(t <= 0.0 && content.parent) {
				content.parent.removeChild(content);
			}
			else {
				vx += ax*dt;
				vy += ay*dt;
				
				if(velocityFriction < 1.0) {
					const vf:Number = Math.pow(velocityFriction, dt);
					vy *= vf;
					vx *= vf;
				}
				
				x += vx * dt;
				y += vy * dt;
				
				content.x = x;
				content.y = y;
				
				if(orientedType == null) {
					if(rotationFriction < 1.0 && rotation > 0.0) {
						rotation *= Math.pow(rotationFriction, dt);
					}
					
					angle += rotation * dt;
					content.rotation = angle;
				}
				else if(orientedType == "velocity") {
					content.rotation = 180*Math.atan2(-vx, vy)/Math.PI;
				}				

				const p:Number = 1.0 - t;

				if (alphaDelta != 0.0) {
					if(alphaEase != null) {
						 content.alpha = alpha + alphaDelta * alphaEase(p, 0, 0, 0);
					}
					else {
						content.alpha = alpha + alphaDelta * p;
					}
				}

				if(scaleXDelta != 0.0)
				{
					if(scaleXEase != null) {
						 content.scaleX = scaleX + scaleXDelta * scaleXEase(p, 0, 0, 0);
					}
					else {
						content.scaleX = scaleX + scaleXDelta * p;
					}
				}
				
				if(scaleYDelta != 0.0)
				{
					if(scaleYEase != null) {
						 content.scaleY = scaleY + scaleYDelta * scaleYEase(p, 0, 0, 0);
					}
					else {
						content.scaleY = scaleY + scaleYDelta * p;
					}
				}
				
				if(startColor != endColor) {
					var ctAlpha:Number = content.alpha;
					var ct:ColorTransform;
					if(easeColor != null) {
						ct = ColorUtil.getTransform(ColorUtil.lerpARGB(startColor, endColor, easeColor(p, 0, 0, 0)));
					}
					else {
						ct = ColorUtil.getTransform(ColorUtil.lerpARGB(startColor, endColor, p));
					}
					ct.alphaMultiplier = ctAlpha;
					content.transform.colorTransform = ct;
				}
			}
		}

		public function getNode():ParticleNode
		{
			return _node;
		}

		public function setNode(node:ParticleNode):void
		{
			_node = node;
		}

		public function isAlive():Boolean
		{
			return content.parent != null;
		}

		public function getStyleName():String
		{
			return _styleName;
		}

		public function setStyleName(styleName:String):void
		{
			_styleName = styleName;
		}
		
		public function getContent():DisplayObject {
			return content;
		}

		public function deltaVelocity(dx:Number, dy:Number):void
		{
			vx += dx;
			vy += dy;
		}

		public function deltaPosition(dx:Number, dy:Number):void
		{
			x += dx;
			y += dy;
		}

	}
}
