package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;

	import flash.display.Graphics;

	/**
	 * @author eliasku
	 */
	public class Spikes extends Actor
	{
		public function Spikes(level:Level)
		{
			super(level);
			
			var g:Graphics = content.graphics;
			g.beginFill(0xff0000);
			g.moveTo(0, 8);
			g.lineTo(4, 0);
			g.lineTo(8, 8);
			g.lineTo(12, 0);
			g.lineTo(16, 8);
			g.lineTo(20, 0);
			g.lineTo(24, 8);
			g.lineTo(28, 0);
			g.lineTo(32, 8);
			g.endFill();
			
			width = 32;
			height = 8;
		}
		
		
		public function onHeroHit(hero:Player):void
		{
			if(!hero.kicked)
			{
				//AssetManager.getSound("kicked").play();
				hero.onKick(this, 15);
				if(hero.bonusUndead <= 0.0)
				{
					// TODO: перенести в onKick(..., vx, vy)
					hero.vx = -hero.lookDir*Player.MOVEH_VEL_MAX * 0.5;
					hero.vy = Player.JUMP_VEL * 0.3;
				}
			}
		}

	}
}
