package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.utils.XMath;

	import flash.geom.Point;
	import flash.geom.Rectangle;




	/**
	 * @author eliasku
	 */
	public class CameraController
	{
		public static const LOOK_FORWARD:Point = new Point(1.0, 1.0);
		public static const LOOK_FORWARD_MAX:Point = new Point(100.0, 100.0);
		public static const MOVE_SPEED:Number = 3.0;
		
		// cached components
		private var _level:Level;
		private var _camera:Camera;
		private var _shaker:CameraShaker;
		
		private var _position:Point = new Point();
		private var _currentOffset:Point = new Point();
		private var _targetOffset:Point = new Point();
		//private var _targetPosition:Point = new Point();
		
		private var _zoom:Number = 1.0;
		
		private var _bounds:Rectangle;
		
		private var _targets:Vector.<Actor> = new Vector.<Actor>();

		public function CameraController(level:Level)
		{
			_level = level;
			_camera = level.camera;
			_shaker = level.cameraShaker;
		}
		
		public function setBounds(x:Number, y:Number, width:Number, height:Number):void
		{
			_bounds = new Rectangle(x, y, width, height);
		}
		
		public function set bounds(value:Rectangle):void
		{
			if(value)
				_bounds = value.clone();
			else
				_bounds = null;
		}
		
		public function addTarget(target:Actor):void
		{
			var c:Point = targetsCenter;
			_targetOffset.x += c.x;
			_targetOffset.y += c.y;
			_currentOffset.x += c.x;
			_currentOffset.y += c.y;
			
			_targets.push(target);
			
			c = targetsCenter;
			_targetOffset.x -= c.x;
			_targetOffset.y -= c.y;
			_currentOffset.x -= c.x;
			_currentOffset.y -= c.y;
		}
		
		public function clearTargets():void
		{
			var c:Point = targetsCenter;
			
			_targetOffset.x += c.x;
			_targetOffset.y += c.y;
			_currentOffset.x += c.x;
			_currentOffset.y += c.y;
			
			_targets.length = 0;
		}
		
		public function setFocus(x:Number, y:Number):void
		{
			_targetOffset.x = _currentOffset.x = x;
			_targetOffset.y = _currentOffset.y = y;
		}
		
		public function moveFocus(x:Number, y:Number):void
		{
			_targetOffset.x = x;
			_targetOffset.y = y;
		}
		
		private function limitBounds(point:Point):void
		{
			if(_bounds)
			{
				if(_bounds.width >= _camera.sizeX)
				{
					if(point.x < _bounds.x) 
						point.x = _bounds.x;
					else if(point.x + _camera.sizeX > _bounds.x + _bounds.width) 
						point.x = _bounds.x + _bounds.width - _camera.sizeX;
				}
				else
				{
					//point.x = _bounds.x-(_camera.sizeX - _bounds.width)*0.5;
				}
				
				if(_bounds.height >= _camera.sizeY)
				{
					if(point.y < _bounds.y) 
						point.y = _bounds.y;
					else if(point.y + _camera.sizeY > _bounds.y + _bounds.height)
						point.y = _bounds.y + _bounds.height - _camera.sizeY;
				}
				else
				{
					//point.y = _bounds.y-(_camera.sizeY - _bounds.height)*0.5;
				}
				
			}
		}
		/*
		public function move(target:GameObject, offsetX:Number, offsetY:Number):void
		{
			_target = target;
			
			_offsetBegin.x = offsetX - 0.5 * _sizeX;
			_offsetBegin.y = offsetY - 0.5 * _sizeY;
			
			if(_target)
			{
				_targetPosition.x += _target.x;
				_targetPosition.y += _target.y;
			}
			
			boundsLimit(_targetPosition);
		}*/
		
		public function update(dt:Number):void
		{
			
						
			// Наведение фокуса камеры
			var focusX:Number = 0.0;
			var focusY:Number = 0.0;
			var c:Point;
			
			if(_targets.length > 0)
			{
				c = targetsVelocity;

				focusX = LOOK_FORWARD.x * c.x;
				focusY = LOOK_FORWARD.y * c.y;
				var mx:Number = LOOK_FORWARD_MAX.x / Number(_targets.length);
				var my:Number = LOOK_FORWARD_MAX.y / Number(_targets.length);
				
				if(focusX>mx) focusX = mx;
				else if(focusX<-mx) focusX = -mx;
				if(focusY>my) focusY = my;
				else if(focusY<-my) focusY = -my;
				
				_targetOffset.x = focusX;
				_targetOffset.y = focusY;
			}

			// Наводим камеру на новое место
			const t:Number = MOVE_SPEED*dt;
			_currentOffset.x = XMath.lerp(_currentOffset.x, _targetOffset.x, t);
			_currentOffset.y = XMath.lerp(_currentOffset.y, _targetOffset.y, t);
			
			//_zoom = XMath.lerp(_zoom, calculateZoom(), t);
			
			// Если камера навелась на фокус - фиксируем положение
			if(Math.abs(_targetOffset.x - _currentOffset.x) < 0.25)
				_currentOffset.x = _targetOffset.x;
			if(Math.abs(_targetOffset.y - _currentOffset.y) < 0.25)
				_currentOffset.y = _targetOffset.y;
			
			var oldX:Number = _position.x;
			var oldY:Number = _position.y;
			_position.x = _currentOffset.x - 0.5 * _camera.sizeX;
			_position.y = _currentOffset.y - 0.5 * _camera.sizeY;
						
			if(_targets.length > 0)
			{
				c = targetsCenter;
				_position.x += c.x;
				_position.y += c.y;
			}
			
			_position.x = XMath.lerp(oldX, _position.x, 3.0*dt);
			_position.y = XMath.lerp(oldY, _position.y, 3.0*dt);
					
			limitBounds(_position);
			
			_shaker.update();
			
			_camera.x = _position.x + _shaker.x;
			_camera.y = _position.y + _shaker.y;
			_camera.scale = _zoom;
		}
		
		public function get x():Number
		{
			return -_position.x;
		}
		
		public function get y():Number
		{
			return -_position.y;
		}
		
		public function get targetsCenter():Point
		{
			var p:Point = new Point();
			var count:Number = 0.0;
			var actor:Actor;
			
			for each (actor in _targets)
			{
				p.x += actor.x;
				p.y += actor.y;
				count += 1.0;
			}
			
			if(count > 0.0)
			{
				p.x /= count;
				p.y /= count;
			}
			
			return p;
		}
		
		public function calculateZoom():Number
		{
			var zoom:Number = 1.0;
			var target1:Actor;
			var target2:Actor;
			var distance:Number = 0.0;
			var dx:Number;
			var dy:Number;
			var w:Number = _camera.sizeX;
			var h:Number = _camera.sizeY;
			var diag:Number = 0.5*Math.sqrt(w*w+h*h);
			
			for each (target1 in _targets)
			{
				for each(target2 in _targets)
				{
					if(target1 == target2) continue;
					dx = target1.x - target2.x;
					dy = target1.y - target2.y;
					distance = Math.max( Math.sqrt(dx*dx + dy*dy), distance);
				}
			}
			
			if(distance > diag)
			{
				zoom = diag / distance;
			}
			
			return zoom;
		}
		
		public function get targetsVelocity():Point
		{
			var p:Point = new Point();
			var actor:Actor;
			var count:Number = 0.0;
			
			
			for each (actor in _targets)
			{
				if(!actor.dead)
				{
					p.x += actor.vx;
					p.y += actor.vy;
					count += 1.0;
				}
			}
				
			if(count > 0.0)
			{
				p.x /= count;
				p.y /= count;
			}
			
			return p;
		}
		
		public function get currentOffset():Point
		{
			return _currentOffset;
		}

		public function get bounds():Rectangle
		{
			return _bounds;
		}

		public function setPosition(x:Number, y:Number):void
		{
			_position.x = int(x);
			_position.y = int(y);
			
			_targetOffset.x = _currentOffset.x = int(x) + _camera.sizeX*0.5;
			_targetOffset.y = _currentOffset.y = int(y) + _camera.sizeY*0.5;
			
			limitBounds(_position);
		}
	}
}
