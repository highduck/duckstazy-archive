package com.ek.duckstazy.game.prof
{
	/**
	 * @author eliasku
	 */
	public class ProfileManager
	{
		private static var _instance:ProfileManager;
		
		static public function get instance():ProfileManager
		{
			if(!_instance)
				_instance = new ProfileManager();
				
			return _instance;
		}
		
		private var _profiles:Array = [];
		
		public function ProfileManager()
		{
		
		}

		public function get profiles():Array
		{
			return _profiles;
		}
	}
}
