package ui
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class UIMedia
	{
		private const MATRIX:Matrix = new Matrix();
		private const DEF_BTN_RC:Rectangle = new Rectangle(3,3,116,22);
		private const WHITE_MASK:ColorTransform = new ColorTransform(1,1,1,1,255,255,255);
		private const RC:Rectangle = new Rectangle();
		private const POINT:Point = new Point();
		private const BLUR8:BlurFilter = new BlurFilter(4, 4, 8);
		
		[Embed(source="gfx/btn_body.png")]
        private var gfxBtnBody:Class;
        
        [Embed(source="gfx/btn_light.png")]
        private var gfxBtnLight:Class;
        
        [Embed(source="gfx/hk_space.png")]
		private var gfxHkSpace:Class;

		[Embed(source="gfx/hk_enter.png")]
		private var gfxHkEnter:Class;

		[Embed(source="gfx/hk_esc.png")]
		private var gfxHkEsc:Class;
		
		[Embed(source="gfx/mute.png")]
		private var gfxMute:Class;

		[Embed(source="gfx/unmute.png")]
		private var gfxUnmute:Class;
       
		public var bigText:TextField;
        public var miniText:TextField;
        public var btnText:TextField;
        public var cbText:TextField;
        public var cbMiniText:TextField;
        
        public var imgBtnBody:BitmapData;
        public var imgBtnLight:BitmapData;
        public var imgBtnUpgrade:BitmapData;
        public var imgBtnGameMenu:BitmapData;
        public var imgBtnRestart:BitmapData;
        public var imgBtnSubmit:BitmapData;
        public var imgBtnHighScores:BitmapData;
        public var imgBtnSfx:BitmapData;
        public var imgBtnNoSfx:BitmapData;
		public var imgBtnSpGray:BitmapData;
        
        public var imgsNoSfx:Array;
        public var imgsSfx:Array;
        
        public var imgHkSpace:BitmapData;
		public var imgHkEnter:BitmapData;
		public var imgHkEsc:BitmapData;
		public var imgMute:BitmapData;
		public var imgUnmute:BitmapData;
		
		public var imgCBNewGame:BitmapData;
		public var imgCBHiRes:BitmapData;
 		public var imgCBLowRes:BitmapData;
 		public var imgCBContinue:BitmapData;
 		public var imgCBHelp:BitmapData;
 		public var imgCBCredits:BitmapData;
 		public var imgCBMainMenu:BitmapData;
 		public var imgCBResume:BitmapData;
 		public var imgCBRestart:BitmapData;
 		public var imgCBBuy:BitmapData;
 		public var imgCBBack:BitmapData;
 		public var imgCBSp:BitmapData;
    
		public function UIMedia()
		{
			bigText = new TextField();
 			bigText.defaultTextFormat = new TextFormat("_default", 25, 0xffffffff);//28
 			bigText.embedFonts = true;
 			bigText.cacheAsBitmap = false;
 			bigText.autoSize = TextFieldAutoSize.LEFT;
 			bigText.filters = [new DropShadowFilter(0.0, 0.0, 0, 1, 4, 4, 4, 1)];
 			
 			miniText = new TextField();
 			miniText.defaultTextFormat = new TextFormat("_default", 16, 0xffffffff);//20
 			miniText.embedFonts = true;
 			miniText.cacheAsBitmap = false;
 			miniText.multiline = true;
 			miniText.autoSize = TextFieldAutoSize.LEFT;
 			
 			btnText = new TextField();
 			btnText.defaultTextFormat = new TextFormat("_default", 16, 0xffffffff);//20
 			btnText.embedFonts = true;
 			btnText.cacheAsBitmap = false;
 			btnText.autoSize = TextFieldAutoSize.LEFT;
 			btnText.filters = [new DropShadowFilter(0.0, 0.0, 0x272727, 1, 4, 4, 32, 1)];
 			
 			cbText = new TextField();
 			cbText.defaultTextFormat = new TextFormat("_default", 40, 0xffffffff, false, null, null, null, null, TextFormatAlign.CENTER, null, null, null, -20);//20
 			cbText.embedFonts = true;
 			cbText.cacheAsBitmap = false;
 			cbText.multiline = true;
 			cbText.autoSize = TextFieldAutoSize.NONE;
 			cbText.filters = [new DropShadowFilter(0.0, 0.0, 0x000000, 1, 6, 6, 8, 1)];
 			
 			cbMiniText = new TextField();
 			cbMiniText.defaultTextFormat = new TextFormat("_default", 30, 0xffffffff, false, null, null, null, null, TextFormatAlign.CENTER, null, null, null, -16);//20
 			cbMiniText.embedFonts = true;
 			cbMiniText.cacheAsBitmap = false;
 			cbMiniText.multiline = true;
 			cbMiniText.autoSize = TextFieldAutoSize.NONE;
 			cbMiniText.filters = [new DropShadowFilter(0.0, 0.0, 0x000000, 1, 6, 6, 8, 1)];
 			
 			imgHkSpace = (new gfxHkSpace()).bitmapData;
			imgHkEnter = (new gfxHkEnter()).bitmapData;
			imgHkEsc = (new gfxHkEsc()).bitmapData;
			imgMute = (new gfxMute()).bitmapData;
			imgUnmute = (new gfxUnmute()).bitmapData;
			
 			imgBtnBody = (new gfxBtnBody()).bitmapData;
 			imgBtnLight = (new gfxBtnLight()).bitmapData;
 			imgBtnUpgrade = createTextBtnHK("UPGRADE", imgHkEnter);
			imgBtnGameMenu = createTextBtnHK("GAME MENU", imgHkEsc);
			imgBtnSubmit = createTextBtnHK("SUBMIT", imgHkSpace);
			imgBtnRestart = createTextBtnHK("TRY AGAIN", imgHkEnter);
 			imgBtnHighScores = createTextBtn("HIGH SCORES");
 			imgBtnSfx = createTextBtnHK("MUTE SFX", imgUnmute, -1);
 			imgBtnNoSfx = createTextBtnHK("UNMUTE SFX", imgMute, -1);
 			imgBtnSpGray = createTextBtn("MORE GAMES");
 			
 			imgsSfx = [imgBtnLight, imgBtnSfx, imgBtnSfx, imgBtnSfx];
 			imgsNoSfx = [imgBtnLight, imgBtnNoSfx, imgBtnNoSfx, imgBtnNoSfx];
 			
 			imgCBNewGame = createCB("NEW\nGAME", 110, 10);
 			imgCBHiRes = createCB("HIGH\nDETAILS", 90, 18, true);
 			imgCBLowRes = createCB("LOW\nDETAILS", 90, 18, true);
 			imgCBContinue = createCB("LAST\nSAVE", 110, 10);
 			imgCBHelp = createCB("HELP", 110, 24);
 			imgCBCredits = createCB("ABOUT", 110, 24);
 			imgCBMainMenu = createCB("MAIN\nMENU", 110, 10);
 			imgCBResume = createCB("RESUME\nLEVEL", 110, 22, true);
 			imgCBRestart = createCB("RESTART\nLEVEL", 110, 22, true);
 			imgCBBuy = createCB("BUY", 110, 24);
 			imgCBBack = createCB("BACK", 110, 24);
 			imgCBSp = createCB("MORE\nGAMES", 110, 10);
		}
		
		private function createTextBtn(text:String):BitmapData
		{
			
			var bm:BitmapData = new BitmapData(imgBtnBody.width, imgBtnBody.height, true, 0);
			bm.draw(imgBtnBody);
			btnText.text = text;
			
			MATRIX.tx = (imgBtnBody.width-btnText.width)*0.5;
			MATRIX.ty = (imgBtnBody.height-btnText.height)*0.5;
			
			bm.draw(btnText, MATRIX);
			
			return bm;
		}
		
		private function createTextBtnHK(text:String, hk:BitmapData, off:int = 0):BitmapData
		{
			var bm:BitmapData = new BitmapData(imgBtnBody.width, imgBtnBody.height, true, 0);
			var sp:Number;
			
			bm.draw(imgBtnBody);
			btnText.text = text;
			sp = (122-btnText.width-hk.width+4)/3;
			
			MATRIX.tx = 3+sp;
			MATRIX.ty = (imgBtnBody.height-btnText.height)*0.5;
			
			bm.draw(btnText, MATRIX);
			
			MATRIX.tx = 3+2*sp+btnText.width-4;
			MATRIX.ty = (imgBtnBody.height-hk.height)*0.5+1+off;
			
			bm.draw(hk, MATRIX);
			
			return bm;
		}
		
		public function createDefaultButton(img:BitmapData):DefaultButton
		{
			var btn:DefaultButton = new DefaultButton();
			
			btn.imgs = [imgBtnLight, img, img, img];
			btn.rc = DEF_BTN_RC;
			
			return btn;
		}
		
		public function createDefaultButtonImgs(imgs:Array):DefaultButton
		{
			var btn:DefaultButton = new DefaultButton();
			
			btn.imgs = imgs;
			btn.rc = DEF_BTN_RC;
			
			return btn;
		}
		
		//110x110, 90x90
		private function createCB(text:String, size:int, oy:int=0, mini:Boolean = false):BitmapData
		{
			var bm:BitmapData = new BitmapData(size, size, true, 0);
			var tf:TextField;
			
			if(mini) tf = cbMiniText;
			else tf = cbText;
			
			tf.text = text;
			
			MATRIX.tx = (size-tf.width)*0.5;
			MATRIX.ty = (size-tf.height)*0.5+oy;
			
			RC.width = RC.height = size;
			POINT.x = POINT.y = 0;
			
			bm.draw(tf, MATRIX, WHITE_MASK);
			bm.applyFilter(bm, RC, POINT, BLUR8);
			bm.draw(tf, MATRIX);
			
			tf = null;
						
			return bm;
		}
		

	}
}
