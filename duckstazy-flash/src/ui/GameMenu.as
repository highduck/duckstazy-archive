package ui
{
	import ek.sui.SUIImage;
	import ek.sui.SUIScreen;
	import ek.sui.SUISystem;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.media.Sound;

	public class GameMenu extends SUIScreen
	{
		[Embed(source="gfx/menu_bg.png")]
        private var gfxBG:Class;
        
        [Embed(source="gfx/menu_tit.png")]
        private var gfxTitle:Class;
        
        [Embed(source="gfx/digiduck.png")]
        private var gfxLogo:Class;
        
        [Embed(source="gfx/publisher.png")]
        private var gfxSp:Class;
        
        [Embed(source="gfx/publisher2.png")]
        private var gfxSp2:Class;
        
        public var imgSp:BitmapData;
        public var imgSp2:BitmapData;
               
        [Embed(source="sfx/click.mp3")]
        private var sfxClick:Class;
        
        [Embed(source="sfx/click_l.mp3")]
        private var sfxClickL:Class;
        
        [Embed(source="sfx/on.mp3")]
        private var sfxOn:Class;
        
        private var btnNewGame:CircleButton;
        private var btnContinue:CircleButton;
        private var btnRes:CircleButton;
        private var btnHelp:CircleButton;
        private var btnCredits:CircleButton;
        private var btnSp:CircleButton;
        private var btnVolume:DefaultButton;
        private var btnHighScores:DefaultButton;
        private var btnSpLogo:DefaultButton;
        
        
        private var imgHiRes:BitmapData;
        private var imgLowRes:BitmapData;
        private var imgNewGame:BitmapData;
        private var imgContinue:BitmapData;

        private var imgMainMenu:BitmapData;
        private var imgRestart:BitmapData;
        private var imgResume:BitmapData;
        private var imgHelp:BitmapData;
        private var imgCredits:BitmapData;
        
        //private var imgFinish:BitmapData;
        private var imgScores:BitmapData;
        
        private var sndClick:Sound;
        private var sndClickL:Sound;
        private var sndOn:Sound;
        
        private var gui:SUISystem;
        public var shop:UpgradeMenu;
        
        private var media:UIMedia;
        
		public function GameMenu(game:Game, _gui:SUISystem)
		{
			super();
			media = game.uiMedia;
			gui = _gui;
			imgHiRes = media.imgCBHiRes;
			imgLowRes = media.imgCBLowRes;
			imgNewGame = media.imgCBNewGame;
			imgContinue = media.imgCBContinue;
			imgMainMenu = media.imgCBMainMenu;
			imgRestart = media.imgCBRestart;
			imgResume = media.imgCBResume;
			imgCredits = media.imgCBCredits;
			//imgFinish = (new gfxFinish()).bitmapData;
			
			imgSp = (new gfxSp()).bitmapData;
			imgSp2 = (new gfxSp2()).bitmapData;
			
			imgScores = new BitmapData(390, 80, true, 0);
			
			sndClick = new sfxClick();
			sndOn = new sfxOn();
			sndClickL = new sfxClickL();
			
			CircleButton.sndClickHolder = sndClick;
			CircleButton.sndOnHolder = sndOn;
			
			DefaultButton.sndOnHolder = sndOn;
			DefaultButton.sndClickHolder = sndClickL;
			
			//................
			var img:SUIImage = new SUIImage();
			img.setEmbedImage(gfxLogo);
			img.y = 480.0 - 127.0;
			img.x = 640.0 - 120.0;
			add(img);
			
			
			
			/*img = new SUIImage();
			img.img = imgScores;
			img.x = 140;
			img.y = 400;
			add(img);*/
			
			img = new SUIImage();
			img.setEmbedImage(gfxBG);
			img.x = 320.0 - 128.0;
			img.y = 200.0 - 128.0;
			add(img);
			
			img = new SUIImage();
			img.setEmbedImage(gfxTitle);
			img.x = 320.0 - 175.0;
			img.y = 200.0 - 52.0;
			add(img);
			//********************
			
			btnNewGame = new CircleButton();
			btnNewGame.x = 229.0;
			btnNewGame.y = 79.0;
			btnNewGame.radius = 55.0;
			btnNewGame.callback = game.clickNewGame;
			
			btnContinue = new CircleButton();
			btnContinue.x = 411.0;
			btnContinue.y = 79.0;
			btnContinue.radius = 55.0;
			btnContinue.callback = game.startLevel;
			btnContinue.img = imgContinue;
			
			btnCredits = new CircleButton();
			btnCredits.x = 411.0;
			btnCredits.y = 307.0;
			btnCredits.radius = 55.0;
			btnCredits.callback = game.goCredits;
			
			
			
			
			refreshInGame(game);
			
			//////////////////
			
			btnRes = new CircleButton();
			btnRes.x = 69.0;
			btnRes.y = 192.0;
			btnRes.radius = 45.0;
			btnRes.callback = game.changeRes;
			refreshRes(game);
			
			btnSp = new CircleButton();
			btnSp.x = 562.0;
			btnSp.y = 192.0;
			btnSp.radius = 45.0;
			btnSp.img = media.imgCBSp;
			btnSp.linesColor = 0xd5f2ff;
			btnSp.bgColor = 0x99ccff;
			btnSp.hold = btnSp.holdMin = 0.9;
			btnSp.callback = game.goSp;
			
			btnSpLogo = new DefaultButton();
			btnSpLogo.imgs = [imgSp2, imgSp, imgSp, imgSp];
			btnSpLogo.rc = new Rectangle(6,6,170,66);
			btnSpLogo.x = 5;
			btnSpLogo.y = 480-77;
			btnSpLogo.callback = game.goSp;
			
			
					
			btnHelp = new CircleButton();
			btnHelp.x = 229.0;
			btnHelp.y = 307.0;
			btnHelp.radius = 55.0;
			btnHelp.callback = game.goHelp;
			btnHelp.img = media.imgCBHelp;
			
			btnHighScores = media.createDefaultButton(media.imgBtnHighScores);
			btnHighScores.x = 258;
			btnHighScores.y = 443;
			btnHighScores.callback = game.showHighScores;
			
			btnVolume = media.createDefaultButtonImgs(media.imgsSfx);
			btnVolume.x = 258;
			btnVolume.y = 412;
			btnVolume.callback = game.changeMute;
			
			refreshVol(game);

			
			//--------------------
			add(btnSpLogo);
			add(btnNewGame);
			add(btnContinue);
			add(btnCredits);
			add(btnRes);
			add(btnVolume);
			add(btnHelp);
			add(btnHighScores);
			add(btnSp);
		}
		
		
		public function refreshRes(game:Game):void
		{
			if(game.hires)
				btnRes.img = imgHiRes;
			else
				btnRes.img = imgLowRes;
		}
		
		public function refreshVol(game:Game):void
		{
			if(game.mute)
				btnVolume.imgs = media.imgsNoSfx;
			else
				btnVolume.imgs = media.imgsSfx;
		}
		
		public function refreshInGame(game:Game):void
		{
			if(game.inGame)
			{
				btnNewGame.img = imgResume;
				
				btnContinue.enabled = true;
				btnContinue.img = imgRestart;
				
				btnCredits.img = imgMainMenu;
			}
			else
			{
				btnNewGame.img = imgNewGame;
				
				btnContinue.enabled = game.gameSave.level!=0;
				btnContinue.img = imgContinue;
				
				btnCredits.img = imgCredits;
			}
		}
		
		public function go():void
		{
			gui.setCurrent(this);
			Game.instance.updateResults();
		}
		
		public function updateScores():void
		{
			/*var tf:TextField = shop.text;
			var game:Game = Game.instance;
			var mat:Matrix = new Matrix();
			
			imgScores.fillRect(new Rectangle(0, 0, imgScores.width, imgScores.height), 0);
			if(game.lastScores>0)
			{
				//tf = shop.mini;
				tf.text = "LAST RESULT: "+game.lastScores.toString();
				mat.tx = imgFinish.width;
				mat.ty = 10;
				imgScores.draw(tf, mat);
				if(game.lastScoresFinish)
				{
					mat.tx = 0;
					mat.ty = 0;
					imgScores.draw(imgFinish, mat);
				}
			}
			if(game.maxScores>0)
			{
				tf.text = "BEST RESULT: "+game.maxScores.toString();
				mat.tx = imgFinish.width;
				mat.ty = 40; 
				imgScores.draw(tf, mat);
				if(game.maxScoresFinish)
				{
					mat.tx = 0;
					mat.ty = 80-imgFinish.height;
					imgScores.draw(imgFinish, mat);
				}	
			}*/
		}
	}
}