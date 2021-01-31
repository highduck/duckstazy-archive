package
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class LevelProgress
	{
		[Embed(source="gfx/progress.png")]
        private var rPointImg:Class;
        
        public var imgPoint:BitmapData;
        
		// Координаты извивающейся полоски
		private var line1:Array;
		private var line2:Array;
		private var ld1:Array;
		private var ld2:Array;
		
		// Счётчик для извивающейся полоски
		private var line_c:Number;
				
		private var power:Number;
		
		private var shape:Shape;
		
		private var progress:Number;
		private var progressMax:Number;
		public var perc:Number;
		
		public var play:Boolean;
		
		public var full:Boolean;
		
		public var env:Env;
		
		public function LevelProgress()
		{
			// Инициализируем полоску
			ld1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
			ld2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
			line1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
			line2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
			line_c = 0.0;
			
			
			shape = new Shape();
			
			imgPoint = (new rPointImg()).bitmapData;
			
			end();
		}
		
		public function start(progressTime:Number):void
		{
			progress = 0.0;
			progressMax = progressTime;
			play = true;
			full = false;
		}
		
		public function end():void
		{
			perc = 0.0;
			progress = 0.0;
			progressMax = 0.0;
			play = false;
			full = false;
		}

		public function update(dt:Number, newPower:Number):void
		{
			// Временные переменные.
			var c:Number;
			var w:Number;
			var i:int;
			var t:Number;
			
			var o:*;
			
			// Обновляем состояние
			power = newPower;
			
			/*if(play)
			{
				if(!full)
				{
					progress+=power*dt;
					perc = progress/progressMax;
					if(progress>=progressMax)
					{
						progress = progressMax;
						perc = 1.0;
						full = true;
					}
					
				}
			}*/
		
			// Обновляем счётчик полоски.
			line_c+=dt*1.57*power*power;
			if(line_c>1.0) line_c-=int(line_c);
		
			// Ообновляем опорные точки полоски.
			for(i=0; i<7; ++i)
			{
				t = line_c*6.2832;
				c = 40.0 + 17.0 * Math.sin(t + 1.5708*(i-2));
				w = 12.5 + 2.5 * Math.sin(t + 3.1416*(i-2));
				line1[i] = c - w;
				line2[i] = c + w;
			}
			
			calcLines();
		}

		public function updateProgress(newProgress:Number):void
		{
			if(play)
			{
				if(!full)
				{
					progress = newProgress;
					perc = progress/progressMax;
					if(progress>=progressMax)
					{
						progress = progressMax;
						perc = 1.0;
						full = true;
					}
				}
			}
		}

		public function calcLines():void
		{
			// Временные переменные.
			var i:int = 0;
			var j:int = 0;
			
			var y11:Number;
			var y21:Number;
			var y31:Number;
			var y41:Number;
			var y12:Number;
			var y22:Number;
			var y32:Number;
			var y42:Number;
						
			var p:Number; 
			var q:Number; 
			var r:Number; 
			var s:Number;
		
			var t:Number;
			var t2:Number;
		
			while(i<5)
			{
				y11 = line1[i];
				y21 = line1[i+1];
				y31 = line1[i+2];
				y41 = line1[i+3];
				y12 = line2[i];
				y22 = line2[i+1];
				y32 = line2[i+2];
				y42 = line2[i+3];

				ld1[j] = y21; ld2[j] = y22;	++j;
				
				t = 0.2;
				while(t<1.0)
				{
					t2 = t*t;
					
					p = y41 - y31 - y11 + y21;
					q = y11 - y21 - p;
					r = y31 - y11;
					s = y21;
									
					ld1[j] = p*t2*t + q*t2 + r*t + s;
					
					p = y42 - y32 - y12 + y22; 
					q = y12 - y22 - p; 
					r = y32 - y12; 
					s = y22;
									
					ld2[j] = p*t2*t + q*t2 + r*t + s;
					
					//ld1[j] = spline(y11, y21, y31, y41, t);
					//ld2[j] = spline(y12, y22, y32, y42, t);
					
					++j;
					t+=0.2;
				}
				
				++i;
			}
			
			ld1[20] = line1[5];
			ld2[20] = line2[5];
		}
			
		public function draw(canvas:BitmapData):void
		{
			// Временные переменные.
			var x:Number;
			var i:int;
			var v:Number;
			var mat:Matrix = new Matrix();
			var pointY:Number;
			var pointEmpty:ColorTransform = env.ctProgress;
			var pointFilled:ColorTransform = new ColorTransform();
			var pointColor:ColorTransform = new ColorTransform();
			var prog:Number = progress/progressMax;
			var y:Number;
			
			mat.identity();
			mat.translate(0, 400);
				
			shape.graphics.clear();
			shape.graphics.beginFill(env.colProgress, 1.0);
			shape.graphics.moveTo(0, ld1[0]);
			
			x = 32.0;
			for(i=1; i<21; ++i)
			{
				shape.graphics.lineTo(x, ld1[i]);
				x+=32.0;
			}
			
			x = 640.0;
			for(i=20; i>=0; --i)
			{
				shape.graphics.lineTo(x, ld2[i]);
				x-=32.0;
			}
						
			shape.graphics.endFill();
			canvas.draw(shape, mat);
			
			if(play)
			{
				x = 22.0;
				for(i=1; i<20; ++i)
				{
					y = ld1[i];
					pointY = 390.0 + y + 0.5*(ld2[i] - y);
					
					mat.identity();
					mat.translate(x, pointY);
				
					if(prog>0.05263)
						pointColor = pointFilled;
					else if(prog<=0.0)
						pointColor = pointEmpty;
					else
					{
						v = prog*19.0;
						pointColor.redMultiplier = pointEmpty.redMultiplier*(1.0 - v) + v;
						pointColor.greenMultiplier = pointEmpty.greenMultiplier*(1.0 - v) + v;
						pointColor.blueMultiplier = pointEmpty.blueMultiplier*(1.0 - v) + v;
					}
					
					canvas.draw(imgPoint, mat, pointColor, null, null, true);
					
					x+=32.0;
					
					prog-=0.05263;
				}
			}
		}
		
	}
}