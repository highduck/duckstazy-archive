package ek.sui
{
	import flash.display.BitmapData;
	
	public interface SUIElement
	{
	
		function draw(canvas:BitmapData):void;
		
		function update(dt:Number):void;
		
		function mouseMove(_x:Number, _y:Number):void;
		
		function mouseUp():void;
		
		function mouseDown():void;
	}
}