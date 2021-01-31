package com.ek.duckstazy.edit
{
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorFactory;
	import com.ek.library.core.CoreManager;
	import com.ek.library.gocs.GameObject;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class TransformControl extends GameObject
	{
		private var _editor:Editor;
		private var _target:Object;
		private var _memory:XML;
		
		// transform box
		private var _boxSpider:Shape = new Shape();
		private var _boxBounds:Sprite = new Sprite();
		private var _boxPoints:Vector.<Sprite> = new Vector.<Sprite>();
		
		private var _objectPosition:Point = new Point();
		private var _objectBounds:Rectangle = new Rectangle();
		
		private var _moveSide:int;
		private var _moveVertex:Sprite;
		private var _moveStart:Point;
		
		private var _originalPosition:Point;
		private var _originalBounds:Rectangle;
		
		public function TransformControl(editor:Editor)
		{
			_editor = editor;
			
			initializeBox();
			
			mouseEnabled = false;
			mouseChildren = true;
		}
		
		private function initializeBox():void
		{
			addChild(_boxSpider);
			addChild(_boxBounds);
			
			_boxBounds.buttonMode = true;
			_boxBounds.useHandCursor = true;
			_boxBounds.addEventListener(MouseEvent.MOUSE_DOWN, onBoxMouseDown);
			
			for(var i:int; i < 8; ++i)
			{
				createBoxPoint();
			}
		}
		
		private function createBoxPoint():void
		{
			var point:Sprite = new Sprite();
			var g:Graphics = point.graphics;
			
			g.lineStyle(1, 0x0);
			g.beginFill(0x0dccee);
			g.drawRect(-2, -2, 4, 4);
			g.endFill();
			
			point.buttonMode = true;
			point.useHandCursor = true;
			
			point.addEventListener(MouseEvent.MOUSE_DOWN, onBoxMouseDown);
			//point.addEventListener(MouseEvent.MOUSE_UP, onBoxMouseUp);
			
			addChild(point);
			_boxPoints.push(point);
		}

		public function onKeyDown(event:KeyboardEvent):void
		{
			if(_moveStart) return;
		
			processMovingKeys(event);
			processMemoryKeys(event);
		}

		private function processMemoryKeys(e:KeyboardEvent):void
		{
			if(e.ctrlKey)
			{
				switch(e.keyCode)
				{
					case 0x43:
						onCopy(false);
						return;
					case 0x58:
						onCopy(true);
						return;
					case 0x56:
						onPaste();
						return;
					case Keyboard.SPACE:
						onAlign();
						return;
				}
			}
			else
			{
				switch(e.keyCode)
				{
					case Keyboard.DELETE:
						onRemove();
						return;
					case Keyboard.INSERT:
						onDuplicate();
						return;
				}
			}
		}

		private function processMovingKeys(e:KeyboardEvent):void
		{
			if(!_target || _moveStart) return;
			
			var dx:int;
			var dy:int;
			
			switch(e.keyCode)
			{
				case Keyboard.UP: dy = -1; break;
				case Keyboard.DOWN: dy = 1; break;
				case Keyboard.LEFT: dx = -1; break;
				case Keyboard.RIGHT: dx = 1; break;
			}
			
			if(!e.ctrlKey && !e.shiftKey)
			{
				dx *= Editor.GRID_SIZE;
				dy *= Editor.GRID_SIZE;
			}
			else if(e.shiftKey && !e.ctrlKey)
			{
				dx *= Editor.GRID_SIZE / 2;
				dy *= Editor.GRID_SIZE / 2;
			}
			else if(!e.shiftKey && e.ctrlKey)
			{
				dx *= Editor.GRID_SIZE / 3;
				dy *= Editor.GRID_SIZE / 3;
			}
				
			if(dx != 0 || dy != 0)
			{
				_objectPosition.x += dx;
				_objectPosition.y += dy;
				applyTargetTransform();
			}
		}
		
		
		private function onBoxMouseMove(event:MouseEvent):void
		{
			var dx:Number = 0.0;
			var dy:Number = 0.0;
			var pos:Point = parent.globalToLocal(new Point(event.stageX, event.stageY));
			
			if(_moveStart)
			{
				dx = pos.x - _moveStart.x;
				dy = pos.y - _moveStart.y;
				
				if(event.ctrlKey)
				{
					dx = Editor.GRID_SIZE * int(dx / Editor.GRID_SIZE);
					dy = Editor.GRID_SIZE * int(dy / Editor.GRID_SIZE);
				}
				
				if(_moveVertex)
				{
					if(_moveSide < 8)
					{
						resizeBoundsWithPoint(_moveSide, dx, dy);
					}
					else
					{
						_objectPosition.x = _originalPosition.x + dx;
						_objectPosition.y = _originalPosition.y + dy;
					}
					
					redrawBounds();
				}
			}
			
			
		}

		private function onBoxMouseUp(event:MouseEvent):void
		{
			if(_moveStart)
			{
				_moveVertex = null;
				_moveSide = 0;
				_moveStart = null;
				
				event.stopImmediatePropagation();
				
				CoreManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onBoxMouseMove);
				CoreManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onBoxMouseUp);
				_editor.viewport.mouseEnabled = true;
				_editor.viewport.mouseChildren = true;
				Mouse.cursor = MouseCursor.AUTO;
				
				applyTargetTransform();
			}
		}

		private function onBoxMouseDown(event:MouseEvent):void
		{
			if(!_moveStart)
			{
				if(_boxPoints.indexOf(event.target as Sprite) >= 0)
				{
					_moveVertex = event.target as Sprite;
					_moveSide = _boxPoints.indexOf(_moveVertex);
				}
				else
				{
					_moveVertex = _boxBounds;
					_moveSide = 8;
				}
				
				_moveStart = parent.globalToLocal(new Point(event.stageX, event.stageY));
				
				_originalPosition = _objectPosition.clone();
				_originalBounds = _objectBounds.clone();
				
				event.stopImmediatePropagation();
				
				CoreManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onBoxMouseMove);
				CoreManager.stage.addEventListener(MouseEvent.MOUSE_UP, onBoxMouseUp);
				_editor.viewport.mouseEnabled = false;
				_editor.viewport.mouseChildren = false;
				Mouse.cursor = MouseCursor.HAND;
			}
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			if(_target)
			{
				redrawSpider();
			}
		}

		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			_target = value;
			resetBox();
		}

		private function resetBox():void
		{
			if(_target)
			{
				visible = true;
				
				readTargetTransform();
				redrawBounds();
			}
			else
			{
				visible = false;
			}
		}

		
		private function resizeBoundsWithPoint(index:int, dx:Number, dy:Number):void
		{
			switch(index)
			{
				case 0:
					_objectPosition.x = _originalPosition.x + dx;
					_objectBounds.width = _originalBounds.width - dx;
					_objectPosition.y = _originalPosition.y + dy;
					_objectBounds.height = _originalBounds.height - dy;
					break;
				case 1:
					_objectPosition.y = _originalPosition.y + dy;
					_objectBounds.height = _originalBounds.height - dy;
					break;
				case 7:
					_objectPosition.x = _originalPosition.x + dx;
					_objectBounds.width = _originalBounds.width - dx;
					break;
				case 6:
					_objectPosition.x = _originalPosition.x + dx;
					_objectBounds.width = _originalBounds.width - dx;
					_objectBounds.height = _originalBounds.height + dy;
					break;
				case 5:
					_objectBounds.height = _originalBounds.height + dy;
					break;
				case 4:
					_objectBounds.width = _originalBounds.width + dx;
					_objectBounds.height = _originalBounds.height + dy;
					break;
				case 3:
					_objectBounds.width = _originalBounds.width + dx;
					break;
				case 2:
					_objectPosition.y = _originalPosition.y + dy;
					_objectBounds.height = _originalBounds.height - dy;
					_objectBounds.width = _originalBounds.width + dx;
					break;
			}
		}
		
		private function redrawBounds():void
		{
			var rc:Rectangle = _objectBounds;
			var g:Graphics = _boxBounds.graphics;
			
			_boxPoints[0].x = rc.x;
			_boxPoints[0].y = rc.y;
			_boxPoints[1].x = rc.x + rc.width*0.5;
			_boxPoints[1].y = rc.y;
			_boxPoints[2].x = rc.x + rc.width;
			_boxPoints[2].y = rc.y;
			_boxPoints[3].x = rc.x + rc.width;
			_boxPoints[3].y = rc.y + rc.height*0.5;
			_boxPoints[4].x = rc.x + rc.width;
			_boxPoints[4].y = rc.y + rc.height;
			_boxPoints[5].x = rc.x + rc.width*0.5;
			_boxPoints[5].y = rc.y + rc.height;
			_boxPoints[6].x = rc.x;
			_boxPoints[6].y = rc.y + rc.height;
			_boxPoints[7].x = rc.x;
			_boxPoints[7].y = rc.y + rc.height * 0.5;
			
			x = _objectPosition.x;
			y = _objectPosition.y;
			
			g.clear();
			
			g.lineStyle(1, 0x0);
			g.beginFill(0xffffff, 0.5);
			g.drawRect(rc.x, rc.y, rc.width, rc.height);
			g.endFill();
			
			g.moveTo(rc.x, rc.y);
			g.lineTo(rc.x + rc.width, rc.y + rc.height);
			g.moveTo(rc.x + rc.width, rc.y);
			g.lineTo(rc.x, rc.y + rc.height);
			
			redrawSpider();
		}
		
		private function readTargetTransform():void
		{
			var actor:Actor = _target as Actor;
			
			if(_target)
			{
				if(actor)
				{
					_objectBounds = new Rectangle(0, 0, actor.width, actor.height);
					_objectPosition = new Point(actor.x, actor.y);
				}
			}
		}
		
		private function applyTargetTransform():void
		{
			var actor:Actor = _target as Actor;
			
			if(_target)
			{
				if(actor)
				{
					//_objectPosition.x += _objectBounds.x;
					//_objectPosition.y += _objectBounds.y;
					//_objectBounds.x = 0;
					//_objectBounds.y = 0;
					
					actor.x = _objectPosition.x;
					actor.y = _objectPosition.y;
					actor.width = _objectBounds.width;
					actor.height = _objectBounds.height;
				
					actor.updateTransform();
					
					redrawBounds();
				}
			}
			
		}
		
		private function redrawSpider():void
		{
			var sb:Rectangle = new Rectangle();
			var g:Graphics = _boxSpider.graphics;

			g.clear();
			
			if(_target)
			{
				sb.topLeft = globalToLocal(new Point(0, 0));
				sb.bottomRight = globalToLocal(new Point(CoreManager.displayWidth, CoreManager.displayHeight));
			
				g.lineStyle(2, 0x009900);
				g.moveTo(sb.left, sb.top);
				g.lineTo(_objectBounds.x, _objectBounds.y);
				g.moveTo(sb.right, sb.top);
				g.lineTo(_objectBounds.x + _objectBounds.width, _objectBounds.y);
				g.moveTo(sb.right, sb.bottom);
				g.lineTo(_objectBounds.x + _objectBounds.width, _objectBounds.y + _objectBounds.height);
				g.moveTo(sb.left, sb.bottom);
				g.lineTo(_objectBounds.x, _objectBounds.y + _objectBounds.height);
			}
		}
		
		public function onCopy(remove:Boolean):void
		{
			var xml:XML = XML("<object/>");
			var actor:Actor = _target as Actor;
			
			if(actor)
			{
				actor.saveProperties(xml);
				_memory = xml;
				
				if(remove)
				{
					target = null;
					actor.destroy();
				}
			}
		}
		
		public function onPaste():void
		{
			var actor:Actor;
			
			if(_memory)
			{
				actor = ActorFactory.load(_memory, _editor);
				if(actor)
				{
					_editor.scene.addActor(actor);
					_editor.createActorGizmo(actor);
					target = actor;
				}
			}
		}
		
		private function onDuplicate():void
		{
			onCopy(false);
			onPaste();
		}

		private function onRemove():void
		{
			var actor:Actor = _target as Actor;
			if(actor)
			{
				actor.destroy();
				target = null;
			}
		}
		
		private function onAlign():void
		{
			var actor:Actor = _target as Actor;
			if(actor)
			{
				_objectPosition.x = Editor.GRID_SIZE * int(_objectPosition.x / Editor.GRID_SIZE);
				_objectPosition.y = Editor.GRID_SIZE * int(_objectPosition.y / Editor.GRID_SIZE);
				applyTargetTransform();
			}
		}
	}
}
