package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.utils.GameRandom;
	import com.ek.library.asset.AssetManager;

	import flash.display.MovieClip;



	/**
	 * @author eliasku
	 */
	public class Bonus extends Actor
	{
		public static const EFFECTS_COUNT:int = 8;
		
		private var _startX:Number = 0.0;
		private var _startY:Number = 0.0;
		
		private var _mc:MovieClip;
		
		private var _respawn:Number = 0.0;
		
		private var _effect:int;
		
		private var _animFlow:Number = 0.0;
		
		public function Bonus(level:Level)
		{
			super(level);
			
			_mc = AssetManager.getMovieClip("mc_pills");
			
			content.addChild(_mc);
			
			width = 8;
			height = 8;
		}
		
		public override function onStart():void
		{
			super.onStart();
			
			_startX = x;
			_startY = y;
			
			respawn();
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			if(dead)
			{
				_respawn -= dt;
				if(_respawn <= 0.0)
				{
					respawn();
				}				
			}
			
		}
		
		public override function tick(dt:Number):void
		{
			if(!dead)
			{
				_mc.y = 2.0*Math.sin(_animFlow*Math.PI*2);
				_animFlow += dt*0.5;				
			}
		}
		
		private function respawn():void
		{
			dead = false;
			content.visible = true;
			
			if(ModeManager.instance.settings.randomBonus)
			{
				_effect = 0;
			}
			else
			{
				_effect = int(GameRandom.random(0, EFFECTS_COUNT));
				if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
				{
					if(_effect == BonusEffectType.STEAL || _effect == BonusEffectType.UNDEAD)
					{
						_effect = BonusEffectType.HEAL;
					}
				}
				else if(ModeManager.instance.settings.type == ModeType.VERSUS_ESCAPING)
				{
					if(_effect == BonusEffectType.HEAL)
					{
						_effect = BonusEffectType.STEAL;
					}
				}
			}

			_mc.gotoAndStop(_effect+1);
		}
		
		public function onPickUp():void
		{
			dead = true;
			content.visible = false;
			_respawn = 10.0;
			_animFlow = Math.random();
		}

		public function get effect():int
		{
			return _effect;
		}
	}
}
