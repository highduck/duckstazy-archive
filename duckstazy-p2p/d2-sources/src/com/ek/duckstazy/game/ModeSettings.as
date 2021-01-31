package com.ek.duckstazy.game
{
	public class ModeSettings
	{
		public var frags:int;
		public var randomBonus:Boolean;
		public var rounds:int;
		public var timeout:Number = 0.0;
		public var type:String = ModeType.VERSUS_ESCAPING;

		public function reset():void
		{
			type = ModeType.VERSUS_ESCAPING;
			timeout = 0.0;
			rounds = 1;
			randomBonus = false;
			frags = 0;
		}
	}
}
