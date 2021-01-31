package com.ek.duckstazy.game
{
	/**
	 * @author eliasku
	 */
	public class Replay
	{
		public static const NONE:String = "none";
		public static const RECORD:String = "record";
		public static const PLAY:String = "play";
		
		private var _levelId:String;
		private var _seed:int;
		private var _stream:Array = new Array();
		private var _position:int;
		
		public function Replay()
		{
		}
		
		public function record(deltaTime:Number):void
		{
			_stream.push( new ReplayTick(_position, deltaTime) );
			_position = _stream.length - 1;
		}
		
		public function rewind():void
		{
			_position = 0;
		}
		
		public function nextTick():void
		{
			_position++;
		}
		
		public function get tick():ReplayTick
		{	
			return _stream[_position];
		}
		
		public function get playCompleted():Boolean
		{
			return _position >= _stream.length;
		}

		public function get seed():int
		{
			return _seed;
		}

		public function set seed(value:int):void
		{
			_seed = value;
		}

		public function get levelId():String
		{
			return _levelId;
		}

		public function set levelId(value:String):void
		{
			_levelId = value;
		}
	}
}
