package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.asset.AssetManager;

	import flash.display.Sprite;
	import flash.geom.Point;







	/**
	 * @author eliasku
	 */
	public class Chip extends Actor
	{
		private var _owner:Player;
		private var _sprite:Sprite;
				
		private var _touches:int;
		
		
		private var _rotSpeed:Number;
		private var _ps:Number = 0.0;
		
		public function Chip(level:Level, def:String, owner:Player)
		{
			super(level);
			
			_sprite = AssetManager.getMovieClip(def);
			
			_sprite.x = 8;
			_sprite.y = 5;
			
			content.addChild(_sprite);
						
			width = 10;
			height = 8;
			
			_owner = owner;
			
			var a:Number = XRandom.random(0, Math.PI*2.0);
			var d:Number = XRandom.random(100, 400);
			_rotSpeed = XRandom.random(-270, 270);
			_sprite.rotation = XRandom.random(0, 360);
			
			vx = d*Math.cos(a);
			vy = d*Math.sin(a);
			x = _owner.x;
			y = _owner.y;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
		
			var fr:Number = Math.exp(-3.0*dt);
			vy = vy*fr + Player.GRAVITY*dt;
			vx *= Math.exp(-1.0*dt);
			//if(_vy > MOVEV_DIVE*3.0) _vy = MOVEV_DIVE*3.0;
			//_vx = XMath.addByMod(_vx, target_vx, hacc*dt);
			
			if(move(dt, new Point(0.1, 0.5)))
			{
				if(!dead)
				{
					_touches++;
					_rotSpeed *= 1.5;
					if(_touches > 1)
						onDeath();
				}
			}
			
			_rotSpeed *= Math.exp(-3.0*dt);
			
			//_ps += dt*20;
			//ParticleFX.duckProjectile(this, int(_ps));
			//_ps -= int(_ps);
			
			if(dead)
			{
				if(content.alpha <= 0.0)
					destroy();
			}
		}
		
		public override function tick(dt:Number):void
		{
			_sprite.rotation += dt*_rotSpeed;
						
			if(dead)
			{
				content.alpha -= dt;
			}
		}

		private function onDeath():void
		{
			dead = true;
		}
		
		
		protected override function processActor(actor:Actor):void 
		{
			/*var player:Player = actor as Player;
			if(player && _owner != player && !player.isKicked && !player.dead)
			{
				player.onKick(10);
				onDeath();
			}*/
		}
	}
}
