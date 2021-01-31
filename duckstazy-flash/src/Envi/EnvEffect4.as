package Envi
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.BitmapData;
	
	public class EnvEffect4 extends EnvEffect
	{
		private var t:Number;
		private var shape:Shape;
		
		public function EnvEffect4()
		{
			super();
			
			shape = new Shape();
			t = 0.0;
		}
		
		public override function update(dt:Number):void
		{
			t+=dt*1.256*(power-0.5);
			if(t>6.28)
				t-=6.28;
		}

		public override function draw(canvas:BitmapData):void
		{
			// Временные переменные.
			var c:Number = 0.0;
			var a:Number = t;
			var a2:Number = t+0.314;
			var gr:Graphics = shape.graphics;
			
			gr.clear();
			gr.lineStyle();
			gr.beginFill(c2);
			gr.drawRect(0.0, 0.0, 640.0, 400.0);
			gr.endFill();
			
			while(c<6.28)
			{
				gr.beginFill(c1);
				gr.moveTo(320.0 + 512.0*Math.cos(a), 200.0 + 512.0*Math.sin(a));
				gr.lineTo(320.0, 200.0);
				gr.lineTo(320.0 + 512.0*Math.cos(a2), 200.0 + 512.0*Math.sin(a2));
				gr.endFill();
				
				a+=0.628;
				a2+=0.628;
				c+=0.628;
			}
			
			gr.beginFill(c1);
			gr.drawCircle(320.0, 200.0, peak*25.0);
			gr.endFill();
			
			canvas.draw(shape);
		}
		
	}
}