package com.ek.duckstazy.effects
{
	import com.ek.library.gocs.GameObject;

	import flash.display.DisplayObject;

	/**
	 * @author eliasku
	 */
	public class ParticleSystem extends GameObject
	{
		private var _particles:Vector.<Particle> = new Vector.<Particle>();
		private var _loop:Boolean;

		public function ParticleSystem()
		{
			super();

			mouseEnabled = false;
			mouseChildren = false;
		}

		public override function tick(dt:Number):void
		{
			var particle:Particle;
			var sprite:DisplayObject;
			var vf:Number;
			var i:int;
			var l:Number;

			while (i < _particles.length)
			{
				particle = _particles[i];
				particle.t -= dt * particle.speed;
				if (particle.t <= 0.0)
				{
					removeChild(particle.sprite);
					_particles.splice(i, 1);
				}
				else
				{
					sprite = particle.sprite;

					vf = Math.exp(-particle.velocityFriction * dt);

					particle.vy = particle.vy * vf + particle.gravity * dt;
					particle.vx *= vf;
					particle.rotation *= Math.exp(-particle.rotationFriction * dt);

					particle.x += particle.vx * dt;
					particle.y += particle.vy * dt;
					particle.angle += particle.rotation * dt;

					l = 1.0 - particle.t;

					sprite.x = particle.x;
					sprite.y = particle.y;
					sprite.rotation = particle.angle;

					if (particle.alphaDelta != 0.0)
						sprite.alpha = particle.alpha + particle.alphaDelta * l * l * l;

					if (particle.scaleDelta != 0.0)
					{
						sprite.scaleX = sprite.scaleY = particle.scale + particle.scaleDelta * l;
					}

					++i;
				}
			}

			if (!_loop && _particles.length == 0)
				cleanup();
		}

		/*
		private function explode():void
		{
		var i:int;
		var p:Particle;
		var a:Number;
		var d:Number;
		var mc:MovieClip;
			
		var sx:Number = 2.0*(Math.random()-0.5);
		var sy:Number = 2.0*(Math.random()-0.5);
			
		sx = sx*sx*sx*CoreManager.displayWidth;
		sy = Math.abs(sy*sy*sy)*CoreManager.displayHeight;
		if(sx < 0.0) sx += CoreManager.displayWidth-50;
		else sx += 50;
		if(sy < 0.0) sy += CoreManager.displayHeight-50;
		else sy += 50;
			
		p = new Particle;
		p.spr = mc = AssetManager.getMovieClip("mc_jinn_wave");
		mc.mouseEnabled = false;
		mc.mouseChildren = false;
		mc.x = p.x = sx;
		mc.y = p.y = sy;
		p.rot = 0.0;
		p.g = 0.0;
		p.f = 1.0;
		p.vx = 0.0;
		p.vy = 0.0;
		p.tmax = p.t = 0.3;
		p.scb = 0.0;
		p.scd = 4.0;
				
		addChild(mc);
		_parts.push(p);
			
		while(i < 50)
		{
		p = new Particle;
		p.spr = mc = AssetManager.getMovieClip("mc_jinn_star");
		if(!p.spr) return;
		mc.mouseEnabled = false;
		mc.mouseChildren = false;
		mc.x = p.x = sx;
		mc.y = p.y = sy;
		p.g = 100.0;
		p.rot = Math.random()*360.0 - 180.0;
		mc.rotation = p.ang = Math.random()*360.0;
		p.f = 4.0 + 2.0*Math.random();
				
		a = Math.random()*Math.PI*2.0;
		d = Math.random()*500.0 + 100.0;
				
		p.vx = Math.cos(a)*d;
		p.vy = Math.sin(a)*d;
		p.tmax = p.t = 0.5 + Math.random()*1.5;
				
		addChild(mc);
		_parts.push(p);
				
		++i;
		}
			
		a = Math.random();
			
		// SFXManager.play("sfx_fireworks");
		}*/
		public function add(particle:Particle):void
		{
			var sprite:DisplayObject = particle.sprite;
			_particles.push(particle);
			sprite.x = particle.x;
			sprite.y = particle.y;
			sprite.rotation = particle.angle;
			sprite.alpha = particle.alpha;
			sprite.scaleX = sprite.scaleY = particle.scale;
			addChild(sprite);
		}

		public function cleanup():void
		{
			var particle:Particle;

			for each (particle in _particles)
				removeChild(particle.sprite);

			_particles.length = 0;

			if (parent)
				parent.removeChild(this);
		}
	}
}
