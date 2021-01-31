package  
com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;

	import flash.display.Graphics;

	/**
	 * @author eliasku
	 */
	public class Block extends Actor 
	{
		private var _side:int = 0;
		
		public function Block(level:Level)
		{
			super(level);
			
			gridMask = ActorMask.BLOCK;
		}
		
		public override function onStart():void
		{
			var g:Graphics = content.graphics;
			
			g.clear();
			g.beginFill(0x000000);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			if(_side != 0)
			{
				g.beginFill(0x000000, 0.5);
				if(_side > 0)
					g.drawRect(0, -4, width, 4);
				else
					g.drawRect(0, height, width, 4);
				g.endFill();
			}
		}
		
		public override function checkBox(posx:Number, posy:Number, width:Number, height:Number, actor:Actor = null):Boolean
		{
			var coll:Boolean = super.checkBox(posx, posy, width, height, actor);
			
			if(coll && _side != 0 && actor)
				coll = (actor.vy >= 0 && _side < 0 && actor.y + actor.height < y) || (actor.vy <= 0 && _side > 0 && actor.y > y + height);
				
			return coll;
		}
		
		public override function loadProperties(xml:XML):void
		{
			super.loadProperties(xml);
			
			if(xml.hasOwnProperty("@side")) _side = xml.@side;
		}
		
		public override function saveProperties(xml:XML):void
		{
			super.saveProperties(xml);
			
			if(_side != 0) xml.@side = _side;
		}
		
		public override function onGizmo(g:Graphics):void
		{
			super.onGizmo(g);
			
			g.beginFill(0xcc3300, 0.5);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			if(_side != 0)
			{
				g.lineStyle();
				g.beginFill(0x44cc44, 0.5);
				if(_side > 0)
					g.drawRect(0, -4, width, 4);
				else
					g.drawRect(0, height, width, 4);
				g.endFill();
			}
		}

		public function get side():int
		{
			return _side;
		}

		public function set side(value:int):void
		{
			_side = value;
		}
	}
}
