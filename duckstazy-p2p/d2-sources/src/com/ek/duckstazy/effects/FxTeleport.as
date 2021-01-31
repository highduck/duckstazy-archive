package com.ek.duckstazy.effects
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.easing.Cubic;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class FxTeleport extends GameObject
	{
		private var _actor:Actor;
		private var _ghost:Bitmap;
		private var _ghostSprite:Sprite;
		private var _ghostRedrawTime:Number = 0.0;
		private var _content:MovieClip;
		
		private var _time:Number = 1.0;
		
		public function FxTeleport(x:Number, y:Number, actorGhost:Actor)
		{			
			this.x = x;
			this.y = y;
			
			if(actorGhost)
			{
				_actor = actorGhost;
				_ghostSprite = new Sprite();
				_ghost = new Bitmap(null, PixelSnapping.NEVER, true);
				redrawGhostSprite();
				addChild(_ghostSprite);
			}
			
			_content = AssetManager.getMovieClip("mc_teleport");
			_content.x = int(Player.HIT_WIDTH*0.5);
			_content.y = int(Player.HIT_HEIGHT*0.5);
			_content.transform.colorTransform = new ColorTransform(0.0, 0.0, 0.0);
			addChild(_content);			
			
		}
		
		private function redrawGhostSprite():void
		{
			var bounds:Rectangle = _actor.content.getBounds(_actor.content);
			
			_ghost.bitmapData = new BitmapData(bounds.width, bounds.height, true, 0x0);
			_ghost.bitmapData.draw(_actor.content, new Matrix(1, 0, 0, 1, -bounds.left, -bounds.top));
			_ghost.smoothing = true;
			_ghost.x = -bounds.width*0.5;
			_ghost.y = -bounds.height*0.5;
			_ghostSprite.addChild(_ghost);
			_ghostSprite.x = bounds.left+bounds.width*0.5;
			_ghostSprite.y = bounds.top+bounds.height*0.5;
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_time -= dt / Player.TELEPORT_TIME;
			if(_time <= 0.0)
			{
				if(parent) parent.removeChild(this);
				return;
			}
			
			if(_time > 0.0)
			{
				if(_content)
				{
					_content.rotation += dt*360;
					
					var sc:Number = Cubic.easeInOut(_time, 0, 0, 0);
					_content.scaleX = sc;
					_content.scaleY = sc;
				}
				
				if(_ghost)
				{
					_ghostRedrawTime += dt*4.0;
					if(_ghostRedrawTime > 1.0)
					{
						_ghostRedrawTime = 0.0;
						redrawGhostSprite();
					}
					
					_ghostSprite.alpha = 0.2 + (1.0-Cubic.easeOut(_time, 0, 0, 0))*0.6 + 0.2*Math.sin(Math.PI*32*_time);
					_ghostSprite.scaleY = 0.95+0.05*Math.sin(Math.PI*8*_time);
					_ghostSprite.scaleX = 0.95+0.05*Math.cos(Math.PI*8*_time);
				}
				
			}
		}
	}
}
