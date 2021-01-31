package lev.gen
{
	
	public class PowerSetuper extends Setuper
	{
		public static const POWER1:Array = [0];
		public static const POWER2:Array = [1];
		public static const POWER3:Array = [2];
		public static const POWERS:Array = [0,1,2];
		
		public var ids:Array;
		public var probJump:Number;
		
		public function PowerSetuper(jump:Number, powerIDs:Array)
		{
			ids = powerIDs;
			probJump = jump;
		}
		
		override public function start(x:Number, y:Number, pill:Pill):Pill
		{
			var lenght:uint = ids.length;
			var id:int;
			if(lenght>0)
			{
				if(lenght>1) id = ids[int(Math.random()*lenght)];
				else id = ids[0];
			}
			else id = 0;

			pill.user = userCallback;
			pill.startPower(x, y, id, Math.random()<probJump);
					
			return pill;
		}

	}
}