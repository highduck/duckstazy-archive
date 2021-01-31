package com.ek.library.debug
{
	import com.ek.library.ui.minimal.UIMinimalSet;
	import flash.text.TextField;

	internal class ConsoleInfo
	{
		private var _console:Console;
		private var _tf:TextField;
		private var _shown:Boolean;
		
		public function ConsoleInfo(console:Console)
		{
			_tf = UIMinimalSet.createLabel(0, 0, "", 0x77FF77, console, "info");
			_tf.multiline = true;
			_tf.x = Console.INDENT;
			_tf.y = Console.INDENT;
			_tf.filters = [UIMinimalSet.getStroke()];
			_tf.mouseEnabled = false;
			_tf.visible = false;
			_tf.mouseEnabled = false;
			
			_console = console;
		}
		
		public function set text(value:String):void
		{
			_tf.text = value;
		}
		
		public function get text():String
		{
			return _tf.text;
		}
		
		public function show():void
		{
			if(!_shown)
			{
				_shown = true;
				_tf.visible = true;
			}
		}
		
		public function hide():void
		{
			if(_shown)
			{
				_shown = false;
				_tf.visible = false;
			}
		}
		
		public function get shown():Boolean
		{
			return _shown;
		}
		
	}
}
