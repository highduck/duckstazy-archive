package lev.gen
{
	public class Placer
	{
		public var x:Number;
		public var y:Number;
		
		public var setuper:Setuper;
		
		public function Placer(_setuper:Setuper, _x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			setuper = _setuper;
		}
		
		public function place(pill:Pill):Pill
		{
			return setuper.start(x, y, pill);
		}
		
		public function placeAvoidHero(pill:Pill, distSqr:Number = 0):Pill
		{
			var pills:Pills = Pills.instance;
			var p:Pill;
			
			if(distSqr<=0 || !pills.tooCloseHero(x, y, distSqr))
				p = setuper.start(x, y, pill);
			
			return p;
		}
	}
}