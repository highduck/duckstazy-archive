package Envi
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public class EnvEffect2 extends EnvEffect
	{
		private var t:Number;
		private var shape:Shape;
		
		public function EnvEffect2()
		{
			super();
			
			shape = new Shape();
			t = 0.0;
		}
		
		public override function update(dt:Number):void
		{
			t+=dt*6.28*(power-0.5);
			if(t>6.28)
				t-=6.28;
		}

		public override function draw(canvas:BitmapData):void
		{
			// Временные переменные.
			var x:Number;
			var y:Number;
			var r:Number;
			var gr:Graphics = shape.graphics;
			
			gr.clear();
			gr.lineStyle();
			gr.beginFill(c2);
			gr.drawRect(0.0, 0.0, 640.0, 400.0);
			gr.endFill();
			
			x = 40.0;
			y = 40.0;
			r = 22.5+12.5*Math.sin(t);
			while(x<640.0)
			{
				while(y<400.0)
				{
					gr.beginFill(c1);
					gr.drawCircle(x, y, r);
					gr.endFill();
					y+=80.0;
				}
				y = 40.0;
				x+=80.0;
			}
			
			x = 80.0;
			y = 80.0;
			r = 22.5-12.5*Math.sin(t);
			while(x<640.0)
			{
				while(y<400.0)
				{
					gr.beginFill(c1);
					gr.drawCircle(x, y, r);
					gr.endFill();
					y+=80.0;
				}
				y = 80.0;
				x+=80.0;
			}
			
			canvas.draw(shape);
		}
		
		// БЛЮР
		/*private var shape:Shape;
		
		public function EnvEffect2()
		{
			super();
			
			shape = new Shape();
		}
		
		public override function draw(canvas:BitmapData):void
		{
			// Временные переменные.
			var gr:Graphics = shape.graphics;

			gr.clear();
			gr.beginFill(c1, 1.8*(1.0-power)+0.1);
			gr.drawRect(0.0, 0.0, 640.0, 400.0);
			gr.endFill();

			canvas.draw(shape);
		}*/
		
	}
}