package lev.gen
{
	public class PartySetuper extends Setuper
	{
		public var powers:Number;
		public var sleeps:Number;
		public var toxics:Number;
		
		public var dangerH:Number;
		
		public var jump:Number;
		
		public function PartySetuper()
		{
			powers = 0.8;
			sleeps = 0.9;
			toxics = 1.0;
			
			dangerH = 200.0; 
			
			jump = 0.0;
		}
		
		override public function start(x:Number, y:Number, pill:Pill):Pill
		{
			var t:Number = Math.random();
			pill.user = userCallback;
			
			if(t<powers || y>dangerH)
				pill.startPower(x, y, int(Math.random()*3), Math.random()<jump);
			else if(t<sleeps)
				pill.startSleep(x, y);
			else
				pill.startToxic(x, y, int(Math.random()*2));
				
			return pill;
		}
		
	}
}