package lev.gen
{
	public class JumpStarter extends Setuper
	{
		public function JumpStarter() { }

		override public function start(x:Number, y:Number, pill:Pill):Pill
		{
			pill.user = userCallback;
			pill.startJump(x, y);
			return pill;
		}
		
	}
}