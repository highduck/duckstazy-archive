package com.ek.duckstazy.game.nav
{
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.actors.Block;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;
	import com.ek.library.debug.Logger;

	import flash.geom.Rectangle;




	
	/**
	 * @author eliasku
	 */
	public class NavScanner
	{
		private var _scene:LevelScene;
		private var _graph:NavGraph;
		private var _checker:Actor;
		
		
		private const JUMP_HEIGHT:Number = 142;
		
		public function NavScanner(scene:LevelScene, graph:NavGraph)
		{
			_scene = scene;
			_graph = graph;
			
			_checker = new Actor(_scene.level);
			_checker.vy = -1;
		}

		public function generate():void
		{
			findNodes();
			//findSideNodes();
			findLinks();
		}
		
		private function findNodes():void
		{
			var x:Number = _scene.worldBounds.left;
			var y:Number = _scene.worldBounds.bottom;
			var xMax:Number = _scene.worldBounds.right;
			var yMin:Number = _scene.worldBounds.top;
			
			while(y > yMin)
			{
				x = _scene.worldBounds.left;
				
				while(x < xMax)
				{
					if(testRectangle(null, x, y, 1, 1))
					{
						scanRectangle(x, y);
					}
					
					x += 1;
				}
				
				y -= 1;
			}
		}
		
		private function findSideNodes():void
		{
			var block:Block;
			var actor:Actor;
			var node:NavNode;
			var blocks:Vector.<Actor> = _scene.getActorsByType("block");
			
			for each (actor in blocks)
			{
				block = actor as Block;
				if(block && block.side == -1)
				{
					node = new NavNode(block.x, block.y, block.width, block.height);
					node.side = block.side;
					_graph.addNode(node);
				}
			}
		}
		
		private function findLinks():void
		{
			var src:NavNode;
			var dest:NavNode;
			var ori:int;
			
			for each (src in _graph.nodes)
			{
				for each (dest in _graph.nodes)
				{
					if(src == dest) continue;

					ori = getLinkOrientation(src, dest);
					
					if(ori > 0)
					{
						if(src.links.indexOf(dest) >= 0)
							Logger.warning("nav_scanner, bad link");
						setLink(src, dest);
					}
				}
			}
		}
		
		public static const LINK_HORIZONTAL:int = 1;
		public static const LINK_VERTICAL:int = 2;
		
		public static function getLinkOrientation(src:NavNode, dest:NavNode):int
		{
			if(src.y + src.height > dest.y &&
				src.y < dest.y + dest.height)
			{
				if((src.x < dest.x && src.x + src.width >= dest.x) ||
				   (src.x > dest.x && src.x <= dest.x + dest.width))
				{
					return LINK_HORIZONTAL;
				}
			}
			
			if(src.x + src.width > dest.x &&
					src.x < dest.x + dest.width)
			{
				if((src.y < dest.y && src.y + src.height >= dest.y) ||
				   (src.y > dest.y && src.y <= dest.y + dest.height))
				{
					return LINK_VERTICAL;
				}
			}
			
			return 0;
		}
		
		
		public static function getPortal(src:NavNode, dest:NavNode):Rectangle
		{
			var rc1:Rectangle = new Rectangle(src.x, src.y, src.width, src.height);
			var rc2:Rectangle = new Rectangle(dest.x, dest.y, dest.width, dest.height);
			var portal:Rectangle = new Rectangle();
			
			portal.left = Math.max(rc1.left, rc2.left);
			portal.top = Math.max(rc1.top, rc2.top);
			portal.bottom = Math.min(rc1.bottom, rc2.bottom);
			portal.right = Math.min(rc1.right, rc2.right);
			
			return portal;
		}

		private function setLink(src:NavNode, dest:NavNode):void
		{
			var portal:Rectangle = getPortal(src, dest);
			
			if(src.y - portal.bottom + src.groundDistance > JUMP_HEIGHT && src.y > dest.y)
				return;
			
			/*if(!src.ground && !dest.ground && src.y + src.height >= dest.y + dest.height)
			{
				return;
			}*/
			
			if(dest.side == -1 && portal.height <= 0 && portal.y <= dest.y)
				return;
			
			//if(Math.max(portal.width, portal.height) < 24) return;
			if(portal.width > 0 && portal.width < 24) return;
			
			src.links.push(dest);
		}

		private function scanRectangle(fromX:Number, fromY:Number):void
		{
			var wMax:Number = _scene.worldBounds.right - fromX;
			var hMax:Number = _scene.worldBounds.bottom - fromY;
			var fails:int;
			var node:NavNode = new NavNode(fromX, fromY, 1, 1);

			while(fails < 2)
			{
				fails = 0;
				
				if(testRectangle(node, node.x, node.y - 1, node.width, node.height + 1) && node.y > _scene.worldBounds.top && node.height + 1 <= 200)
				{
					node.height = node.height + 1;
					node.y -= 1;
				}
				else
				{
					fails++;
				}
				
				if(testRectangle(node, node.x, node.y, node.width + 1, node.height) && node.width < wMax)// && node.width < 48)
				{
					if(fails > 0 && testRectangle(node, node.x + node.width, node.y - 1, 1, node.height + 1))
						fails++;
					else
						node.width = node.width + 1;
				}
				else
				{
					fails++;
				}
			}
			
			if(!testRectangle(node, node.x, node.y, node.width, node.height + 1, false))
			{
				node.ground = true;
				node.groundDistance = node.height;
			}
			else
			{
				node.groundDistance = node.height + findGroundDistance(node.x, node.y, node.width, node.height + 1);
			}
			
			if(node.width > 0 && node.height > 0)
			{
				_graph.addNode(node);
			}
		}
		
		private function testRectangle(node:NavNode, x:Number, y:Number, width:Number, height:Number, testNodes:Boolean = true):Boolean
		{
			var actors:Vector.<Actor> = _scene.grid.queryRect(x, y, width, height, ActorMask.BLOCK);
			var actor:Actor;
			var block:Block;
			
			for each(actor in actors)
			{
				block = actor as Block;
				if(block && block.side == -1)
				{
					if(y < block.y)
					{
						if(node)
						{
							node.side = -1;
						}
						return false;
					}
					else
					{
						actors.splice(actors.indexOf(actor), 1);
					}
				}
			}
				
			if(actors.length > 0)
			{
				return false;
			}
			
			if(testNodes)
			{
				for each (node in _graph.nodes)
				{
					if(x < node.x + node.width && 
					   x + width > node.x && 
					   y < node.y + node.height && 
					   y + height > node.y)
						return false;
				}
			}
			
			return true;
		}
		
		private function findGroundDistance(x:Number, y:Number, width:Number, height:Number):Number
		{
			var node:NavNode;
			
			for each (node in _graph.nodes)
			{
				if(x < node.x + node.width && 
				   x + width > node.x && 
				   y < node.y + node.height && 
				   y + height > node.y)
					return node.groundDistance;
			}
			
			return 0.0;
		}

	}
}
