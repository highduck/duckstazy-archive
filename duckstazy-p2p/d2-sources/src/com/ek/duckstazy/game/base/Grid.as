package com.ek.duckstazy.game.base
{
	import flash.display.Graphics;


	/**
	 * @author eliasku
	 */
	public class Grid
	{
		// Массив ячеек
		private var _nodes:Vector.<GridNode>;
		
		// Число столбцов и строк в сетке
		private var _cols:int;
		private var _rows:int;
		
		// Размеры ячейки
		private var _nodeWidth:int;
		private var _nodeHeight:int;
		
		// Начало отсчёта
		private var _startX:int;
		private var _startY:int;
		
		// Размеры поля
		private var _width:int;
		private var _height:int;
		
		// Список для сбора объектов из сетки.
	 	// Таких объектов, которые содержаться в ячейках прошедших какой-либо тест
		private var _queryActors:Vector.<Actor> = new Vector.<Actor>();
		
		public function Grid(x:Number, y:Number, width:Number, height:Number)
		{
			var i:uint;
			var nodesCount:uint;
			
			_startX = int(x);
			_startY = int(y);
			_nodeWidth = 64;
			_nodeHeight = 64;
			_width = int(width)+2;
			_height = int(height)+2;
			_cols = int(_width/_nodeWidth)+1;
			_rows = int(_height/_nodeHeight)+1;
			
			nodesCount = _cols*_rows;
			
			_nodes = new Vector.<GridNode>(nodesCount, true);	
			
			while(i < nodesCount)
			{
				_nodes[i] = new GridNode(_startX, _startY, i % _cols, i / _cols, _nodeWidth, _nodeHeight);
				++i;
			}
		}
		
		public function draw(g:Graphics):void
		{
			for each (var node:GridNode in _nodes)
				node.draw(g);
		}
		
		public function cleanup():void
		{
			for each (var node:GridNode in _nodes)
				node.clear();
		}
		
		private function pushCellObjects(node:GridNode, mask:uint):void
		{
			for each (var actor:Actor in node._actors)
			{
				if( actor.gridMask & mask && _queryActors.indexOf(actor) < 0 )
				{
					_queryActors.push(actor);
				}
			}
		}
		
		// Удалить объект из сетки
		public function remove(actor:Actor):void
		{
			var actorNodes:Vector.<GridNode> = actor._cnodes;
			
			for each (var node:GridNode in actorNodes)
			{
				node.remove(actor);
			}
			
			actorNodes.length = 0;
		}
		
		public function replace(actor:Actor):void
		{
			var col_beg:int = (int(actor.x) - _startX) >> 6;
			var row_beg:int = (int(actor.y) - _startY) >> 6;
			var col_end:int = ((int(actor.right) - _startX) >> 6 ) + 1;
			var row_end:int = ((int(actor.bottom) - _startY) >> 6 ) + 1;
				
			if(col_beg < 0) col_beg = 0;
			if(row_beg < 0) row_beg = 0;
			if(col_end > _cols) col_end = _cols;
			if(row_end > _rows) row_end = _rows;
			
			if(row_beg != actor._cy1 ||
			   row_end != actor._cy2 ||
			   col_beg != actor._cx1 ||
			   col_end != actor._cx2)
			{
				remove(actor);
				place(col_beg, row_beg, col_end, row_end, actor);
			}
		}
		
		private function place(colMin:int, rowMin:int, colMax:int, rowMax:int, actor:Actor):void
		{
			const dx:Number = actor.x - _startX - _width;
			const dy:Number = actor.y - _startY - _height;
				
			if(actor.width >= 0 && actor.height >= 0 && dx < 0 && dy < 0)
			{
				var col_it:uint = colMin;
				var row_it:uint = rowMin;
				var node_it:uint = _cols*rowMin + colMin;
				var node:GridNode;
				
				while(row_it < rowMax)
				{
					while(col_it < colMax)
					{
						node = _nodes[node_it];
						node._actors.push(actor);
						actor._cnodes.push(node);
						++col_it;
						++node_it;
					}
					
					node_it += _cols + colMin - colMax;
					col_it = colMin;
					++row_it;
				}
				
				actor._cx1 = colMin;
				actor._cx2 = colMax;
				actor._cy1 = rowMin;
				actor._cy2 = rowMax;
			}
			else
			{
				actor._cx1 = 
				actor._cx2 = 
				actor._cy1 = 
				actor._cy2 = -1;
			}
		}
		
		public function queryRect(x:Number, y:Number, width:Number, height:Number, mask:uint, checker:Actor = null):Vector.<Actor>
		{
			var col_beg:int = (int(x) - _startX) >> 6;
			var row_beg:int = (int(y) - _startY) >> 6;
			var col_end:int = ((int(x + width) - _startX) >> 6 ) + 1;
			var row_end:int = ((int(y + height) - _startY) >> 6 ) + 1;
			
			if(col_beg < 0) col_beg = 0;
			if(row_beg < 0) row_beg = 0;
			if(col_end > _cols) col_end = _cols;
			if(row_end > _rows) row_end = _rows;
			
			var col_it:uint = col_beg;
			var row_it:uint = row_beg;
			var node_it:uint = _cols*row_beg + col_beg;
			var node:GridNode;
			var actor:Actor;
			
			_queryActors.length = 0;
			
			while(row_it < row_end)
			{
				while(col_it < col_end)
				{
					node = _nodes[node_it];
					for each (actor in node._actors)
					{
						if(actor._mask & mask && actor.checkBox(x, y, width, height, checker) && _queryActors.indexOf(actor) < 0)
							_queryActors.push(actor);
					}
					
					++col_it;
					++node_it;
				}
				
				node_it += _cols + col_beg - col_end;
				col_it = col_beg;
				++row_it;
			}
			
			return _queryActors;
		}
		
		/*public function testPoint(point:Vector2, mask:uint, arbiter:BcArbiter):void
		{
			if(point.x < 0 || point.y < 0 || point.x >= _width || point.y >= _height)
			{
				return;
			}
			
			var col:int = int(point.x) >> 6;
			var row:int = int(point.y) >> 6;
			var index:int = row * _cols + col;
			var cell:BcGridCell = _cells[index];
			var object:BcGridObject;
			
			pushCellObjects(cell, mask);
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testPointShape(point, object.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearQuery();
		}
		
		public function testObject(gridObject:BcGridObject, mask:uint, arbiter:BcArbiter):void
		{
			var cell:BcGridCell;
			var object:BcGridObject;
			
			for each (cell in gridObject.cells)
			{
				pushCellObjects(cell, mask);
			}
			
			arbiter.tester = gridObject;
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testShapes(object.shape, gridObject.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearQuery();
		}
		
		public function testShape(shape:BcShape, mask:uint, arbiter:BcArbiter):void
		{
			var object:BcGridObject;

			lookShape(shape, mask);
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testShapes(shape, object.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearQuery();
		}*/
	}
}
