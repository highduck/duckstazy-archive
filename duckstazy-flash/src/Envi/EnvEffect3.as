package Envi
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class EnvEffect3 extends EnvEffect
	{
		private var t:Number;
		private var shape:Shape;
		
		public function EnvEffect3()
		{
			super();
			
			shape = new Shape();
			t = 0.0;
		}
		
		public override function update(dt:Number):void
		{
			t+=dt*200.0*(power-0.5);
			if(t>100.0)
				t-=100.0;
		}

		public override function draw(canvas:BitmapData):void
		{
			// Временные переменные.
			var x:Number;
			var c:Boolean = false;
			var gr:Graphics = shape.graphics;
			
			gr.clear();
			gr.lineStyle();
			gr.beginFill(c1);
			gr.drawRect(0.0, 0.0, 640.0, 400.0);
			gr.endFill();
			
			x = 512.0-t;
			while(x>0.0)
			{
				gr.beginFill(c2);
				gr.drawCircle(320.0, 200.0, x);
				if(x>50.0) gr.drawCircle(320.0, 200.0, x-50.0);
				gr.endFill();
				
				x-=100.0;
			}
			
			canvas.draw(shape);
		}
		
	}
}