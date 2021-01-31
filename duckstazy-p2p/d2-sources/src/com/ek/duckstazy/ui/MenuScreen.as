package com.ek.duckstazy.ui
{
	import com.ek.library.core.CoreKeyboardEvent;
	import com.ek.library.gocs.GameObject;

	import flash.ui.Keyboard;

	public class MenuScreen extends GameObject
	{
		private var _id:String;
		
		private var _escapeCallback:Function;
		private var _acceptCallback:Function;
				
		public function MenuScreen(id:String)
		{
			_id = id;
		}

		public function get id():String
		{
			return _id;
		}
		
		public function onKeyDown(e:CoreKeyboardEvent):void
		{
			switch(e.code)
			{
				case Keyboard.ENTER:
				case Keyboard.SPACE:
					onKeyboardAccept(e);
					break;
				case Keyboard.ESCAPE:
					onKeyboardEscape(e);
					break;
			}
		}
		
		public function onKeyboardEscape(e:CoreKeyboardEvent):void
		{
			if(_escapeCallback != null)
			{
				_escapeCallback(e);
			}
		}
		
		public function onKeyboardAccept(e:CoreKeyboardEvent):void
		{
			if(_acceptCallback != null)
			{
				_acceptCallback(e);
			}
		}
		
		public function onOpen():void
		{
			
		}
		
		public function onClose():void
		{
		}

		public function get escapeCallback():Function
		{
			return _escapeCallback;
		}

		public function set escapeCallback(value:Function):void
		{
			_escapeCallback = value;
		}

		public function get acceptCallback():Function
		{
			return _acceptCallback;
		}

		public function set acceptCallback(value:Function):void
		{
			_acceptCallback = value;
		}
	}
}
