package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.effects.ParticleFX;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.asset.AssetManager;

	import flash.display.Sprite;
	import flash.geom.Point;






	/**
	 * @author eliasku
	 */
	public class Projectile extends Actor
	{
		private var _owner:Player;
		private var _sprite:Sprite;
				
		private var _touches:int;
		
		private var _ps:Number = 0.0;
		
		public function Projectile(level:Level, owner:Player)
		{
			super(level);
			
			_sprite = AssetManager.getMovieClip("mc_seed");
			
			_sprite.x = 8;
			_sprite.y = 5;
			
			content.addChild(_sprite);
			
			width = 10;
			height = 8;
			
			_owner = owner;
			
			vx = _owner.lookDir * 500;
			vy = -50;
			x = x = _owner.x;
			y = y = _owner.y;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			vy += Player.GRAVITY*1.0*dt;
			vx *= Math.exp(-1.0*dt);
			//if(_vy > MOVEV_DIVE*3.0) _vy = MOVEV_DIVE*3.0;
			//_vx = XMath.addByMod(_vx, target_vx, hacc*dt);
			
			if(move(dt, new Point(0.0, 0.5)))
			{
				_touches++;
				if(_touches > 1)
					dead = true;
			}
			
			if(dead)
				destroy();
		}
		
		public override function tick(dt:Number):void
		{
			_sprite.rotation += dt*180.0;
			
			_ps += dt*20;
			ParticleFX.duckProjectile(this, int(_ps));
			_ps -= int(_ps);
		}
		
		protected override function onPrediction(dt:Number):void
		{
			_predVY += Player.GRAVITY*dt;
			_predVX *= Math.exp(-dt);
			
			predictableMove(dt, true);
		}
		
		protected override function processActor(actor:Actor):void 
		{
			var player:Player = actor as Player;
			if(!dead && player && _owner != player && !player.kicked && !player.dead)
			{
				if(_owner.bonusQuad > 0.0)
					player.onKick(_owner, 40);
				else
					player.onKick(_owner, 10);
				_owner.stats.onGoodShot();
				dead = true;
			}
		}
		
	}
}
