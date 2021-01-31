package com.ek.duckstazy.game.base
{
	import com.ek.library.debug.Logger;

	import flash.display.Graphics;


	
	/**
	 * @author eliasku
	 */
	public class GridNode
	{
		private var _col:int;
		private var _row:int;
		
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		internal var _actors:Vector.<Actor> = new Vector.<Actor>();
		
		public function GridNode(startX:int, startY:int, col:uint, row:uint, width:int, height:int)
		{
			_x = startX + col*width;
			_y = startY + row*height;
			_col = col;
			_row = row;
			_width = width;
			_height = height;
		}
		
		// Удаляем объект из ячейки
		internal function remove(actor:Actor):void
		{
			var index:int = _actors.indexOf(actor);
			
			if(index >= 0)
				_actors.splice(index, 1);
			else
				Logger.error("[Grid] nothing to remove!");
		}
		
		// Удаляем все объекты из ячейки
		internal function clear():void
		{
			_actors.length = 0;
		}
		
		public function draw(g:Graphics):void
		{
			var alpha:Number = _actors.length / 16;
			if(alpha>0)
			{
				g.lineStyle(1, 0x0000ff);
				g.beginFill(0xff0000, alpha);
				g.drawRect(_x + 1, _y + 1, _width - 2, _height - 2);
				g.endFill();
			}
			else
			{
				g.lineStyle(1, 0x000000);
				g.drawRect(_x + 1, _y + 1, _width - 2, _height - 2);
			}
		}
		
	}
}
