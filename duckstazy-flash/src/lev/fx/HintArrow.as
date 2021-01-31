package lev.fx
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class HintArrow
	{
		private var img:BitmapData;
		public var x:Number;
		public var y:Number;
		public var angle:Number;
		public var color:ColorTransform;
		private var t:Number;
		public var visible:Boolean;
		public var visibleCounter:Number;
		
		public function HintArrow(stageMedia:StageMedia)
		{
			img = stageMedia.imgHintArrow;
			color = new ColorTransform();
			t = 0.0;
		}
		
		public function place(_x:Number, _y:Number, _angle:Number, _color:uint, _visible:Boolean):void
		{
			t = 0.0;
			x = _x;
			y = _y;
			angle = _angle;
			utils.ctSetRGB(color, _color);
		
			visible = _visible;
			if(_visible) visibleCounter = 1.0;
			else visibleCounter = 0.0;
		}

		public function draw(canvas:BitmapData):void
		{
			var f:Number = Math.sin(t*6.28);
			var r:Number;
			var sy:Number;
			var sx:Number;
			var mat:Matrix;
		
			if(visibleCounter>0.0)
			{
				if(f<0)
				{
					r = 0.0;
					sy = 0.6 + (f+1)*0.4;
					sx = 1.0 - f*0.25;
				}
				else
				{
					r = f*15;
					sy = sx = 1.0;
				}
				
				mat = new Matrix(1,0,0,1, -28, -63-r);
				mat.scale(sx, sy);
				mat.rotate(angle);
				mat.translate(x, y);
				
				color.alphaMultiplier = visibleCounter;
				
				canvas.draw(img, mat, color, null, null, true);
			}
		}
		
		public function update(dt:Number):void
		{
			t+=dt;
			if(t>1.0) t-=int(t);
			
			if(visible)
			{
				if(visibleCounter<1.0)
				{
					visibleCounter+=dt;
					if(visibleCounter>1.0) visibleCounter = 1.0;
				}
			}
			else
			{
				if(visibleCounter>0.0)
				{
					visibleCounter-=dt;
					if(visibleCounter<0.0) visibleCounter = 0.0;
				}
			}
		}
	}

}