package com.ek.duckstazy.game.nav
{
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.base.ActorMask;

	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author eliasku
	 */
	public class NavPath
	{
		
		private static var _jumpHeight:Number = 148.0;
		
		public static function getPath(graph:NavGraph, start:NavNode, end:NavNode):Vector.<NavNode>
		{
			var distance:Dictionary = new Dictionary();
			var previous:Dictionary = new Dictionary();
			var Q:Vector.<NavNode> = new Vector.<NavNode>();
			var node:NavNode;
			var u:NavNode;
			var alt:Number;
			var path:Vector.<NavNode>;
			var dist:Number;
			
			for each (node in graph.nodes)
			{
				distance[node] = Number.POSITIVE_INFINITY;
				previous[node] = null;
				Q.push(node);
			}
			
			distance[start] = 0.0;
			
			while(Q.length > 0)
			{
				u = Q[0];
				for each (node in Q)
				{
					if(distance[node] < distance[u])
						u = node;
				}
				
				if(distance[u] == Number.POSITIVE_INFINITY)
				{
					break;
				}
				
				if(u == end)
				{
					break;
				}
				
				Q.splice(Q.indexOf(u), 1);
				
				for each (node in u.links)
				{
					if(Q.indexOf(node) < 0) continue;
					dist = getDistance(previous[u], u, node);
					if(dist < 0.0) continue;
					alt = distance[u] + dist;
					if(alt < distance[node])
					{
						distance[node] = alt;
						previous[node] = u;
						//decrease-key v in Q;      // Reorder v in the Queue
					}
				}
			}
		
			
			if(u == end)
			{
				path = new Vector.<NavNode>();
				while(u)
				{
					path.splice(0, 0, u);
					u = previous[u];
				}
				
				if(path[0] != start)
					path = null;
			}

			return path;
		}
		
		public static function getDistance(start:NavNode, middle:NavNode, end:NavNode):Number
		{
			var p1:Rectangle;
			var p2:Rectangle;
			if(start)
			{
				p1 = NavScanner.getPortal(start, middle);
				p2 = NavScanner.getPortal(middle, end);
				
				if(p2.bottom < p1.top)
				{
					//if(middle.ground)
					//{
						//if(p1.top - p2.bottom > _jumpHeight-2) return -1.0;
						// Не прыгает по небу
					//}
					
					if(middle.y - p2.bottom + middle.groundDistance > _jumpHeight-2 ) return -1.0;
					
				}

				if(middle.bottom > end.bottom && middle.bottom - end.bottom > _jumpHeight) return -1.0;
				if(start.bottom > middle.bottom && start.bottom - middle.bottom > _jumpHeight) return -1.0;
				
				return portalsDistance(p1, p2);//middle.groundDistance;
			}
			else
			{
				if(middle.bottom > end.bottom && middle.bottom - end.bottom > _jumpHeight) return -1.0;
				
			}
			
			return 0.0;
		}
		
		public static function portalsDistance(p1:Rectangle, p2:Rectangle):Number
		{
			//var h:Number = Math.min (Math.abs(p1.left - p2.right), Math.abs(p1.right - p2.left));
			//var v:Number = Math.min (Math.abs(p1.bottom - p2.top), Math.abs(p1.top - p2.bottom));
			var h:Number = Math.abs(p1.x + p1.width*0.5 - p2.x - p2.width*0.5);
			var v:Number = Math.abs(p1.y + p1.height*0.5 - p2.y - p2.height*0.5);
			//const hole:Number = 100.0;
			return v + h;// - (p1.width + p1.height + p2.width + p2.height) / hole;
		}

		static public function get jumpHeight():Number
		{
			return _jumpHeight;
		}

		static public function set jumpHeight(value:Number):void
		{
			_jumpHeight = value;
		}
		
		static public function optimizePath(scene:LevelScene, path:Vector.<NavNode>):void
		{
			var n1:NavNode;
			var n2:NavNode;
			var n3:NavNode;
			
			var x:Number;
			var y:Number;
			var r:Number;
			var b:Number;
			
			var i:int;
			
			while(i+1 < path.length)
			{
				n1 = path[i];
				n2 = path[i+1];
				
				/*if(n1.ground == n2.ground)
				{
					x = Math.min(n1.x, n2.x);
					y = Math.min(n1.y, n2.y);
					r = Math.max(n1.right, n2.right);
					b = Math.max(n1.bottom, n2.bottom);
					
					if(scene.grid.queryRect(x, y, r-x, b-y, ActorMask.BLOCK).length == 0)
					{
						n3 = new NavNode(x, y, r-x, b-y);
						n3.ground = n1.ground && n2.ground;
						path.splice(i, 2, n3);
						continue;
					}
				}*/
				
				x = Math.min(n1.x, n2.x);
				y = Math.min(n1.y, n2.y);
				r = Math.max(n1.right, n2.right);
				b = Math.max(n1.bottom, n2.bottom);
				
				if(scene.grid.queryRect(x, y, r-x, b-y, ActorMask.BLOCK).length == 0)
				{
					n3 = new NavNode(x, y, r-x, b-y);
					n3.ground = n1.ground || n2.ground;
					if(checkPathNodes(n3, path, i))
					{
						path.splice(i, 2, n3);
						continue;
					}
				}
				
				if(n2.y > n1.y)
				{
					if(scene.grid.queryRect(n2.x, n1.y, n2.width, n2.bottom - n1.y, ActorMask.BLOCK).length == 0)
					{
						n3 = new NavNode(n2.x, n1.y, n2.width, n2.bottom - n1.y);
						n3.ground = n2.ground;
						if(checkPathNodes(n3, path, -2))
						{
							path.splice(i+1, 1, n3);
							continue;
						}
					}
				}
				
				++i;
			}
		}
		
		static public function checkPathNodes(node:NavNode, path:Vector.<NavNode>, start:int):Boolean
		{
			var n1:NavNode;
			
			var i:int = 0;
			
			while(i < path.length)
			{
				if(i == start || i == start +1)
				{
					++i;
					continue;
				}
				
				n1 = path[i];
				
				if(n1.x < node.x + node.width && 
				   n1.right > node.x && 
				   n1.y < node.y + node.height && 
				   n1.bottom > node.y)
					return false;
				
				++i;
			}
			
			return true;
		}
	}
}
