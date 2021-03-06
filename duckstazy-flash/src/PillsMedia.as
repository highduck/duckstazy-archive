package
{
	import flash.display.BitmapData;
	import flash.media.Sound;
	
	public class PillsMedia
	{
		[Embed(source="gfx/p1.png")]
        private var rPowerImg1:Class;
        
		[Embed(source="gfx/p2.png")]
        private var rPowerImg2:Class;
        
        [Embed(source="gfx/p3.png")]
        private var rPowerImg3:Class;
        
        [Embed(source="gfx/pp1.png")]
        private var rSuperPowerImg1:Class;
        
		[Embed(source="gfx/pp2.png")]
        private var rSuperPowerImg2:Class;
        
        [Embed(source="gfx/pp3.png")]
        private var rSuperPowerImg3:Class;
        
        //[Embed(source="gfx/pn.png")]
        //private var rEmoImg:Class;
        
        [Embed(source="gfx/pn1.png")]
        private var rNidImg1:Class;
        
		[Embed(source="gfx/pn2.png")]
        private var rNidImg2:Class;
        
        [Embed(source="gfx/pn3.png")]
        private var rNidImg3:Class;
        
        [Embed(source="gfx/pn4.png")]
        private var rNidImg4:Class;
        
        [Embed(source="gfx/ph.png")]
        private var rHighImg:Class;
        
        [Embed(source="gfx/pt.png")]
        private var rToxicImg:Class;

        [Embed(source="gfx/pt2.png")]
        private var rToxic2Img:Class;
        
        [Embed(source="gfx/pcure.png")]
        private var rCureImg:Class;
        
        [Embed(source="gfx/phole.png")]
        private var gfxHole:Class;

        
        [Embed(source="gfx/psleep.png")]
        private var rSleepImg:Class;
        
		[Embed(source="gfx/emo_smile1.png")]
        private var rSmileImg1:Class;
        
		[Embed(source="gfx/emo_smile2.png")]
        private var rSmileImg2:Class;
        
        [Embed(source="gfx/emo_smile3.png")]
        private var rSmileImg3:Class;
        
        [Embed(source="gfx/emo_eyes1.png")]
        private var rEyesImg1:Class;
        
        [Embed(source="gfx/emo_eyes2.png")]
        private var rEyesImg2:Class;
        
       	[Embed(source="sfx/warning.mp3")]
        private var rWarningSnd:Class;
        
        [Embed(source="sfx/toxic_born.mp3")]
        private var rToxicBornSnd:Class;
   		   		
	    [Embed(source="sfx/generate.mp3")]
        private var rGenerateSnd:Class;
        
        [Embed(source="sfx/p1.mp3")]
        private var rPower1Snd:Class;
 
   		[Embed(source="sfx/p2.mp3")]
        private var rPower2Snd:Class;
   		
	    [Embed(source="sfx/p3.mp3")]
        private var rPower3Snd:Class;
        
        //[Embed(source="sfx/heal.mp3")]
       // private var rHealSnd:Class;
        
        [Embed(source="sfx/jumper.mp3")]
        private var rJumperSnd:Class;
        
        [Embed(source="sfx/high.mp3")]
        private var rHighSnd:Class;
        
        public var sndPowers:Array;
   		public var sndHeal:Sound;
   		public var sndJumper:Sound;
   		public var sndHigh:Sound;
        public var sndWarning:Sound;
        public var sndToxicBorn:Sound;
   		public var sndGenerate:Sound;
        
        // Основы таблеток
		public var imgPower1:BitmapData;
		public var imgPower2:BitmapData;
		public var imgPower3:BitmapData;
		
		public var imgPPower1:BitmapData;
		public var imgPPower2:BitmapData;
		public var imgPPower3:BitmapData;
		
		public var imgNids:Array;
		
		public var imgHigh:BitmapData;
		
		public var imgToxic:BitmapData;
		public var imgToxic2:BitmapData;
		
		public var imgCure:BitmapData;
		public var imgHole:BitmapData;
		public var imgSleep:BitmapData;
		
		// Эмоции таблеток
		//public var imgEmo:BitmapData;
		public var imgSmile1:BitmapData;
		public var imgSmile2:BitmapData;
		public var imgSmile3:BitmapData;
		public var imgEyes1:BitmapData;
		public var imgEyes2:BitmapData;
		
		public var power:Number;
		
		public function PillsMedia()
		{
			imgPower1 = (new rPowerImg1()).bitmapData;
			imgPower2 = (new rPowerImg2()).bitmapData;
			imgPower3 = (new rPowerImg3()).bitmapData;
			imgPPower1 = (new rSuperPowerImg1()).bitmapData;
			imgPPower2 = (new rSuperPowerImg2()).bitmapData;
			imgPPower3 = (new rSuperPowerImg3()).bitmapData;
			
			imgNids = [ (new rNidImg1()).bitmapData, 
						(new rNidImg2()).bitmapData, 
						(new rNidImg3()).bitmapData,
						(new rNidImg4()).bitmapData];
						
			//imgEmo = (new rEmoImg()).bitmapData; 

			imgHigh = (new rHighImg()).bitmapData;

			imgToxic = (new rToxicImg()).bitmapData;
			imgToxic2 = (new rToxic2Img()).bitmapData;
			imgCure = (new rCureImg()).bitmapData;
			imgSleep = (new rSleepImg()).bitmapData;
			imgHole = (new gfxHole()).bitmapData;
			
			imgSmile1 = (new rSmileImg1()).bitmapData;
			imgSmile2 = (new rSmileImg2()).bitmapData;
			imgSmile3 = (new rSmileImg3()).bitmapData;
			imgEyes1 = (new rEyesImg1()).bitmapData;
			imgEyes2 = (new rEyesImg2()).bitmapData;
			
			sndPowers = [new rPower1Snd(), new rPower2Snd(), new rPower3Snd()];
			//sndHeal = new rHealSnd();
			sndWarning = new rWarningSnd();
			sndGenerate = new rGenerateSnd();
			
			sndJumper = new rJumperSnd();
			sndHigh = new rHighSnd();
			sndToxicBorn = new rToxicBornSnd();
			
			power = 0.0;
		}

	}
}