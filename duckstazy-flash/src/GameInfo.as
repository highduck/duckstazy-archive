package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GameInfo
	{
		
		private const ftSize:int = 50;
		private var ftPool:Array;
		private var ftCount:int;

		private var text:TextField;
		public var one:BitmapData;
		public var powers:Array;
		public var toxics:Array;
		public var sleeps:Array;
		public var damages:Array;
		
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		
		//public var state:GameState;
		 
		public function GameInfo()
		{
			var i:int;
			var bm:BitmapData;
			
			ftPool = new Array(ftSize);
			for( ; i<ftSize; ++i)
				ftPool[i] = new FloatText();
				
			ftCount = 0;
			
			text = new TextField();
 			text.defaultTextFormat = new TextFormat("_mini", 15, 0xffffffff);
 			text.embedFonts = true;
 			text.cacheAsBitmap = true;
 			text.autoSize = TextFieldAutoSize.LEFT;
 			
 			powers = new Array();
 			toxics = new Array();
 			sleeps = new Array();
 			damages = new Array();
 			
 			text.text = "+1";
 			one = new BitmapData(text.width, text.height, true, 0x00000000);
 			one.draw(text);
 			
 			text.text = "+5";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "+10";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "+25";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "+50";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "+100";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "+150";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			powers.push(bm);
 			
 			text.text = "FIRST BLOOD! +100";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			toxics.push(bm);
 			
 			text.text = "MANIACALISTIC! +150";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			toxics.push(bm);
 			
 			text.text = "SUPER RESISTANCE! +200";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			toxics.push(bm);
 			
 			text.text = "WAKE UP!";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			sleeps.push(bm);
 			
 			text.text = "LULLABY...";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			sleeps.push(bm);
 			
 			text.text = "FALLING ASLEEP..";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			sleeps.push(bm);
 			
 			text.text = "OOPS!";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			damages.push(bm);
 			
 			text.text = "REALLY HARD...";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			damages.push(bm);
 			
 			text.text = "BE CAREFUL!";
 			bm = new BitmapData(text.width, text.height, true, 0x00000000);
 			bm.draw(text);
 			damages.push(bm);
 		}
		
		public function reset():void
		{
			for each (var it:FloatText in ftPool)
			{
				it.t = 0.0;
				it.img = null;
			}
			ftCount = 0;
		}
		
		public function drawFT(canvas:BitmapData):void
		{
			var i:int = 0;
			var mat:Matrix = new Matrix();
			
			for each (var ft:FloatText in ftPool)
			{
				if(i==ftCount)
					break;
					
				if(ft.t>0.0)
				{
					mat.tx = ft.x;
					mat.ty = int(ft.y);

					canvas.draw(ft.img, mat, ft.color, null, null, false);
					++i;
				}
			}
		}
		
		public function add(x:Number, y:Number, bm:BitmapData):void
		{
			for each (var ft:FloatText in ftPool)
			{
				if(ft.t<=0.0)
				{
					ft.t = 1.0;
					ft.x = x - (bm.width>>1);
					ft.y = y - (bm.height>>1);
					ft.img = bm;
					
					++ftCount; 
					 
					break;
				}
			}
		}
		
		public function setRGB(color:uint):void
		{
			r = ((color >> 16) & 0xFF)*0.003921569;
			g = ((color >>  8) & 0xFF)*0.003921569;
			b =  (color        & 0xFF)*0.003921569;
		}
			
		private function ctCalc(color:ColorTransform, t:Number):void
		{
			var x:Number = 0.5*(1.0 + Math.sin(t*6.28*4.0));
			color.redMultiplier = r*x;
			color.greenMultiplier = g*x;
			color.blueMultiplier = b*x;
		}
		
		public function update(power:Number, dt:Number):void
		{
			var i:int = 0;
			var ft_proc:int = ftCount;
			var a:Number;
			
			for each (var ft:FloatText in ftPool)
			{
				if(i==ft_proc)
					break;
					
				if(ft.t>0.0)
				{
					ft.t -= dt;
					 
					if(ft.t<=0.0)
						--ftCount;
					else
					{
						ft.y -= 50.0*dt;
						a = 0.25;
						if(ft.t>0.75) a = 1.0 - ft.t;
						else if(ft.t<0.25) a = ft.t;
						a*=4.0;
						ctCalc(ft.color, ft.t);
						ft.color.alphaMultiplier = a;

					}
					
					++i;
				}
			}
		}

	}
}