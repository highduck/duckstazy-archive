package ek.sui
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class SUISystem
	{
		public var overlay:SUIScreen;
		public var current:SUIScreen;
		
		public var mx:Number;
		public var my:Number;
		
		public function SUISystem()
		{
			mx = my = 0.0;
		}
		
		public function listen(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		public function clear():void
		{
		}
		
		public function setCurrent(screen:SUIScreen):void
		{
			current = screen;
			current.mouseMove(mx, my);
		}
		
		public function draw(canvas:BitmapData):void
		{
			if(current!=null) current.draw(canvas);
			if(overlay!=null) overlay.draw(canvas);
		}
		
		public function update(dt:Number):void
		{
			if(current!=null) current.update(dt);
			if(overlay!=null) overlay.update(dt);
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			if(current!=null) current.mouseDown();
			if(overlay!=null) overlay.mouseDown();
		}
				
		public function mouseUp(event:MouseEvent):void
		{
			if(current!=null) current.mouseUp();
			if(overlay!=null) overlay.mouseUp();
		}
		
		public function mouseMove(event:MouseEvent):void
		{
			mx = event.localX;
			my = event.localY;
		    if(current!=null) current.mouseMove(mx, my);
			if(overlay!=null) overlay.mouseMove(mx, my);
		}

	}
}