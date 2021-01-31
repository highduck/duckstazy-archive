package
{

	import ek.ekDevice;
	import ek.ekIListener;
	import ek.sui.SUISystem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ui.DescScreen;
	import ui.GameMenu;
	import ui.LevelMenu;
	import ui.ScoresTable;
	import ui.UIMedia;
	import ui.UpgradeMenu;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	[Frame(factoryClass="PreLoader")]
	[SWF(backgroundColor="#000000", frameRate="60", width="640", height="480")]
   	public class Game implements ekIListener
	{
  		public const MENU:int = 0;
		public const LEVEL:int = 1;
		
		public static var instance:Game;

		private var state:int;
		
		// Полезная информация
		private var debugInfoText:TextField;
		private var debugInfoTgl:Boolean;
		
		// Состояние текущее и сохранение состояния перед уровнем
		public var gameState:GameState;
		public var gameSave:GameState;
		
		// Уровень.
		public var level:Level;
		
		//private var menu:Menu;
		
		// Вывод
		private var canvas:BitmapData;
		//private var flipped:Boolean;
		
		public var back:BitmapData;
		public var backBitmap:Bitmap;
		
		public var imgBG:BitmapData;
		
		//private var front:BitmapData;
		//public var frontBitmap:Bitmap;
		
		// Ресурсы
		private var resourceManager:Resources;
		
		// ГУИ
		public var gui:SUISystem;
		public var uiMedia:UIMedia;
		public var mainMenu:GameMenu;
		public var levelMenu:LevelMenu;
		public var descScreen:DescScreen;
		private var shopMenu:UpgradeMenu;
		public var scoresTable:ScoresTable;
		public var hires:Boolean;
		public var mute:Boolean;
		public var inGame:Boolean;
		
		public var maxScores:int;
		public var maxScoresFinish:Boolean;
		public var lastScores:int;
		public var lastScoresFinish:Boolean;
		
		public var stage:Stage;
		
		private var device:ekDevice;
				
		public function Game()
		{
		    instance = this;
		    device = ekDevice.instance;
		    device.callbackFPS = updateFPS;
		    device.listener = this;

			stage = device.stage;
			stage.frameRate = 75;
            device.quality = 0;
            
			// Таймер всему голова, вначале его создаем
			//timer = new GameTimer();
						
			// Игровые состояния
			gameState = new GameState();
			gameSave = new GameState();
			
			// Грузим и кешируем ресурсы
			resourceManager = new Resources();
			
			
			
			
			// Поверхности для вывода
			back = new BitmapData(640, 480, false, 0);
			backBitmap = new Bitmap(back);//, PixelSnapping.NEVER, false);
			canvas = back;
			imgBG = new BitmapData(640, 480, false);
			
			// Уровень
			level = new Level(gameState);
			   			
   			debugInfoTgl = true;
   			
			state = MENU;
			inGame = false;
			mute = false;
			hires = true;
			
			maxScores = 0;
			maxScoresFinish = false;
			lastScores = 0;
			lastScoresFinish = false;
			
			stage.addChildAt(backBitmap as DisplayObject, 0);
	
			debugInfoText = new TextField();
			debugInfoText.defaultTextFormat = new TextFormat("_mini", 15, 0xffffff);
 			debugInfoText.embedFonts = true;
			debugInfoText.cacheAsBitmap = true;
			
			// ГУИ
			gui = new SUISystem();
			level.gui = gui;
			gui.listen(stage);
			
			uiMedia = new UIMedia();
			
			mainMenu = new GameMenu(this, gui);
			levelMenu = new LevelMenu(this);
			descScreen = new DescScreen(gui);
			shopMenu = new UpgradeMenu(gui, level);
			mainMenu.shop = shopMenu;
			
			level.initShopMenu(shopMenu);
			level.levelMenu = levelMenu;
			
			scoresTable = new ScoresTable();
			
			mainMenu.go();
			
			level.env.blanc = 1;
			level.sndStart.play();
			
 		}
 		
 		public function frame(dt:Number):void
        {
        	//var dt:Number = device.update();
        	var env:Env = level.env;
						
			switch(state)
			{
			case MENU:
				env.update(dt, 0.0);
				level.progress.update(dt, 0.0);
				break;
			case LEVEL:
				level.update(dt);
				break;
			}
			
			gui.update(dt);
			env.updateBlanc(dt);
			
			
			//**RENDER**//
			//backBitmap.visible = false;
			canvas.lock();
			
			if(gui.current!=scoresTable)
			{
				switch(state)
				{
				case MENU:
					env.draw1(canvas);
					env.draw2(canvas);
					level.progress.draw(canvas);
					break;
				case LEVEL:
					level.draw(canvas);
					break;
				}
			}
			
			gui.draw(canvas);
			
			if(env.blanc>0.0)
				env.drawBlanc(canvas);
			
			if(debugInfoTgl)
				canvas.draw(debugInfoText);
				
			canvas.unlock();
			//backBitmap.visible = true;
        }
        
        private function setState(newState:int):void
        {
        	state = newState;
        }
        
        private function newGame():void
        {
        	gameSave.reset();
        	startLevel();
        }
        
        public function startLevel():void
        {
        	levelMenu.go(gui);
        	gameState.assign(gameSave);
        	level.start();
        	setState(LEVEL);
        	inGame = true;
        }
        
        public function save():void
        {
        	gameSave.assign(gameState);
        }
		
		public function updateFPS(fps:int):void
		{
			if(debugInfoTgl)
				debugInfoText.text = fps.toString();
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			var code:uint = e.keyCode;
			
			if(code==0x70)
				debugInfoTgl = !debugInfoTgl;
			else
			{
				if(state==LEVEL)
					level.keyDown(code);
				if(gui.current==descScreen && (code==0x1B || code==0x0D))
					descScreen.back();
			}
		}
	
		public function keyUp(e:KeyboardEvent):void
		{
			var code:uint = e.keyCode;
			
			if(state==LEVEL)
				level.keyUp(code);
		}
		
		public function changeRes():void
		{
			hires = !hires;
			if(hires)
				device.quality = 0;
			else
				device.quality = 2;
			
			mainMenu.refreshRes(this);
			level.env.blanc = 1.0;
		}
		
		public function changeMute():void
		{
			mute = !mute;
			if(mute)
				SoundMixer.soundTransform = new SoundTransform(0.0);
			else
				SoundMixer.soundTransform = new SoundTransform(1.0);
			mainMenu.refreshVol(this);
		}
		
		public function clickNewGame():void
		{
			if(inGame)
			{
				level.setPause(false);
				levelMenu.go(gui);
			}
			else
			{
				newGame();
			}
		}
		
		public function goPause():void
		{
			level.setPause(true);
			mainMenu.go();
			mainMenu.refreshInGame(this);
		}
		
		public function goHelp():void
		{
			descScreen.go(0);
		}
		
		public function goNextLevel():void
		{
			level.nextLevel();
		}
		
		public function goCredits():void
		{
			if(inGame)
			{
				updateResults();
				state = MENU;
				inGame = false;
				if(gui.current!=mainMenu)
					gui.current = mainMenu;
				mainMenu.refreshInGame(this);
				level.env.blanc = 1.0;
				level.progress.end();
			}
			else descScreen.go(1);
		}
		
		public function updateResults():void
		{
			var finish:Boolean = false;
			if(level.stage!=null)
			{
				finish = gameState.level>=level.stagesCount-1 && level.stage.win;
			}
			if(gameState.scores>=maxScores)
			{
				if(gameState.scores==maxScores && finish)
					maxScoresFinish = true;
				else
					maxScoresFinish = finish;
					
				maxScores = gameState.scores;
			}
			lastScores = gameState.scores;
			lastScoresFinish = finish;
			mainMenu.updateScores();
		}
		
		public function showHighScores():void {scoresTable.showScores();}
		public function submitHighScores():void {scoresTable.submitScores();}
		
		public function goSp():void	{navigateToURL(new URLRequest("http://www.gameshed.com/"), "_blank");}

	}
	
}
