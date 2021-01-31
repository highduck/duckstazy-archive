package
{
	import flash.geom.ColorTransform;
	
	public class EnvCloud
	{
		public var x:Number;
		public var y:Number;
		public var counter:Number;
		public var id:int;
		//public var color:ColorTransform;
		
		public function EnvCloud()
		{
			//color = new ColorTransform();
		}
		
		public function init(_x:Number):void
		{
			x = _x;
			y = utils.rnd_float(40, 90);
			id = utils.rnd_int(0, 2);
			counter = Math.random();
		}
		
		public function update(dt:Number, power:Number):void
		{
			x -= (0.75 + 0.25*Math.sin(counter*6.2832))*(30.0+power*200.0)*dt;
			if(x<=-50.0)
			{
				x += 740;
				y = 40.0 + Math.random()*90.0;
				id = int(Math.random()*3.0);
			}
			counter += (0.1 + 0.9*power)*dt;
			if(counter>=1.0)
				counter -= int(counter);
			
			//color.alphaMultiplier = (0.5-power)*2.0;
		}
	};
}