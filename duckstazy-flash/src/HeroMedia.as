package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	public class HeroMedia
	{
		
		// ГРАФИКА //
		[Embed(source="gfx/duck.png")]
        private var rDuckImg:Class;
        
		[Embed(source="gfx/sleep.png")]
        private var rSleepImg:Class;
        
        //[Embed(source="gfx/foots.png")]
        //private var rFootsImg:Class;

		[Embed(source="gfx/wing.png")]
        private var rWingImg:Class;

		[Embed(source="gfx/eye1.png")]
        private var rEyeImg1:Class;

		[Embed(source="gfx/eye2.png")]
        private var rEyeImg2:Class;
        
        private var imgDuck:BitmapData;
        //private var imgDuckFlip:BitmapData;
        
        private var imgSleep:BitmapData;
       // private var imgSleepFlip:BitmapData;
        
        private var imgWing:BitmapData;
		private var imgEye1:BitmapData;
		private var imgEye2:BitmapData;
		
		//static private const rcHero:Rectangle = new Rectangle(0.0, 0.0, 54.0, 42.0);
		
		
		// ЗВУКИ //
		
		[Embed(source="sfx/step1.mp3")]
        private var rStepSnd1:Class;

		[Embed(source="sfx/step2.mp3")]
        private var rStepSnd2:Class;
        
        [Embed(source="sfx/wing1.mp3")]
        private var rWingSnd1:Class;

		[Embed(source="sfx/wing2.mp3")]
        private var rWingSnd2:Class;
        
        [Embed(source="sfx/land.mp3")]
        private var rLandSnd:Class;
        
        [Embed(source="sfx/jump.mp3")]
        private var rJumpSnd:Class;

        [Embed(source="sfx/awake.mp3")]
        private var rAwakeSnd:Class;
        
        [Embed(source="sfx/sleep.mp3")]
        private var rSleepSnd:Class;
        
        [Embed(source="sfx/attack.mp3")]
        private var rAttackSnd:Class;
        
        [Embed(source="sfx/toxic.mp3")]
        private var rToxicSnd:Class;
               
		private var sndStep1:Sound;
		private var sndStep2:Sound;
		private var sndWing1:Sound;
		private var sndWing2:Sound;
 		private var sndJump:Sound;
 		private var sndLand:Sound;
 		private var sndAwake:Sound;
 		private var sndSleep:Sound;
 		public var sndAttack:Sound;
 		public var sndToxic:Sound;
 		
 		private var transformPan:SoundTransform;
 		private var transformPanVol:SoundTransform;
 		private var trigStep:Boolean;
 		private var trigWing:Boolean;
		         
		public function HeroMedia()
		{
			initGFX();
			initSFX();
		}
		
		
		private function initGFX():void
		{
			/*var duckBitmap:Bitmap = new rDuckImg();
			var footsBitmap:Bitmap = new rFootsImg();
			var sleepBitmap:Bitmap = new rSleepImg();*/
			
			//var mat:Matrix = new Matrix();
			
			//var rcFoots:Rectangle = new Rectangle(0.0, 0.0, 13.0, 3.0);
			//var rcBody:Rectangle = new Rectangle(0.0, 0.0, 54.0, 40.0);
			
			imgEye1 = (new rEyeImg1()).bitmapData;
			imgEye2 = (new rEyeImg2()).bitmapData;
			imgWing = (new rWingImg()).bitmapData;
					
			/*imgDuck = new BitmapData(54, 42, true, 0x00000000);
			imgDuck.lock();
			imgDuck.copyPixels(duckBitmap.bitmapData, rcBody, new Point());
			imgDuck.copyPixels(footsBitmap.bitmapData, rcFoots, new Point(30.0, 39.0));
			imgDuck.unlock();
			
			imgSleep = new BitmapData(54, 42, true, 0x00000000);
			imgSleep.lock();
			imgSleep.copyPixels(sleepBitmap.bitmapData, rcBody, new Point());
			imgSleep.unlock();*/
			
			imgDuck = (new rDuckImg()).bitmapData;
			imgSleep = (new rSleepImg()).bitmapData;
								
			/*mat.scale(-1.0, 1.0);
			mat.translate(54.0, 0.0);
			
			imgDuckFlip = new BitmapData(54, 42, true, 0x00000000);			
			imgDuckFlip.lock();
			imgDuckFlip.draw(duckBitmap.bitmapData, mat);
			imgDuckFlip.copyPixels(footsBitmap.bitmapData, rcFoots, new Point(12.0, 39.0));
			imgDuckFlip.unlock();
					
			imgSleepFlip = new BitmapData(54, 42, true, 0x00000000);			
			imgSleepFlip.lock();
			imgSleepFlip.draw(sleepBitmap.bitmapData, mat);
			imgSleepFlip.unlock();*/
		}
		
		private function initSFX():void
		{
			sndStep1 = new rStepSnd1();
			sndStep2 = new rStepSnd2();
			sndWing1 = new rWingSnd1();
			sndWing2 = new rWingSnd2();
			sndJump = new rJumpSnd();
			sndLand = new rLandSnd();
			sndAwake = new rAwakeSnd();
			sndSleep = new rSleepSnd();
			sndAttack = new rAttackSnd();
			sndToxic = new rToxicSnd();
			
			transformPan = new SoundTransform();
			transformPanVol = new SoundTransform();
		}
		
		public function drawDuck(dest:BitmapData, x:Number, y:Number, power:Number, flip:Boolean, wingsAngle:Number):void
		{
			var mat:Matrix = new Matrix(1, 0, 0, 1, x, y);
			/*var eye_mat:Matrix = new Matrix();
			var wing_mat:Matrix = new Matrix();*/
			var eye:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0-power);
			//var eye2_color:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, power);
		
			if(flip)
			{
				mat.a = -1;
				mat.tx = x + 54.0;
				//dest.copyPixels(imgDuckFlip, rcHero, new Point(x, y));
				dest.draw(imgDuck, mat, null, null, null, true);
				
				mat.tx = 44.0 + x;
				mat.ty = 5.0 + y;
				dest.draw(imgEye1, mat, eye, null, null, true);
				eye.alphaMultiplier = power;
				dest.draw(imgEye2, mat, eye, null, null, true);
				
				mat.tx = 3.0;
				mat.ty = -7.0;
				mat.rotate(-wingsAngle);
				mat.translate(21.0 + x, 26.0 + y);
				dest.draw(imgWing, mat, null, null, null, true);
			}
			else
			{
				//dest.copyPixels(imgDuck, rcHero, new Point(x, y));
				dest.draw(imgDuck, mat, null, null, null, true);
								
				mat.tx = 10.0 + x;
				mat.ty = 5.0 + y;
				dest.draw(imgEye1, mat, eye, null, null, true);
				eye.alphaMultiplier = power;
				dest.draw(imgEye2, mat, eye, null, null, true);
			
				mat.tx = -3.0;
				mat.ty = -7.0;
				mat.rotate(wingsAngle);
				mat.translate(33.0 + x, 26.0 + y);
				dest.draw(imgWing, mat, null, null, null, true);
			}
			
			//dest.draw(imgEye1.bitmapData, eye_mat, eye1_color);
			//dest.draw(imgEye2.bitmapData, eye_mat, eye2_color);
			//dest.draw(imgWing.bitmapData, wing_mat, null, null, null, wingsAngle!=0.0);
		}
		
		public function drawSleep(dest:BitmapData, x:Number, y:Number, flip:Boolean):void
		{
			/*if(flip)
				dest.copyPixels(imgSleepFlip, rcHero, new Point(x, y));
			else
				dest.copyPixels(imgSleep, rcHero, new Point(x, y));*/
				
			var mat:Matrix = new Matrix(1, 0, 0, 1, x, y);	
			
			if(flip)
			{
				mat.a = -1;
				mat.tx = x + 54.0;
			}
			
			dest.draw(imgSleep, mat, null, null, null, true);
		}
		
		public function updateSFX(x:Number):void
		{
			var pan:Number = utils.pos2pan(x);
			
			if(pan>1.0) pan = 1.0;
			else if(pan<-1.0) pan = -1.0;
			
			transformPan.pan = pan;
			
			transformPanVol.pan = pan;
			transformPanVol.volume = 0.3 + Math.random()*0.7;
		}
		
		public function playAwake():void
		{
			sndAwake.play(49.0, 0, transformPan); 
		}
		
		public function playSleep():void
		{
			sndSleep.play(49.0, 0, transformPan); 
		}
		
		public function playJump():void
		{
			sndJump.play(49.0, 0, transformPan); 
		}
		
		public function playLand():void
		{
			sndLand.play(49.0, 0, transformPan);
			//utils.playSound(land_snd, (power+0.3)*Math.abs(jumpVel)/200.0, pos.x+27);
		}
		
		public function playStep():void
		{
			var snd:Sound;
			
			if(trigStep)
				snd = sndStep1;
			else
				snd = sndStep2;
				
			trigStep = !trigStep;
			
			snd.play(49.0, 0, transformPanVol);
			//var trans:SoundTransform = new SoundTransform(utils.rnd_float(0.3, 1.0), utils.pos2pan(pos.x+duck_w));
		}
		
		public function playWing():void
		{
			var snd:Sound;
			
			if(trigWing)
				snd = sndWing1;
			else
				snd = sndWing2;
				
			trigWing = !trigWing;
			
			snd.play(49.0, 0, transformPanVol);
			
			//var trans:SoundTransform = new SoundTransform(utils.rnd_float(0.5, 1.0)*(0.3 + power*0.7), utils.pos2pan(pos.x+duck_w));
		}
		
	}
}