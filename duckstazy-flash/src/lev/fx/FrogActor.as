package lev.fx
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class FrogActor
	{
		protected var media:StageMedia;
		
		// координаты относительно LT картинки тела
		public var x:Number;
		public var y:Number;
		
		public var openCounter:Number;
		public var open:Boolean;
		public var openVel:Number;
		
		public var aHands:Number;
		public var speedHands:Number;
		
		public var angleEyes:Number;
		public var phaseEyes:Number;
		
		public var visible:Boolean;
		
		public function FrogActor(stageMedia:StageMedia)
		{
			media = stageMedia;
			
			x = 0;
			y = 0;
			
			visible = true;
			
			openCounter = 0.0;
			open = false;
			openVel = 1.5;
			
			aHands = 0.0;
			speedHands = 0.0;

			phaseEyes = Math.random();
			angleEyes = Math.random();
		}
		
		public function draw(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1, 0, 0, 1, x+2, y);
			var hy:Number = y-17-42*(1-Math.cos(openCounter*3.14))*0.5;
			var color:ColorTransform = new ColorTransform(1, 1, 1, 0.5+openCounter*0.5);
			var ha1:Number = (1-Math.cos(aHands))*0.5*1.57;
			var ha2:Number = (1-Math.cos(aHands+openCounter*3.14))*0.5*1.57;
			canvas.draw(media.imgFrogBody, mat);
			
			mat.tx = -5; mat.ty = -2;
			mat.rotate(-ha1);
			mat.translate(x + 48+5, y + 58 - 17-2);
			canvas.draw(media.imgFrogHand1, mat, null, null, null, true);
			
			mat.identity();
			mat.tx = -13;
			mat.rotate(ha2);
			mat.translate(x + 92-3, y + 55 - 17);
			canvas.draw(media.imgFrogHand2, mat, null, null, null, true);

			mat.identity();
			mat.tx = x+20; mat.ty = hy;
			canvas.draw(media.imgFrogHead, mat, null, null, null, true);
		
			mat.tx = -12; mat.ty = -10;
			mat.scale(1.0 + 0.1*Math.sin(angleEyes*6.28), 1.0 + 0.1*Math.cos(angleEyes*6.28));
			mat.translate(x+ 58, 20+hy);
			canvas.draw(media.imgFrogEye1, mat, null, null, null, true);
			
			mat.identity();
			mat.tx = -15; mat.ty = -13;
			mat.scale(1.0 + 0.1*Math.sin((angleEyes+phaseEyes)*6.28), 1.0 + 0.1*Math.cos((angleEyes+phaseEyes)*6.28));
			mat.translate(x+ 87, 19+hy);
			canvas.draw(media.imgFrogEye2, mat, null, null, null, true);
			
			mat.identity();
			mat.tx = x + 51; mat.ty = hy+14;
			canvas.draw(media.imgFrogEmo1, mat, color, null, null, true);
			
			color.alphaMultiplier = openCounter;
			mat.tx = x+47; mat.ty = hy;
			canvas.draw(media.imgFrogEmo2, mat, color, null, null, true);
		}
		
		public function update(dt:Number):void
		{
			angleEyes+=dt*openCounter;
			if(angleEyes>1.0) angleEyes-=int(angleEyes);
			
			if(open)
			{
				if(openCounter<1.0)
				{
					openCounter+=dt*openVel;
					if(openCounter>1.0) openCounter = 1.0;
				}
				
				aHands+=dt*speedHands*openCounter;
				if(aHands>6.28)
					aHands-=6.28;
			}
			else
			{
				if(openCounter>0.0)
				{
					openCounter-=dt*openVel;
					if(openCounter<0.0) openCounter = 0.0;
				}
				
				if(aHands>0.0 && aHands<6.28)
				{
					aHands+=dt*speedHands;
					if(aHands>=6.28) aHands = 0.0;
				}
			}
			
		}

	}
}