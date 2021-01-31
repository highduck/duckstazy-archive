package ek
{
	import flash.events.KeyboardEvent;
	
	public interface ekIListener
	{
		// Обновить кадр
		function frame(dt:Number):void;
		
		// Клавиатура
		function keyDown(event:KeyboardEvent):void;
		function keyUp(event:KeyboardEvent):void;
	}
}