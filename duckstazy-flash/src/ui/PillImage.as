package ui
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PillImage
	{
		public const HAPPY:int = 0;
		public const SHAKE:int = 1;
		public const SMILE:int = 2;
		
		// временный идентификатор
		public var id:int;

		private var emo:Boolean;
		private var emoType:int;
		private var emoCounter:Number;
		private var emoPause:Number;
		private var emoParam:Number;
	
		public var x:Number;
		public var y:Number;
		
		public var hx:Number;
		public var hy:Number;
		
		private var media:PillsMedia;
		
		private var imgMain:BitmapData;
		private var imgEmo:BitmapData;
		private var imgNid:BitmapData;
    
		// Инициализируемся
		public function PillImage(_x:Number, _y:Number, _id:int, _emo:Boolean, pillsMedia:PillsMedia)
		{
			media = pillsMedia;
			emo = _emo;
			id = _id;
			x = _x;
			y = _y;
			
			hx = hy = 0.0;
			
			switch(id)
			{
			case 0:
				imgMain = media.imgPower1;
				imgEmo = media.imgPPower1;
				break;
			case 1:
				imgMain = media.imgPower2;
				imgEmo = media.imgPPower2;
				break;
			case 2:
				imgMain = media.imgPower3;
				imgEmo = media.imgPPower3;
				break;
			}
			
			init();
		}
		
		// Сбрасываемся
		public function init():void
		{
			if(emo)
			{
				emoPause = Math.random()*3.0+2.0;
				emoCounter = 0.0;
			}
			else
			{
				imgNid = BitmapData(media.imgNids[int(Math.random()*4)]);
			}
		}

		// Стартуем анимацию эмоции
		private function startEmo(emotionType:int):void
		{
			switch(emotionType)
			{
			case HAPPY:
				emoParam = 1 + int(Math.random()*3.0);
				if(Math.random()<0.5)
					emoParam = -emoParam;
			case SHAKE:
			case SMILE:
				emoCounter = 3.0;
				break;
			}
			emoType = emotionType;
		}
		
		// Обновляемся
		public function update(dt:Number):void
		{
			if(emo)
			{
				if(emoCounter>0.0)
				{
					emoCounter -= dt;
					if(emoCounter<0.0)
					{
						emoCounter = 0.0;
						emoPause = Math.random()*3.0+2.0;
					}
				}
				else
				{
					emoPause-=dt;
					if(emoPause<=0.0)
						startEmo(int(Math.random()*3.0));
				}
			}
		}
		
		public function updateSpy(_x:Number, _y:Number):void
		{
			var dx:Number = _x - x;
			var dy:Number = _y - y;
			var i:Number = 1.0 / Math.sqrt(dx*dx + dy*dy);
			
			hx = dx*i;
			hy = dy*i; 
		}
		
		public function draw(canvas:BitmapData):void
		{
			var rc:Rectangle = new Rectangle(0, 0, 20, 20);
			var dest:Point = new Point(x-10, y-10);
			var data:BitmapData;
			var mat:Matrix;
						
			if(emo)
			{
				canvas.copyPixels(imgEmo, rc, dest);
					
				if(emoCounter>0.0)
				{
					switch(emoType)
					{
					case HAPPY:
						drawEmoHappy(canvas);
						break;
					case SHAKE:
						drawEmoShake(canvas);
						break;
					case SMILE:
						drawEmoSmile(canvas);
						break;
					}
				}
				else
					drawEmoDefaultA(canvas);
			}
			else
			{
				canvas.copyPixels(imgMain, rc, dest);
				canvas.copyPixels(imgNid, rc, dest);
			}
		}

		private function drawEmoDefaultA(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -4.0, 2.0);
			
			mat.translate(x, y);
			
			canvas.draw(media.imgSmile1, mat, null, null, null, true);
			
			mat.identity();
			mat.translate(-5.0, -3.0);
			mat.translate(x + hx, y + hy);
			
			canvas.draw(media.imgEyes1, mat, null, null, null, true);
		}
		
		private function drawEmoDefault(canvas:BitmapData, alpha:Number, angle:Number):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -4.0, 2.0);
			var col:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, alpha);
			
			mat.rotate(angle);
			mat.translate(x, y);
			
			canvas.draw(media.imgSmile1, mat, col, null, null, true);
			
			mat.identity();
			mat.translate(-5.0, -3.0);
			mat.rotate(angle);
			mat.translate(x + hx, y + hy);
			
			canvas.draw(media.imgEyes1, mat, col, null, null, true);
		}
		
		private function drawEmoHappy(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -6.0, 1.0);
			var col:ColorTransform;
			var a:Number = 0.5;
			var ang:Number = emoCounter/3.0;
							
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
						
			if(a<1.0)
				col = new ColorTransform(1.0, 1.0, 1.0, a);
		
			if(emoParam>0.0)
				ang = 1.0 - ang;
				
			ang*=Math.abs(emoParam)*6.28;
		
			if(col!=null)
				drawEmoDefault(canvas, 1.0 - a, ang);
			
			mat.rotate(ang);
			mat.translate(x, y);
			
			canvas.draw(media.imgSmile3, mat, col, null, null, true);
			
			mat.identity();
			mat.translate(-7.0, -5.0);
			mat.rotate(ang);
			mat.translate(x, y);
			
			canvas.draw(media.imgEyes2, mat, col, null, null, true);		
		}
		
		private function drawEmoShake(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -6.0, 1.0);
			var col:ColorTransform;
			var a:Number = 0.5;
			var off:Number = Math.sin(emoCounter*6.28);
					
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
			
			if(a<1.0)
				col = new ColorTransform(1.0, 1.0, 1.0, a);
		
			if(off<0.0)
				off = 0.0;
			else if(off>=0.0)
				off = 0.5;
		
			if(col!=null)
				drawEmoDefault(canvas, 1.0 - a, 0.0);
			
			mat.translate(x, y);
			
			canvas.draw(media.imgSmile3, mat, col, null, null, true);
			
			mat.identity();
			mat.translate(-7.0, -5.0);
			mat.translate(x, y + off);
			
			canvas.draw(media.imgEyes2, mat, col, null, null, true);
		}
		
		private function drawEmoSmile(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -8.0, 1.0);
			var col:ColorTransform;
			var a:Number = 0.5;
						
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
			
			if(a<1.0)
				col = new ColorTransform(1.0, 1.0, 1.0, a);
		
			if(col!=null)
				drawEmoDefault(canvas, 1.0 - a, 0.0);
			
			mat.translate(x, y);
			
			canvas.draw(media.imgSmile2, mat, col, null, null, true);
						
			mat.identity();
			mat.translate(-5.0, -3.0);
			mat.translate(x, y);
			
			canvas.draw(media.imgEyes1, mat, col, null, null, true);
		}


	}
}