package
{
	
	import flash.geom.ColorTransform;
	
	public class EnvStar
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		public var t:Number;
		public var a:Number;
		public var color:ColorTransform;
		
		public function EnvStar()
		{
			color = new ColorTransform();
			x = 640.0*Math.random();
			y = 400.0*Math.random();
			a = Math.random()*6.28;
			vx = 400.0*Math.cos(a);
			vy = 400.0*Math.sin(a);
			t = Math.random();
		}
		
		public function update(dt:Number, power:Number):void
		{
			var delta:Number = dt*power;

			x += vx*delta;
			y += vy*delta;

			if(x<-7.0) x += 654.0;
			else if(x>647.0) x-=654.0;

			if(y<-7.0) y += 414.0;
			else if(y>407.0) y-=414.0;

			t += 5.0*power*dt;
			if(t>=1.0) t -= int(t);
			
			delta = 1.0-y/400.0;
			color.alphaMultiplier = Math.sqrt(delta);//*(0.5-power)*2.0;
		}
	};

}