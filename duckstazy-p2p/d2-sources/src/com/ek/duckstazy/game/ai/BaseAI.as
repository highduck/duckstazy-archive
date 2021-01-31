package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.InputMap;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;
	import com.ek.duckstazy.game.nav.NavGraph;
	import com.ek.duckstazy.game.nav.NavNode;
	import com.ek.duckstazy.game.nav.NavPath;
	import com.ek.duckstazy.game.nav.NavScanner;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	
	/**
	 * @author eliasku
	 */
	public class BaseAI
	{
		// AI owner
		private var _player:Player;
		private var _level:Level;
		private var _scene:LevelScene;
		
		// AI controls
		private var _lastKeys:Object = new Object();
		private var _keys:Object = new Object();
		private var _inputMap:Object = new Object();
		
		private var _shooting:Boolean;
		private var _fly:Boolean;
		private var _moveUp:Boolean;
		private var _diving:Boolean;
		private var _moveDirection:int;
		
		private var _navGraph:NavGraph = new NavGraph();
		private var _moveTarget:Point;
		private var _movePath:Vector.<NavNode>;
		private var _moveNode:NavNode;
		
		
		public function BaseAI(player:Player):void
		{
			_player = player;
			_level = player.level;
			
			const ids:Array = [Player.KEY_ID_UP, Player.KEY_ID_DOWN, Player.KEY_ID_LEFT, Player.KEY_ID_RIGHT, Player.KEY_ID_FIRE];
			for each (var id:String in ids)
			{
				_keys[id] = false;
				_lastKeys[id] = false;
				_inputMap[id] = 0x0;
			}
		}
		
		public function onStart():void
		{
			_scene = _player.scene;
			_navGraph = _scene.createNavGraph();
		}
		
		// level calls update stage 60 times per second (fixed time steps):
		// player update stage call AI update, then read inputMap from AI and 
		// next process all other stuff depending on generated input
		public function update(dt:Number):void
		{
			beginInput();
			
			if(_moveTarget)
			{
				processMoving(dt);
			}
			
			process(dt);
			
			//_moveUp = true;
			//_moveDirection = 0;
			processBasics(dt);
			
			
			
			endInput();
		}

		
		private function beginInput():void
		{
			for (var name:String in _keys)
			{
				_lastKeys[name] = _keys[name];
				_keys[name] = false;
			}
		}
		
		private function endInput():void
		{
			var last:Boolean;
			var now:Boolean;
			var state:int;
			
			for (var name:String in _inputMap)
			{
				last = _lastKeys[name];
				now = _keys[name];
				
				state = 0x0;
				
				if(!last && now) state |= InputMap.KEY_DOWN;
				else if(last && !now) state |= InputMap.KEY_UP;
				else if(last && now) state |= InputMap.KEY_PRESSED;
				
				_inputMap[name] = state;
			}
		}
		
		protected function process(dt:Number):void
		{
		}
		

		public function get inputMap():Object
		{
			return _inputMap;
		}

		public function get player():Player
		{
			return _player;
		}

		public function get shooting():Boolean
		{
			return _shooting;
		}

		public function set shooting(value:Boolean):void
		{
			_shooting = value;
		}

		private function processBasics(dt:Number):void
		{
			if(_moveDirection != 0)
			{
				if(_moveDirection > 0)
				{
					setKey(Player.KEY_ID_LEFT, false);
					setKey(Player.KEY_ID_RIGHT);
				}
				else if(_moveDirection < 0)
				{
					setKey(Player.KEY_ID_RIGHT, false);
					setKey(Player.KEY_ID_LEFT);
				}
			}
				
			if(_shooting)
			{
				toogleKey(Player.KEY_ID_FIRE);
			}
			
			if(_moveUp)
			{
				// phase1
				if(_player.grounded)
				{
					if(getLastKey(Player.KEY_ID_UP))
					{
						setKey(Player.KEY_ID_UP, false);
					}
					else
					{
						setKey(Player.KEY_ID_UP);
					}
				}
				else
				{
					if(_player.vy < 0.0)
					{
						setKey(Player.KEY_ID_UP);
					}
					else
					{
						if(!_player.doubleJump && !_player.pickedItem)
						{
							if(getLastKey(Player.KEY_ID_UP))
							{
								setKey(Player.KEY_ID_UP, false);
							}
							else
							{
								setKey(Player.KEY_ID_UP);
							}
						}
						else
						{
							// landing
							//_moveUpLanding = !(_fly && !_player.pickedItem);
							//setKey(Player.KEY_ID_UP, !_moveUpLanding);
							setKey(Player.KEY_ID_UP, false);
						}
					}
				}
			}
			else
			{
				setKey(Player.KEY_ID_UP, false);
			}
			
			if(_diving && (_player.canDive || _player.dive))
			{
				setKey(Player.KEY_ID_DOWN);
			}
		}
		
		public function testFreeRectangle(x:Number, y:Number, width:Number, height:Number):Boolean
		{
			var actors:Vector.<Actor> = _scene.grid.queryRect(x, y, width, height, ActorMask.BLOCK);
					
			if(actors.length > 0)
				return false;
			
			return true;
		}
		
		private function setPlayerToPathNodes():Boolean
		{
			var node:NavNode;
			var i:int = _movePath.indexOf(_moveNode) + 1;
			
			while(i < _movePath.length)
			{
				node = _movePath[i];
				if(node && _player.checkBox(node.x, node.y, node.width, node.height))
				{
					_moveNode = node;
					return true;
				}
				++i;
			}
			
			return false;
		}
		
		private function processMoving(dt:Number):void
		{
			var node1:NavNode = _moveNode;
			var node2:NavNode;
			var node3:NavNode;
			var movement:MovementResult = new MovementResult(_player.centerX, _player.bottom);
			var i:int;
			var ori:int;
			var portal:Rectangle;
			var d:Number;
			
			if(node1)
			{
				i = _movePath.indexOf(node1);
				
				if(i + 1 < _movePath.length)
					node2 = _movePath[i+1];
					
				if(i + 2 < _movePath.length)
					node3 = _movePath[i+2];

				if(_player.checkBox(node1.x, node1.y, node1.width, node1.height))
				{
					if(node2)
					{
						ori = NavScanner.getLinkOrientation(node1, node2);
						portal = NavScanner.getPortal(node1, node2);
						
						if(ori == NavScanner.LINK_HORIZONTAL)
						{
							if(node1.ground && node2.ground)
							{
								processGroundLinkHori(movement, node1, node2, portal);
							}
							else
							{
								if(node1.ground && !node2.ground && node2.bottom > node1.bottom && node3 && node3.y > node2.y)
								{
									movement.x = node2.x + node2.width*0.5;
									if(_player.right > node1.x || _player.x < node1.right)
									{
										movement.y = node1.bottom;
										movement.walk = true;
									}
								}
								else
								{
									processDefaultLinkHori(movement, node1, node2, portal);
								}
							}
						}
						else
						{
							// ВЕТРИКАЛЬНАЯ ДЫРКА
							processLinkVerti(movement, node1, node2, portal);
						}
					}
					else
					{
						processTargetMovement(movement, _moveNode);
					}
				}
				else
				{
					if(setPlayerToPathNodes())
					{
						processMoving(dt);
						return;
					}
					else
					{
						moveTo(_moveTarget.x, _moveTarget.y);
						processMoving(dt);
						return;
					}
				}
			}
			
			moveDirection = 0;
			var vx:Number = _player.vx;
			var a:Number = _player.getHorizontalAcceleration();
			var pred_k:Number = 0.5;
			var s:Number = pred_k*(vx*vx)/(2.0*a);
			if(Math.abs(_player.centerX - movement.x) >= 0.5)
			{
				if(_player.centerX + s < movement.x)
				{
					moveDirection = 1;
					//if(_player.vx > 0 && moveX - cx < 5.0)				
				}
				else if(_player.centerX - s > movement.x)
				{
					moveDirection = -1;
					//if(_player.vx < 0 && moveX - cx > 5.0)
				}
			}
			
			//moveDirection = 0;
			
			var jumpHeight:Number = int(_player.y + _player.height - movement.y);
			var jumpKnown:Number = 0.0;
			if(jumpHeight > 0 && !movement.walk)
			{
				
				// Чтобы не прыгал сразу как только поменял путь и думает что допрыгнет до высоты портала
				// Вместо этого опускаемся пока не хватит высоты прыжка
				jumpKnown = _player.getJumpHeight();
				if(jumpKnown >= jumpHeight)
				{
					moveUp = true;
					//trace("on " + jumpKnown);
				}
				else
				{
					moveUp = (jumpHeight < 5) && !movement.walk;
				}
			}
			else
			{
				moveUp = (jumpHeight > -5) && !movement.walk;
			}
				
			
			/*var g:Graphics = _player.content.graphics;
			g.clear();
			g.lineStyle(2, 0xff0000);
			g.moveTo(0, _player.height);
			g.lineTo(0, _player.height-jumpHeight);
			g.lineStyle(2, 0x0000ff);
			g.moveTo(_player.width, _player.height);
			g.lineTo(_player.width, _player.height-_player.getJumpHeight());
			g.lineStyle(2, 0x00ff00);
			g.moveTo(_player.width*0.5, _player.height);
			g.lineTo(movement.x - _player.x, movement.y - _player.y);
			g.lineStyle(2, 0xffff00);	
			g.moveTo(_player.width*0.5, _player.height);
			g.lineTo(_player.width*0.5+_player.getJumpLength(_player.getJumpHeight()), _player.height - _player.getJumpHeight());*/
		}


		
		
		public function getKey(keyId:String):Boolean
		{
			return _keys[keyId];
		}
		
		public function getLastKey(keyId:String):Boolean
		{
			return _lastKeys[keyId];
		}
		
		public function setKey(keyId:String, state:Boolean = true):void
		{
			_keys[keyId] = state;
		}
		
		public function toogleKey(keyId:String):void
		{
			_keys[keyId] = !(_lastKeys[keyId]);
		}

		public function get moveUp():Boolean
		{
			return _moveUp;
		}

		public function set moveUp(value:Boolean):void
		{
			_moveUp = value;
		}

		public function get diving():Boolean
		{
			return _diving;
		}

		public function set diving(value:Boolean):void
		{
			_diving = value;
		}

		public function get moveDirection():int
		{
			return _moveDirection;
		}

		public function set moveDirection(value:int):void
		{
			_moveDirection = value;
		}

		public function get movePath():Vector.<NavNode>
		{
			return _movePath;
		}

		public function set movePath(value:Vector.<NavNode>):void
		{
			_movePath = value;
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			var start:NavNode = _navGraph.getPointNode(_player.x + _player.width*0.5, _player.y + _player.height*0.5);
			var end:NavNode = _navGraph.getPointNode(x, y);
			
			NavPath.jumpHeight = _player.getMaxJumpHeight();
			movePath = NavPath.getPath(_navGraph, start, end);
			
			if(movePath)
			{
				NavPath.optimizePath(_scene, _movePath);
				_moveTarget = new Point(x, y);
				_moveNode = movePath[0];
			}
			else
			{
				stopMoving();
			}
		}
		
		public function moveToActor(actor:Actor):void
		{
			if(actor)
				moveTo(actor.x + actor.width*0.5, actor.y + actor.height*0.5);
			else
				stopMoving();
		}

		public function stopMoving():void
		{
			moveDirection = 0;
			moveUp = false;
			fly = false;
			_moveTarget = null;
			_movePath = null;
			_moveNode = null;
		}

		public function get moveTarget():Point
		{
			return _moveTarget;
		}

		public function get fly():Boolean
		{
			return _fly;
		}

		public function set fly(value:Boolean):void
		{
			_fly = value;
		}

		public function get level():Level
		{
			return _level;
		}

		public function get scene():LevelScene
		{
			return _scene;
		}
		
		public function processTargetMovement(out:MovementResult, node:NavNode):MovementResult
		{
			var d:Number;
			
			if(_player.grounded && _player.bottom < node.bottom - 1)
			{
				if(_player.x <= node.x)
				{
					out.x = node.x + _player.width*0.5 + 1;
				}
				else if(_player.right >= node.right)
				{
					out.x = node.right - _player.width*0.5 - 1;
				}
			}
			else
			{
				out.x = _moveTarget.x;
			}
				
			if(node.ground)
			{
				d = Math.abs(_moveTarget.y - _player.y - _player.height*0.5); 
				if(_player.x - d <= out.x && _player.x + _player.width + d >= out.x)
				{
					out.y = _moveTarget.y + _player.height*0.5;
				}
				else
				{
					out.y = _moveNode.y + _moveNode.height;
					out.walk = true;
				}
			}
			else
			{
				out.y = _moveTarget.y + _player.height*0.5;
			}
			
			return out;
		}
		
		public function processGroundLinkHori(out:MovementResult, start:NavNode, end:NavNode, portal:Rectangle):MovementResult
		{
			var d:Number;
			
			//start.bottom <= end.bottom || 
			if(_player.bottom <= end.bottom) 
			{ 
				out.x = end.x + end.width*0.5;
			}
			else
			{
				if(_player.x < start.x)
				{
					out.x = start.x + _player.width*0.5;
				}
				else if(_player.right > start.right) 
				{
					out.x = start.right - _player.width*0.5;
				}
				
				d = _player.getJumpLength(_player.bottom - end.bottom);
				
				if(start.x < end.x)
				{
					if(end.x - _player.width*0.5 - d > out.x)
						out.x = end.x - _player.width*0.5 - d;
				}
				else if(start.x > end.x)
				{
					if(start.x + _player.width*0.5 + d < out.x)
						out.x = start.x + _player.width*0.5 + d;
				}
			}
			
			if(start.bottom <= end.bottom)
			{
				out.y = start.bottom;
				out.walk = true;
			}
			else
			{
				if(!_player.grounded || Math.abs(_player.centerX - portal.x)-_player.width*0.5 <= _player.getJumpLength(start.bottom - end.bottom))
				{
					out.y = portal.bottom;
				}
				else
				{
					out.y = start.bottom;
					out.walk = true;
				}
			}
			
			return out;
		}
		
		
		private function processDefaultLinkHori(out:MovementResult, node1:NavNode, node2:NavNode, portal:Rectangle):MovementResult
		{
			var d:Number;
			
			// можно входить в портал				
			if(_player.bottom <= portal.bottom)//_player.py >= portal.top &&
			{ 
				out.x = node2.x + node2.width*0.5;
			}
			else
			{
				if(_player.x < node1.x)
					out.x = node1.x + _player.width*0.5;
				else if(_player.right > node1.right)
					out.x = node1.right - _player.width*0.5;
				
				d = _player.getJumpLength(_player.bottom - portal.bottom);//_player.bottom - portal.bottom;
				if(node1.x < node2.x)
				{
					if(node2.x - _player.width*0.5 - d > out.x)
						out.x = node2.x - _player.width*0.5 - d;
				}
				else if(node1.x > node2.x)
				{
					if(node1.x + _player.width*0.5 + d < out.x)
						out.x = node1.x + _player.width*0.5 + d;
				}
			}
			
			if(node1.ground || node2.ground)
			{
				if(Math.abs(_player.centerX - portal.x) <= 100)//_player.getJumpLength(Math.abs(_player.bottom - portal.bottom)))
				{
					if(out.y > portal.bottom)
						out.y = portal.bottom - 10;
					else
						out.y = portal.bottom;
				}
				else
				{
					if(node1.ground)
					{
						out.y = _moveNode.bottom;
						out.walk = true;
					}
				}
			}
			else
			{
				if(portal.top + _player.height < out.y)
					out.y = portal.top + _player.height;
				else if(portal.bottom > out.y)
					out.y = portal.bottom - 10;
				//if(moveY > portal.y + portal.height*0.5 )
					//moveY = portal.y + portal.height*0.5;
			}
			
			return out;
		}
		
		private function processLinkVerti(out:MovementResult, node1:NavNode, node2:NavNode, portal:Rectangle):MovementResult
		{
			var d:Number;
			
			// TODO: проверить что путь свободен, т.к. слева и/или справа так же может быть проходимая область
			// это решит проблему с прицеливанием в портал в узких областях.
			
			if(node2.bottom > _player.bottom)
			{
				d = Math.abs(node2.bottom - _player.bottom);
				
				if(_player.centerX > portal.left-d && _player.centerX < portal.right+d)
				{
					out.y = node2.bottom;
				}
				else
				{
					out.y = node1.bottom;
					out.walk = true;
				}
			}
			else
			{
				d = _player.getJumpLength(_player.bottom - portal.bottom);
				
				if(_player.centerX > portal.left-d && _player.centerX < portal.right+d)
				{
					out.y = node2.bottom;
				}
				else
				{
					out.y = node1.bottom;
					out.walk = true;
				}
			}
			
			if(portal.left + _player.width*0.5 >= out.x)
				out.x = portal.left + _player.width*0.5;
			else if(portal.right - _player.width*0.5 <= out.x)
				out.x = portal.right - _player.width*0.5;
				
			return out;
		}
		
		public function sortOnDistanceToPlayer(a:Actor, b:Actor):Number
		{
		    var distA:Number = Number.MAX_VALUE;
		    var distB:Number = Number.MAX_VALUE;
		    
		    if(a) distA = a.distanceTo(_player);
			if(b) distB = b.distanceTo(_player);
			
		    if(distA > distB)
		    {
		        return 1;
		    }
		    else if(distA < distB)
		    {
		        return -1;
		    }
		    
		    return 0;
		}
	}
}
