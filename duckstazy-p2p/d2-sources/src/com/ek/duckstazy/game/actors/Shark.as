package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.effects.ParticleFX;
	import com.ek.duckstazy.game.DisplayUtils;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.audio.AudioLazy;

	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;





	/**
	 * @author eliasku
	 */
	public class Shark extends Actor
	{
		private var _owner:Player;
		private var _target:Player;
		
		private var _sprite:Sprite;
				
		private var _ps:Number = 0.0;
		
		private var _scaleTween:Number = 0.0;
		
		private var _time:Number = 0.0;
		
		private var _tfTimer:TextField;
		
		public function Shark(level:Level, owner:Player, target:Player)
		{
			super(level);
			
			_sprite = AssetManager.getMovieClip("mc_shark");
			
			_sprite.scaleX = 
			_sprite.scaleY = 1.0;
			
			_sprite.x = 8;
			_sprite.y = 5;
			
			content.addChild(_sprite);
			
			width = 10;
			height = 8;
			
			_owner = owner;
			_target = target;
			
			vx = 0.0;
			vy = -1000.0;
			
			x = _owner.x;
			y = _owner.y;
			
			_sprite.filters = [new GlowFilter(0x000000, 1.0, 4.0, 4.0, 2, 2)];
			
			_owner.level.cameraShaker.shake(3.0, 1.0);
			
			_time = 3.0;
			
			_tfTimer = DisplayUtils.createTextField(24);
			_tfTimer.x = 0;
			_tfTimer.y = -24-12;
			content.addChild(_tfTimer);
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			var dx:Number = _target.x - x;
			var dy:Number = _target.y - y;
			var len:Number = Math.sqrt(dx*dx + dy*dy);
			if(len > 0.001)
			{
				dx/=len;
				dy/=len;
			}
			else
			{
				dx = dy = 0.0;
			}
			
			var fr:Number = Math.exp(-6.0*dt);
			
			
			
			vx += dx*2000.0*dt;
			vy += dy*2000.0*dt;
			vx *= fr;
			vy *= fr;
			
			
			//if(_vy > MOVEV_DIVE*3.0) _vy = MOVEV_DIVE*3.0;
			//_vx = XMath.addByMod(_vx, target_vx, hacc*dt);
			
			x += vx*dt;
			y += vy*dt;
			updateTransform();
			
			if(checkBox(_target.x, _target.y, _target.width, _target.height))
			{
				_target.onKick(_owner, 50);
				onDeath();
			}
			
			_time -= dt;
			if(_time > 0.0)
			{
				if(_time <= 3.0)
				{
					_tfTimer.text = _time.toFixed(1);
					_tfTimer.x = 24-_tfTimer.textWidth*0.5;
				}
			}
			else
			{
				onDeath();
			}
		}
		
		public override function tick(dt:Number):void
		{
			if(!dead)
			{
				if(_scaleTween < 1.0)
				{
					_scaleTween += dt;
				}
				
				var sc:Number = 1.0 - 0.2*Math.sqrt(vx*vx + vy*vy)/300.0;
				_sprite.scaleY = sc;
				
				if(vx < 0.0)
				{
					_sprite.scaleX = -sc;//*Math.min(1.0, Math.abs(_vx/100.0));
					//_sprite.scaleY = -0.5;
					_sprite.rotation = 180+Math.atan2(vy, vx)*180.0/Math.PI + Math.random()*10.0 - 5.0;
				}
				else
				{
					//_sprite.scaleX = 
					_sprite.scaleX = sc;//*Math.min(1.0, Math.abs(_vx/100.0));
					_sprite.rotation = Math.atan2(vy, vx)*180.0/Math.PI + Math.random()*10.0 - 5.0;
				}
				
				_ps += dt*60;
				ParticleFX.duckProjectile(this, int(_ps));
				//ParticleFX.createFakeMotion(layer, this);
				_ps -= int(_ps);
			}
		}

		private function onDeath():void
		{
			level.cameraShaker.shake(8.0, 0.5);
			level.hud.light.start(1.0);
			AudioLazy.playAt("die", x, y);
						
			dead = true;
			destroy();
		}
	}
}
