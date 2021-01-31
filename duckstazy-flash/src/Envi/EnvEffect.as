package Envi
{
	import flash.display.BitmapData;
	
	public class EnvEffect
	{
		
		public var power:Number;
		public var c1:uint;
		public var c2:uint;
		public var peak:Number;
		
		public function EnvEffect()
		{
			power = 0.0;
			c1 = 0x000000;
			c2 = 0x000000;
			peak = 0.0;
		}
		
		public function update(dt:Number):void
		{
		}

		public function draw(canvas:BitmapData):void
		{
		}

	}
}