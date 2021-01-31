package ui
{
	import ek.sui.SUIElement;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	public class DefaultButton implements SUIElement
	{
		public var x:Number;
		public var y:Number;
		public var rc:Rectangle;
		private var press:Number;
		private var mouseOn:Boolean;
		public var imgs:Array;
		public var callback:Function;
		public var enabled:Boolean;
		public var hold:Number;
		public var visible:Boolean;
		
		static public var sndClickHolder:Sound;
		static public var sndOnHolder:Sound;
		
		public var sndClick:Sound;
		public var sndOn:Sound;
		
		public function DefaultButton()
		{
			x = y = 0.0;
			mouseOn = false;
			press = 0.0;
			hold = 0.0;
			
			enabled = true;
			visible = true;
			
			sndClick = sndClickHolder;
			sndOn = sndOnHolder;
		}
		
		public function draw(canvas:BitmapData):void
		{
			var bm:BitmapData;
			if(imgs!=null && visible)
			{
				if(enabled)
				{
					if(press>0.0) bm = imgs[2];
					else bm = imgs[1];
				}
				else bm = imgs[3];
				
				if(hold>0.0)
					canvas.draw(imgs[0], new Matrix(1,0,0,1,x,y), new ColorTransform(1,1,1,hold));
					
				canvas.copyPixels(bm, new Rectangle(0, 0, bm.width, bm.height), new Point(x, y));
			}
		}
		
		public function update(dt:Number):void
		{
			if(enabled)
			{
				if(mouseOn)
				{	
					if(hold<1.0) {
						hold+=10.0*dt;
						if(hold>1.0)
							hold = 1.0;
					}
				}
				else
				{
					if(hold>0.0) {
						hold-=10.0*dt;
						if(hold<0.0)
							hold = 0.0;
					}
				}
				if(press>0.0)
				{
					press-=10.0*dt;
					if(press<0.0) press = 0.0;
				}
			}
			else
			{
				press = 0.0;
				
				if(hold>0.0) {
						hold-=10.0*dt;
						if(hold<0.0)
							hold = 0.0;
				}
			}
		}
		
		public function mouseMove(_x:Number, _y:Number):void
		{
			var last:Boolean = mouseOn;
			var dx:Number = _x - x;
			var dy:Number = _y - y;
			mouseOn = (dy>=rc.y && dy<rc.y+rc.height && dx>=rc.x && dx<rc.x+rc.width);
			
			if(enabled && !last && mouseOn && sndOn!=null)
				sndOn.play();
		}
		
		public function mouseUp():void
		{
		}
		
		public function mouseDown():void
		{
			if(mouseOn && enabled)
			{
				if(sndClick!=null)
					sndClick.play();
				if(callback!=null)
					callback();
				press = 1.0;
			}
		}
		
	}
}