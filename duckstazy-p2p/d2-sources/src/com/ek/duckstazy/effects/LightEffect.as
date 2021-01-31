package  
com.ek.duckstazy.effects
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author eliasku
	 */
	public class LightEffect extends Sprite
	{
		private var _shape:Shape = new Shape();
		private var _tween:Number = 0.0;
		private var _speed:Number = 0.5;
		
		public function LightEffect(width:int, height:int) 
		{
			var g:Graphics = _shape.graphics;
			g.beginFill(0xffffff);
			g.drawRect(-4, -4, width+8, height+8);
			g.endFill();
			
			visible = false;
			addChild(_shape);
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function update(dt:Number):void
		{
			if(_tween > 0.0)
			{
				_tween -= dt*_speed;
				if(_tween <= 0.0)
					visible = false;
				else
					_shape.alpha = Math.pow(_tween, 2);
			}
		}
		
		public function start(amount:Number = 1.0):void
		{
			if(amount > _tween)
			{
				_tween = amount;
				_shape.alpha = Math.pow(_tween, 2);
				if(!visible)
					visible = true;
			}
		}
	}
}
