package com.ek.duckstazy.game.nav
{
	/**
	 * @author eliasku
	 */
	public class NavNode
	{
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		public var links:Vector.<NavNode> = new Vector.<NavNode>();
	
		public var side:int;
		public var ground:Boolean;
		public var groundDistance:Number = 0.0;

		public function NavNode(x:Number, y:Number, width:Number, height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
		}
		
		public function get bottom():Number
		{
			return y + height;
		}
		
		public function get right():Number
		{
			return x + width;
		}
	}
}
