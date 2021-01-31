package  
com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;

	import flash.display.Graphics;


	/**
	 * @author eliasku
	 */
	public class BoxObstacle extends Actor 
	{
		private var _deathTimer:Number = 0.0;
		
		public function BoxObstacle(level:Level)
		{
			super(level);
			
			width = 24;
			height = 24;
			
			var g:Graphics = content.graphics;
			g.lineStyle(1.0);
			g.beginFill(0x7777cc);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			if(dead)
			{
				x += vx * dt;
				vy = vy + Player.GRAVITY*dt;
				y += vy * dt;
				_deathTimer += dt;
				content.rotation += 60*dt;
				content.alpha = 1 - int(_deathTimer*16)%2;
				if(_deathTimer > 1.0)
					destroy();
					
				updateTransform();
			}
		}
		
		public function onHeroHit(hero:Player):void
		{
			if(!dead && !hero.kicked)
			{
				hero.onKick(this, 0);
				vx = hero.vx * 0.75;
				vy = -3.0 * Player.TICK_MOD;
				//AssetManager.getSound("kicked").play();
				
				hero.vx = 0.0;
				hero.vy = 0.0;
				dead = true;
			}
		}
	}
}
