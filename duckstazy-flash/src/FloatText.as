package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	public class FloatText
	{

		public var img:BitmapData;
		public var x:Number;
		public var y:Number;
		public var t:Number;
		public var color:ColorTransform;
		
		public function FloatText()
		{
			t = 0.0;
			color = new ColorTransform();
		}

	}
}