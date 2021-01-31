package com.ek.duckstazy.effects
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.utils.ColorUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;







	/**
	 * @author eliasku
	 */
	public class ParticleFX
	{
		
		public static function createFakeMotion(layer:Sprite, target:Sprite, alpha:Number = 1.0):void
		{
			if(!target.parent || !layer) return;
			
			var w:int = target.width;
			var h:int = target.height;
			var ps:ParticleSystem = new ParticleSystem();
			var particle:Particle;
			var sprite:Sprite = new Sprite();
			var bd:BitmapData = new BitmapData(w, h, true, 0x0);
			var bm:Bitmap;
			var rc:Rectangle = target.getBounds(layer);
			var mat:Matrix = target.transform.matrix;
			mat.translate( -rc.left, -rc.top);
			bd.draw(target, mat, null, null, null, true);
			bm = new Bitmap(bd, PixelSnapping.NEVER, true);
			bm.x = -w*0.5;
			bm.y = -h*0.5;
			sprite.addChild(bm);
						
					
			particle = new Particle;
			particle.sprite = sprite;
			
			//particle.sprite.transform.colorTransform = ColorUtil.getTransform(color);
			//particle.gravity = -200.0;
			//particle.velocityFriction = 6.0;
			particle.alpha = alpha;
			particle.alphaDelta = -alpha;
			particle.speed = 4.0;
			//particle.scale = XMath.random(0.25, 0.5);
			particle.scaleDelta = 0.1;
			//particle.x = ;
			//particle.y = ;
			
			//particle.vx = -0.1*player.vx;
			ps.add(particle);
		
			ps.x = rc.left + w*0.5;
			ps.y = rc.top + h*0.5;
			
			layer.addChildAt(ps, 0);	
		}
		
		public static function createBonus(player:Player, count:int, color:uint = 0x884433):void
		{
			if(count <= 0 || !player.layer) return;
			
			var ps:ParticleSystem = new ParticleSystem();
			var particle:Particle;
			var i:int = count;
			
			while(i > 0)
			{
				particle = new Particle;
				particle.sprite = AssetManager.getMovieClip("mc_bubble");
				particle.sprite.transform.colorTransform = ColorUtil.getTransform(color);
				particle.gravity = -200.0;
				particle.velocityFriction = 6.0;
				//particle.alpha = a;
				particle.speed = XRandom.random(1, 4);
				particle.scale = XRandom.random(0.25, 0.5);
				particle.scaleDelta = -particle.scale;
				particle.y = XRandom.random(-24, 0);
				particle.x = XRandom.random(-4, 16);
				particle.vx = -0.1*player.vx;
				ps.add(particle);
				--i;
			}
			
			ps.x = player.x;
			ps.y = player.y + 24;
			
			player.layer.addChildAt(ps, 0);	
		}
		
		public static function createDuckBubbles(player:Player, count:int):void
		{
			if(count <= 0 || !player.layer) return;
			
			var ps:ParticleSystem = new ParticleSystem();
			var particle:Particle;
			var i:int = count;
			
			while(i > 0)
			{
				particle = new Particle;
				particle.sprite = AssetManager.getMovieClip("mc_bubble");
				particle.sprite.transform.colorTransform = ColorUtil.getTransform(0x884433);
				particle.gravity = -200.0;
				particle.velocityFriction = 6.0;
				//particle.alpha = a;
				particle.speed = XRandom.random(1, 4);
				particle.scale = XRandom.random(0.25, 0.5);
				particle.scaleDelta = -particle.scale;
				particle.x = XRandom.random(-4, 16);
				particle.vx = -0.1*player.vx;
				ps.add(particle);
				--i;
			}
			
			ps.x = player.x;
			ps.y = player.y + 24;
			
			player.layer.addChildAt(ps, 0);//_owner.layer.getChildIndex(_owner)+1);	
		}
		
		public static function duckDiveParticles(player:Player, count:int, trail:Boolean = false):void
		{
			if(count <= 0 || !player.layer) return;
			//if(!trail) return;
			var ps:ParticleSystem = new ParticleSystem();
			var particle:Particle;
			var i:int = count;
			var ct1:ColorTransform = ColorUtil.getTransform(0xDDDDDD);
			var ct2:ColorTransform = ColorUtil.getTransform(0xDDDDDD);
			
			var d:Number;
			var a:Number;
			var vmax:Number = 300.0;
			
			
			
			
			
			while(i > 0)
			{
				particle = new Particle;
				particle.sprite = AssetManager.getMovieClip("mc_bubble");
				particle.sprite.transform.colorTransform = ColorUtil.interpolateTransform(ct1, ct2, XRandom.random());
				if(trail)
				{
					particle.gravity = -600.0;
					particle.velocityFriction = 8.0;
				}
				else
				{
					particle.velocityFriction = 6.0;
				}
				//particle.alphaDelta = -1.0;
				if(trail)
					particle.speed = XRandom.random(1, 2);
				else
					particle.speed = XRandom.random(1, 4);
				particle.scale = XRandom.random(0.25, 0.75);
				particle.scaleDelta = -particle.scale;
								
				d = XRandom.random(vmax, vmax+50.0);
				a = XRandom.random(0.0, Math.PI*2.0);
				if(trail)
				{
					a = XRandom.random(0.0, -Math.PI);
				}
				
				if(trail)
					particle.x = XRandom.random(-4, 16);
					
				particle.vx = d*Math.cos(a);
				particle.vy = d*Math.sin(a);// + Player.MOVEH_VEL_DIVE;
				ps.add(particle);
				--i;
			}
			
			if(!trail)
			{
				ps.x = player.x + 8;
				ps.y = player.y + 10;
			}
			else
			{
				ps.x = player.x;
				ps.y = player.y + 28;
			}
			
			if(!trail)
				player.layer.addChildAt(ps, player.layer.getChildIndex(player.content)+1);
			else
				player.layer.addChildAt(ps, 0);
						
		}
		
		public static function duckProjectile(proj:Actor, count:int):void
		{
			if(count <= 0 || !proj.layer) return;
			//if(!trail) return;
			var ps:ParticleSystem = new ParticleSystem();
			var particle:Particle;
			var i:int = count;
			var ct1:ColorTransform = ColorUtil.getTransform(0xDDDDDD);
			var ct2:ColorTransform = ColorUtil.getTransform(0xDDDDDD);
		
			while(i > 0)
			{
				particle = new Particle;
				particle.sprite = AssetManager.getMovieClip("mc_bubble");
				//particle.sprite.transform.colorTransform = ColorUtil.interpolateTransform(ct1, ct2, XMath.random());
				particle.gravity = XRandom.random(0.0, -300.0);
				particle.velocityFriction = 3.0;
				particle.speed = XRandom.random(0.5, 2);
				particle.scale = XRandom.random(0.25, 0.5);
				particle.scaleDelta = -particle.scale;
								
				//d = 0.0;
				//a = XMath.random(0.0, Math.PI*2.0);
									
				//particle.vx = d*Math.cos(a);
				//particle.vy = d*Math.sin(a);// + Player.MOVEH_VEL_DIVE;
				
				ps.add(particle);
				--i;
			}
			
			ps.x = proj.x + 5;
			ps.y = proj.y + 5;
			
			proj.layer.addChildAt(ps, 0);	
		}
	}
}
