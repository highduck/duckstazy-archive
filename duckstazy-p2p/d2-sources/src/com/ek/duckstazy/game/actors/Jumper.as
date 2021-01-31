package  
com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.audio.AudioLazy;

	import flash.display.Graphics;
	import flash.geom.ColorTransform;




	/**
	 * @author eliasku
	 */
	public class Jumper extends Actor 
	{
		private var _jumpAbove:Boolean = true;
		private var _jumpVel:Number = 7.3 * Player.TICK_MOD;
		private var _reloadTime:Number = 1.0;

		private var _useCount:int = -1;
		
		
		private var _useCounter:int;
		private var _reloadTimer:Number = 5.0;
		
		private var _deathTween:Number = 1.0;
		
		public function Jumper(level:Level)
		{
			super(level);
			
			width = 64;
			height = 16;
			
			var g:Graphics = content.graphics;
			g.lineStyle(1.0);
			g.beginFill(0x77ffff);
			g.drawCircle(width*0.5, width*0.5, width*0.25);
			g.endFill();
			g.lineStyle(1.0, 0xffffff);
			g.drawCircle(width*0.5, width*0.5, width*0.5);
			
			content.scaleY = height/width;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			if(dead)
			{
				_deathTween -= dt;
				if(_deathTween < 0.0)
				{
					_deathTween = 0.0;
					destroy();
				}
				
				content.scaleX = content.scaleY = Math.pow(_deathTween, 2.0);
			}
			
			if(_reloadTime > 0.0 && _reloadTimer < _reloadTime)
			{
				_reloadTimer += dt;
				var t:Number = 255*Math.min(_reloadTimer, _reloadTime) / _reloadTime;
				content.transform.colorTransform = new ColorTransform(1, 1, 1, 1, t, t, t);
			}
		}

		public function onHeroHit(hero:Player):void 
		{
			if(!dead && !hero.dive && !hero.kicked && _reloadTimer >= _reloadTime)
			{//hero.vy < -2 || 
				if(_jumpAbove && (y - hero.y - hero.height < -height*0.5)) return;
				AudioLazy.playAt("jumper", x, y);
				//velocity.x = 0.0;
				hero.vy = -400.0;
				hero.y = y - hero.height;
				hero.resetLongJump();
				hero.resetDoubleJump();
				if(_useCount > 0)
				{
					_useCounter++;
					if(_useCounter >= _useCount)
					{
						dead = true;
					}
				}
			}
		}
	}
}
