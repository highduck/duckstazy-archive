package com.ek.duckstazy.game.prof
{
	/**
	 * @author eliasku
	 */
	public class Profile
	{
		private var _name:String = "unknown";
		private var _type:String;
		//private var _controls:Object;
		
		public function Profile()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}
