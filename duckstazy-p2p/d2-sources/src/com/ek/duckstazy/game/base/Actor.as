package  
com.ek.duckstazy.game.base
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.ParserUtil;
	import com.ek.library.utils.Vector2;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;




	/**
	 * @author eliasku
	 */
	public class Actor 
	{
		public static const COLLIDE_H:int = 0x1;
		public static const COLLIDE_V:int = 0x2;
		
		private static var V:Vector2 = new Vector2();
		
		internal var _cnodes:Vector.<GridNode> = new Vector.<GridNode>();
		internal var _cx1:int = -1;
		internal var _cx2:int = -1;
		internal var _cy1:int = -1;
		internal var _cy2:int = -1;
		
		internal var _mask:uint = ActorMask.DEFAULT;
		
		private var _content:GameObject;
		private var _name:String = "unnamed";
		private var _type:String = "actor";
		private var _level:Level;
		private var _scene:LevelScene;
		private var _layer:GameObject;
		private var _layerName:String = "main";
		private var _gizmo:Sprite;
		
		private var _dead:Boolean;
	
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		private var _width:Number = 0.0;
		private var _height:Number = 0.0;
		
		private var _vx:Number = 0.0;
		private var _vy:Number = 0.0;
		
		private var _predicted:Boolean;
		protected var _predX:Number = 0.0;
		protected var _predY:Number = 0.0;
		protected var _predVX:Number = 0.0;
		protected var _predVY:Number = 0.0;
		
		private var _actorsProcessed:Vector.<Actor> = new Vector.<Actor>();
		
		public function Actor(level:Level)
		{
			_content = new GameObject();
			_content.mouseChildren = false;
			_content.mouseEnabled = false;
			_level = level;
		}
		
		public function onStart():void
		{
		}
		
		public function onSceneEnter():void
		{
			updateTransform();
			_scene.grid.replace(this);
			_layer = _scene.getLayer(_layerName);
			
			if(_layer)
				_layer.addChild(_content);
		}
		
		public function onSceneExit():void
		{
			if(_layer)
				_layer.removeChild(_content);
				
			_layer = null;
			_scene.grid.remove(this);
		}
		
		public function loadProperties(xml:XML):void
		{
			if(!xml) return;
			
			var node:XML;
			
			node = xml.transform[0];
			if(node)
			{
				if(node.hasOwnProperty("@position"))
				{
					V = ParserUtil.parseVector2(node.@position, V);
					_x = V.x;
					_y = V.y;
				}
				
				if(node.hasOwnProperty("@scale"))
				{
					V = ParserUtil.parseVector2(node.@scale, V);
					_content.scaleX = V.x;
					_content.scaleY = V.y;
				}
				
				if(node.hasOwnProperty("@rotation"))
				{
					_content.rotation = Number(node.@rotation);
				}
			}
			
			if(xml.hasOwnProperty("@hit"))
			{
				V = ParserUtil.parseVector2(xml.@hit, V);
				_width = V.x;
				_height = V.y;
			}
			
			if(xml.hasOwnProperty("@name"))
				_name = xml.@name;
			
			updateTransform();
		}
		
		public function saveProperties(xml:XML):void
		{
			if(!xml) return;
			
			var node:XML;
			
			node = XML("<transform/>");
			if(_x != 0 || _y != 0) node.@position = _x.toString() + "; " + _y;
			if(_content.scaleX != 1.0 || _content.scaleY != 1.0) node.@scale = _content.scaleX.toString() + "; " + _content.scaleY;
			if(_content.rotation != 0.0) node.@rotation = _content.rotation.toString();
			
			xml.appendChild(node);
			
			if(_name.length > 0 && _name.indexOf("unnamed") != 0)
				xml.@name = _name;
				
			xml.@type = _type;
			
			if(_width != 0 || _height != 0) xml.@hit = _width.toString() + "; " + _height;
		}

		public function updateTransform():void
		{
			if(Math.abs(_x - _content.x) >= 0.1 || Math.abs(_y - _content.y) >= 0.1)
			{
				_content.x = _x;
				_content.y = _y;
			}
			
			if(_scene)
			{
				_scene.grid.replace(this);
			}
		}
		
		public function checkBox(posx:Number, posy:Number, width:Number, height:Number, checker:Actor = null):Boolean
		{
			return  _x < posx + width && 
					_x + _width > posx && 
					_y < posy + height && 
					_y + _height > posy;
		}
		
		public function checkActor(other:Actor):Boolean
		{
			return checkBox(other.x, other.y, other.width, other.height);
		}
        
        public function testBox(x:Number, y:Number, w:Number, h:Number):Boolean
        {
        	if(!scene) return false;
        	
        	var bounds:Rectangle = _scene.worldBounds;
            
            if( x + w > bounds.right ||
            	x < bounds.x ||
            	y + h > bounds.bottom ||
            	y < bounds.y) return true;
            	
            return _scene.grid.queryRect(x, y, w, h, ActorMask.BLOCK, this).length > 0;
		}
		
		public function get level():Level
		{
			return _level;
		}
		
		public function update(dt:Number):void
		{
			if(_predicted)
			{
				_predicted = false;
				_content.x = _x;
				_content.y = _y;
			}
		}
		
		public function tick(dt:Number):void
		{
			
		}
		
		public function predict(dt:Number):void
		{
			if(!_predicted)
			{
				_predicted = true;
				_predX = _x;
				_predY = _y;
				_predVX = _vx;
				_predVY = _vy;
			}
			
			onPrediction(dt);
			//predictableMove(dt, true);
			
			_content.x = _predX;
			_content.y = _predY;
		}

		protected function onPrediction(dt:Number):void
		{
			predictableMove(dt, true);
		}

		protected function predictableMove(dt:Number, collideBlocks:Boolean):Boolean
		{
			var nx:Number;
			var ny:Number;
			//var movement:Point = new Point(velocity.x*dt, velocity.y*dt);
			var distance:Number = dt * Math.sqrt(_predVX*_predVX + _predVY*_predVY);
			var max:int = int(1.0+distance);
			var i:int; 
			var hits:int;
			var blocksCollided:int;
			
			if(distance > 0.00001)
			{
				var fraction:Number = 1.0 / Number(max);

				for(i = 0; i < max; ++i)
				{
					nx = _predX + dt * _predVX * fraction;
					ny = _predY + dt * _predVY * fraction;
					
					if(collideBlocks && testBox(nx, ny, _width, _height))
					{
						hits = 0;
						
						if(testBox(_predX, ny, _width, _height))
						{
							ny = _predY;
							_predVY = 0.0;
							++hits;
							blocksCollided |= COLLIDE_V;
						}
						
						if(testBox(nx, _predY, _width, _height))
						{
							nx = _predX;
							_predVX = 0.0;
							++hits;
							blocksCollided |= COLLIDE_H;
						}
						
						if(!hits)
						{
							ny = _predY;
							_predVY = 0.0;
							nx = _predX;
							_predVX = 0.0;
							
							blocksCollided |= COLLIDE_H | COLLIDE_V;
						}
					}
					
					_predX = nx;
					_predY = ny;
					
					if((_predVX*_predVX + _predVY*_predVY) < 1.0)
					{
						_predVX = 0.0;
						_predVY = 0.0;
						break;
					}
				}
			}
			else
			{
				_predVX = 0.0;
				_predVY = 0.0;
			}
			
			return blocksCollided!=0;
		}
		
		public function destroy():void
		{
			if(_scene)
			{
				_scene.removeActor(this);
			}
		}
		
		public function move2(dx:Number, dy:Number, ex:Number = 0.0, ey:Number = 0.0, affectVelocity:Boolean = true, collideBlocks:Boolean = true):Boolean
		{
			var nx:Number;
			var ny:Number;
			//var movement:Point = new Point(velocity.x*dt, velocity.y*dt);
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			var max:int = int(1.0+distance);
			var i:int; 
			var hits:int;
			var blocksCollided:int;
			
			if(distance > 0.00001)
			{
				var fraction:Number = 1.0 / Number(max);
				//trace(distance + "  "+ max);
				for(i = 0; i < max; ++i)
				{
					nx = _x + dx * fraction;
					ny = _y + dy * fraction;
					
					if(collideBlocks && testBox(nx, ny, _width, _height))
					{
						hits = 0;
						
						if(testBox(_x, ny, _width, _height))
						{
							ny = _y;
							_vy *= -ey;
							dy *= -ey;
							
							++hits;
							blocksCollided |= COLLIDE_V;
						}
						
						if(testBox(nx, _y, _width, _height))
						{
							nx = _x;
							_vx *= -ex;
							dx *= -ey;
							
							++hits;
							blocksCollided |= COLLIDE_H;
						}
						
						if(!hits)
						{
							nx = _x;
							ny = _y;
							
							_vx *= -ex;
							_vy *= -ey;
							
							dx *= -ey;
							dy *= -ey;
							
							blocksCollided |= COLLIDE_H | COLLIDE_V;
						}
					}
					
					_x = nx;
					_y = ny;
					
					processActors();
					
					if((_vx*_vx + _vy*_vy) < 1.0)
					{
						_vx = 0.0;
						_vy = 0.0;
						break;
					}
				}
			}
			else
			{
				_vx = 0.0;
				_vy = 0.0;
				
				processActors();
			}
			
			_actorsProcessed.length = 0;
			
			onBlockCollided(blocksCollided);
						
			updateTransform();
			
			
			return blocksCollided!=0;
		}
		
		public function move(dt:Number, elasticity:Point, collideBlocks:Boolean = true):Boolean
		{
			var nx:Number;
			var ny:Number;
			//var movement:Point = new Point(velocity.x*dt, velocity.y*dt);
			var distance:Number = dt * Math.sqrt(_vx*_vx + _vy*_vy);
			var max:int = int(1.0+distance);
			var i:int; 
			var hits:int;
			var blocksCollided:int;
			
			if(distance > 0.00001)
			{
				var fraction:Number = 1.0 / Number(max);
				//trace(distance + "  "+ max);
				for(i = 0; i < max; ++i)
				{
					nx = _x + dt * _vx * fraction;
					ny = _y + dt * _vy * fraction;
					
					if(collideBlocks && testBox(nx, ny, _width, _height))
					{
						hits = 0;
						
						if(testBox(_x, ny, _width, _height))
						{
							ny = _y;
							_vy *= -elasticity.y;
							++hits;
							blocksCollided |= COLLIDE_V;
						}
						
						if(testBox(nx, _y, _width, _height))
						{
							nx = _x;
							_vx *= -elasticity.x;
							++hits;
							blocksCollided |= COLLIDE_H;
						}
						
						if(!hits)
						{
							ny = _y;
							_vy *= -elasticity.y;
							nx = _x;
							_vx *= -elasticity.x;
							blocksCollided |= COLLIDE_H | COLLIDE_V;
						}
					}
					
					_x = nx;
					_y = ny;
					
					processActors();
					
					if((_vx*_vx + _vy*_vy) < 1.0)
					{
						_vx = 0.0;
						_vy = 0.0;
						break;
					}
				}
			}
			else
			{
				_vx = 0.0;
				_vy = 0.0;
				
				processActors();
			}
			
			_actorsProcessed.length = 0;
			
			onBlockCollided(blocksCollided);
						
			updateTransform();
			
			
			return blocksCollided!=0;
		}
		
		protected function onBlockCollided(hits:int):void
		{
			
		}
		
		protected function processActors():void
		{
			var actors:Vector.<Actor> = _scene.grid.queryRect(_x, _y, _width, _height, ActorMask.ALL, this);
			var actor:Actor;
			
			for each (actor in actors)
			{
				if(actor != this && _actorsProcessed.indexOf(actor) < 0)// && actor.checkBox(_x, _y, _width, _height))
				{
					processActor(actor);
						
					_actorsProcessed.push(actor);
				}
			}
		}
		
		protected function processActor(actor:Actor):void
		{
		}
		
		
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function set position(value:Point):void
		{
			if(value)
			{
				_x = value.x;
				_y = value.y;
			}
		}
		
		public function get vx():Number
		{
			return _vx;
		}
		
		public function get vy():Number
		{
			return _vy;
		}
		
		public function set vx(value:Number):void
		{
			_vx = value;
		}
		
		public function set vy(value:Number):void
		{
			_vy = value;
		}

		public function get layer():GameObject
		{
			return _layer;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}
		
		public function get right():Number
		{
			return _x + _width;
		}
		
		public function get bottom():Number
		{
			return _y + _height;
		}
		
		public function get centerX():Number
		{
			return _x + _width*0.5;
		}
		
		public function get centerY():Number
		{
			return _y + _height*0.5;
		}
		
		
		public function distanceTo(actor:Actor):Number
		{
			var dx:Number = actor.x - x;
			var dy:Number = actor.y - y;
			return Math.sqrt(dx*dx + dy*dy);
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function onGizmo(g:Graphics):void
		{
			g.clear();
			g.lineStyle(1, 0x000000, 0.25);
			g.beginFill(0xffffff, 0.25);
			g.drawRect(0, 0, _width, _height);
			g.endFill();
			g.moveTo(0, 0);
			g.lineTo(_width, _height);
			g.moveTo(_width, 0);
			g.lineTo(0, _height);
		}

		public function get gizmo():Sprite
		{
			return _gizmo;
		}

		public function set gizmo(value:Sprite):void
		{
			_gizmo = value;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get gridMask():uint
		{
			return _mask;
		}

		public function set gridMask(value:uint):void
		{
			_mask = value;
		}

		public function get scene():LevelScene
		{
			return _scene;
		}

		public function set scene(value:LevelScene):void
		{
			if(_scene)
			{
				onSceneExit();
				_scene = null;
			}
			
			if(value)
			{
				_scene = value;
				onSceneEnter();
			}
		}


		public function get layerName():String
		{
			return _layerName;
		}

		public function get content():GameObject
		{
			return _content;
		}
		
		public function get dead():Boolean
		{
			return _dead;
		}
		
		public function set dead(value:Boolean):void
		{
			_dead = value;
			// _content.visible = !value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get velocity():Number
		{
			return _vx*_vx + _vy*_vy;
		}
		
	}
}