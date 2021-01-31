package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class Particle
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		
		public var a:Number;
		public var va:Number;
		
		public var t:Number;
		
		public var type:int;
		public var p1:Number;
		public var p2:Number;
		
		public var img:BitmapData;
		public var px:Number;
		public var py:Number;
		public var s:Number;
		
		public var alpha:Number;
		public var col:ColorTransform;
		

		public function Particle()
		{
			t = 0.0;
			col = new ColorTransform();
		}

		/*public function draw(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, px, py);
			
			if(a!=0.0)
				mat.rotate(a);
				
			mat.scale(s, s);
			mat.translate(x, y);

			canvas.draw(img, mat, col, null, null, true);
		}*/

	}
}