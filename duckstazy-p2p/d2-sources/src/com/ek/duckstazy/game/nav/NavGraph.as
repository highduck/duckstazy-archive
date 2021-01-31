package com.ek.duckstazy.game.nav
{
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.actors.Player;

	import flash.display.Graphics;

	/**
	 * @author eliasku
	 */
	public class NavGraph
	{
		private var _nodes:Vector.<NavNode> = new Vector.<NavNode>();
		
		public function NavGraph()
		{
		}
		
		public function addNode(node:NavNode):void
		{
			_nodes.push(node);
		}
		
		public function draw(g:Graphics):void
		{
			var src:NavNode;
			var dest:NavNode;
			
			for each (src in _nodes)
			{
				if(src.ground)
					g.lineStyle(1, 0x8c8c8c);
				else
					g.lineStyle(1, 0xffffff);
					
				g.drawRect(src.x, src.y, src.width, src.height);
			}
			
			g.lineStyle(2, 0xff9900, 0.5);
			for each (src in _nodes)
			{
				for each (dest in src.links)
				{
					drawArrow(g, src.x + src.width*0.5, src.y + src.height*0.5, dest.x + dest.width*0.5, dest.y + dest.height*0.5);
				}
			}

		}
		
		private function drawArrow(g:Graphics, x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			var a:Number = Math.atan2(y2 - y1, x2 - x1);
			var d:Number = 15 * Math.PI / 180.0;
			var l:Number = 8.0;
			
			x1 += l*Math.cos(a);
			y1 += l*Math.sin(a);
			x2 -= l*Math.cos(a);
			y2 -= l*Math.sin(a);
			
			g.moveTo(x1, y1);
			g.lineTo(x2, y2);
			g.lineTo(x2 - l*Math.cos(a-d), y2 - l*Math.sin(a-d));
			g.moveTo(x2, y2);
			g.lineTo(x2 - l * Math.cos(a + d), y2 - l * Math.sin(a + d));
		}
		
		private function drawPathNode(g:Graphics, node:NavNode):void
		{
			g.drawRect(node.x, node.y, node.width, node.height);
		}

		public function get nodes():Vector.<NavNode>
		{
			return _nodes;
		}

		public function getPointNode(x:Number, y:Number):NavNode
		{
			for each (var node:NavNode in _nodes)
			{
				if(x >= node.x && 
					y >= node.y &&
					x < node.x + node.width &&
					y < node.y + node.height)
				{
					return node;	
				}
			}
			return null;
		}

		public function drawPath(g:Graphics, movePath:Vector.<NavNode>, id:int):void
		{
			var src:NavNode;
			var dest:NavNode;
			var offset:int = -4 + id*8;
			var i:int;
			
			if(movePath)
			{
				g.lineStyle(2, Player.COLORS[id]);
				i = 0;
				while ( i < movePath.length )
				{
					drawPathNode(g, movePath[i]);
					++i;
				}

				g.lineStyle(3, Player.COLORS[id]);
				i = 0;
				while ( i + 1 < movePath.length )
				{
					src = movePath[i];
					dest = movePath[i+1];
					drawArrow(g, src.x + src.width*0.5, src.y + src.height*0.5 + offset, dest.x + dest.width*0.5, dest.y + dest.height*0.5 + offset);
					++i;
				}
				
			}
		}
		
		private static var _navLibrary:Object = new Object();
		
		public static function getNavGraph(scene:LevelScene):NavGraph
		{
			var graph:NavGraph;
			var scanner:NavScanner;
			var navId:String = scene.level.id + "__" + scene.name;
			
			if(!_navLibrary.hasOwnProperty(navId))
			{
				graph = new NavGraph();
				scanner = new NavScanner(scene, graph);
				scanner.generate();
				_navLibrary[navId] = graph;
			}
			
			return _navLibrary[navId];
		}
		
	}
}