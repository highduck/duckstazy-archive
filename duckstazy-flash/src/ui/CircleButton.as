package ui
{
	import ek.sui.SUIElement;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.Sound;

	public class CircleButton implements SUIElement
	{
		private const COLOR:ColorTransform = new ColorTransform();
		private const MATRIX:Matrix = new Matrix();
		public var x:Number;
		public var y:Number;
		private var angle:Number;
		public var radius:Number;
		public var shape:Shape;
		public var hold:Number;
		public var holdMin:Number;
		private var mouseOn:Boolean;
		public var img:BitmapData;
		public var callback:Function;
		public var enabled:Boolean;
		public var bgColor:uint;
		public var linesColor:uint;
		
		static public var sndClickHolder:Sound;
		static public var sndOnHolder:Sound;
		
		public var sndClick:Sound;
		public var sndOn:Sound;
		
		public function CircleButton()
		{
			shape = new Shape();
			
			angle = 0.0;
			x = y = 0.0;
			radius = 40.0;
			mouseOn = false;
			holdMin = 0;
			hold = 0.0;
			
			enabled = true;
			
			sndClick = sndClickHolder;
			sndOn = sndOnHolder;
			
			bgColor = 0xd5f2ff;
			linesColor = 0x99ccff;
		}
		
		public function setImage(asset:Class):void
		{
			img = (new asset()).bitmapData;
		}

		public function draw(canvas:BitmapData):void
		{
			var gr:Graphics = shape.graphics;
			var c:Number = 6.28;
			var a:Number = angle;
			var a2:Number = angle+0.314;
			var r:Number = radius*(1.0+hold*0.2);
			var bg:uint = bgColor;
			var lines:uint = linesColor;
			
			if(!enabled)
			{
				bg = 0xeaeaea;
				lines = 0xcccccc;
			}
			
			gr.clear();
			gr.beginFill(bg);
			gr.drawCircle(x, y, r);
			gr.endFill();
			
			while(c>0)
			{
				gr.beginFill(lines);
				gr.moveTo(x + r*Math.cos(a), y + r*Math.sin(a));
				gr.lineTo(x, y);
				gr.lineTo(x + r*Math.cos(a2), y + r*Math.sin(a2));
				gr.endFill();
				
				a+=0.628;
				a2+=0.628;
				c-=0.628;
			}
			
			gr.beginFill(bg);
			gr.drawCircle(x, y, 0.60*r);
			gr.endFill();
			
			gr.beginFill(utils.multColorScalar(0xffffff, hold));
			gr.drawCircle(x, y, r);
			gr.drawCircle(x, y, 0.95*r);
			gr.endFill();
			
			canvas.draw(shape);
			
			if(img!=null)
			{
				MATRIX.tx = x-(img.width>>1);
				MATRIX.ty = y-(img.height>>1);
				utils.ARGB2ColorTransform(utils.lerpColor(lines, 0xffffff, hold+Math.sin(angle*100)*(1-hold)*0.1), COLOR);
				COLOR.alphaMultiplier = 1;
				
				canvas.draw(img, MATRIX, COLOR);
				//canvas.copyPixels(img, new Rectangle(0, 0, img.width, img.height), new Point(x-(img.width>>1), y-(img.height>>1)));
			}
		}
		
		public function update(dt:Number):void
		{
			if(enabled)
			{
				if(mouseOn && hold<1.0)
				{
					hold+=10.0*dt;
					if(hold>1.0) hold = 1.0;
				}
				else if(!mouseOn && hold>holdMin)
				{
					hold-=10.0*dt;
					if(hold<holdMin) hold = holdMin;
				}
				angle += (hold*2.0+1.0)*dt;
				if(angle>6.28)
					angle-=6.28;
			}
			else
			{
				if(hold>holdMin)
				{
					hold-=10.0*dt;
					if(hold<holdMin) hold = holdMin;
				}
			}
		}
		
		public function mouseMove(_x:Number, _y:Number):void
		{
			var last:Boolean = mouseOn;
			var dx:Number = _x-x;
			var dy:Number = _y-y;
			mouseOn = (dx*dx + dy*dy < radius*radius);
			if(enabled && !last && mouseOn && sndOn!=null)
				sndOn.play();
		}
		
		public function mouseUp():void
		{
		}
		
		public function mouseDown():void
		{
			if(mouseOn && callback!=null && enabled)
			{
				if(sndClick!=null)
					sndClick.play();
				callback();
			}
		}
		
	}
}