package ek.sui
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SUIImage implements SUIElement
	{
		public var img:BitmapData;
		public var x:Number;
		public var y:Number;
		
		public function SUIImage()
		{
			img = null;
			x = 0.0;
			y = 0.0;
		}
		
		public function setEmbedImage(asset:Class):void
		{
			img = (new asset()).bitmapData;
		}
		
		public function draw(canvas:BitmapData):void
		{
			if(img!=null)
				canvas.copyPixels(img, new Rectangle(0.0, 0.0, img.width, img.height), new Point(x, y));
		}
	
		public function update(dt:Number):void {}
		
		public function mouseMove(_x:Number, _y:Number):void {}
		
		public function mouseUp():void {}
		
		public function mouseDown():void {}
	}
}