package lev.fx
{
	import flash.display.BitmapData;
	
	public class StageMedia
	{
		[Embed(source="gfx/pedestal_l.png")]
        private var gfxPedestalL:Class;
        
        [Embed(source="gfx/pedestal_r.png")]
        private var gfxPedestalR:Class;
               
        public var imgPedestalL:BitmapData;
        public var imgPedestalR:BitmapData;
        
        [Embed(source="gfx/cat_r.png")]
        private var gfxCatR:Class;
        
        [Embed(source="gfx/cat_l.png")]
        private var gfxCatL:Class;
        
        [Embed(source="gfx/cat_smile.png")]
        private var gfxCatSmile:Class;
        
        [Embed(source="gfx/cat_hum.png")]
        private var gfxCatHum:Class;

        public var imgCatR:BitmapData;
        public var imgCatL:BitmapData;
        public var imgCatSmile:BitmapData;
        public var imgCatHum:BitmapData;
        
        [Embed(source="gfx/hint_arrow.png")]
        private var gfxHintArrow:Class;

        public var imgHintArrow:BitmapData;
        
        [Embed(source="gfx/frog_body.png")]
		private var gfxFrogBody:Class;

		[Embed(source="gfx/frog_emo1.png")]
		private var gfxFrogEmo1:Class;

		[Embed(source="gfx/frog_emo2.png")]
		private var gfxFrogEmo2:Class;

		[Embed(source="gfx/frog_eye1.png")]
		private var gfxFrogEye1:Class;

		[Embed(source="gfx/frog_eye2.png")]
		private var gfxFrogEye2:Class;

		[Embed(source="gfx/frog_hand1.png")]
		private var gfxFrogHand1:Class;

		[Embed(source="gfx/frog_hand2.png")]
		private var gfxFrogHand2:Class;

		[Embed(source="gfx/frog_head.png")]
		private var gfxFrogHead:Class;

		public var imgFrogBody:BitmapData;
		public var imgFrogEmo1:BitmapData;
		public var imgFrogEmo2:BitmapData;
		public var imgFrogEye1:BitmapData;
		public var imgFrogEye2:BitmapData;
		public var imgFrogHand1:BitmapData;
		public var imgFrogHand2:BitmapData;
		public var imgFrogHead:BitmapData;
		
		[Embed(source="gfx/pump.png")]
		private var gfxPump:Class;

		[Embed(source="gfx/party.png")]
		private var gfxParty:Class;

		[Embed(source="gfx/trip.png")]
		private var gfxTrip:Class;

		public var imgPump:BitmapData;
		public var imgParty:BitmapData;
		public var imgTrip:BitmapData;

 		[Embed(source="gfx/theend.png")]
        private var gfxTheEnd:Class;
        
        [Embed(source="gfx/stageend.png")]
        private var gfxStageEnd:Class;
        
		public var imgTheEnd:BitmapData;
		public var imgStageEnd:BitmapData;
		
		public function StageMedia()
		{
			imgPedestalL = (new gfxPedestalL()).bitmapData;
			imgPedestalR = (new gfxPedestalR()).bitmapData;
			
			imgCatR = (new gfxCatR()).bitmapData;
			imgCatL = (new gfxCatL()).bitmapData;
			imgCatSmile = (new gfxCatSmile()).bitmapData;
			imgCatHum = (new gfxCatHum()).bitmapData;
			
			imgHintArrow = (new gfxHintArrow()).bitmapData;
			
			imgFrogBody = (new gfxFrogBody()).bitmapData;
			imgFrogEmo1 = (new gfxFrogEmo1()).bitmapData;
			imgFrogEmo2 = (new gfxFrogEmo2()).bitmapData;
			imgFrogEye1 = (new gfxFrogEye1()).bitmapData;
			imgFrogEye2 = (new gfxFrogEye2()).bitmapData;
			imgFrogHand1 = (new gfxFrogHand1()).bitmapData;
			imgFrogHand2 = (new gfxFrogHand2()).bitmapData;
			imgFrogHead = (new gfxFrogHead()).bitmapData;
			
			imgPump = (new gfxPump()).bitmapData;
			imgParty = (new gfxParty()).bitmapData;
			imgTrip = (new gfxTrip()).bitmapData;
			
			imgTheEnd = (new gfxTheEnd()).bitmapData;
			imgStageEnd = (new gfxStageEnd()).bitmapData;
		}
	}
}