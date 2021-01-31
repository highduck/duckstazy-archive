package ek.sui
{
	import flash.display.BitmapData;
	
	public class SUIScreen
	{
		private var elements:Array;
		
		public function SUIScreen()
		{
			elements = new Array();
		}
		
		public function add(element:SUIElement):void
		{
			elements.push(element);
		}
		
		public function draw(canvas:BitmapData):void
		{
			for each (var it:SUIElement in elements)
			{
				it.draw(canvas);
			}
		}
		
		public function update(dt:Number):void
		{
			for each (var it:SUIElement in elements)
			{
				it.update(dt);
			}
		}
		
		public function mouseDown():void
		{
			for each (var it:SUIElement in elements)
			{
				it.mouseDown();
			}
		}
				
		public function mouseUp():void
		{
			for each (var it:SUIElement in elements)
			{
				it.mouseUp();
			}
		}
		
		public function mouseMove(x:Number, y:Number):void
		{
		    for each (var it:SUIElement in elements)
			{
				it.mouseMove(x, y);
			}
		}

	}
}