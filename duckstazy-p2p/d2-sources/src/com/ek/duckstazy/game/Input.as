package com.ek.duckstazy.game
{
	import com.ek.library.core.CoreManager;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author eliasku
	 */
	public class Input 
	{
		private var _keysUp:Vector.<uint> = new Vector.<uint>();
		private var _keysDown:Vector.<uint> = new Vector.<uint>();
		private var _keys:Dictionary = new Dictionary();
		
		private var _lockMouse:Boolean;
		
		public function Input()
		{
			CoreManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			CoreManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			CoreManager.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
		}

		private function onDeactivate(event:Event):void
		{
			//_keysUp.length = 0;
			_keysDown.length = 0;

			for (var code:Object in _keys)
			{
				if(_keys[code] == true)
				{
					_keysUp.push(code);
					_keys[code] = false;
				}
			}
		}

		private function onMouseOut(event:MouseEvent):void
		{
			if(_lockMouse)
				event.stopImmediatePropagation();
		}

		private function onMouseOver(event:MouseEvent):void
		{
			if(_lockMouse)
				event.stopImmediatePropagation();
		}

		private function onMouseMove(event:MouseEvent):void
		{
			if(_lockMouse)
				event.stopImmediatePropagation();
		}
		
		public function resetKeys():void
		{
			_keysUp.length = 0;
			_keysDown.length = 0;
		}
		
		public function resetFocus():void
		{
			CoreManager.stage.focus = CoreManager.stage;
		}

		private function onKeyUp(event:KeyboardEvent):void 
		{
			var code:uint = event.keyCode;
			
			_keysUp.push(code);
			_keys[code] = false;
		}

		private function onKeyDown(event:KeyboardEvent):void 
		{
			var code:uint = event.keyCode;
			var repeated:Boolean = (_keys.hasOwnProperty(code) && _keys[code]==true);
			
			if(!repeated)
			{
				_keysDown.push(code);
				_keys[code] = true;	
			}
		}
		
		public function getKey(code:uint):Boolean
		{
			return (_keys.hasOwnProperty(code) && _keys[code] == true);
		}
		
		public function getKeyDown(code:uint):Boolean
		{
			return (_keysDown.indexOf(code) >= 0);
		}
		
		public function getKeyUp(code:uint):Boolean
		{
			return (_keysUp.indexOf(code) >= 0);
		}
	}
}