package ui
{
	import ek.sui.SUIImage;
	import ek.sui.SUIScreen;
	import ek.sui.SUISystem;
	
	import flash.display.BitmapData;
	
	public class LevelMenu extends SUIScreen
	{
		private var title:SUIImage;
		
		private var btnUpgradeImgs:Array;
		private var btnGameMenuImgs:Array;
		
		private var btnGameMenu:DefaultButton;
		private var btnUpgrade:DefaultButton;
		private var btnRestart:DefaultButton;
		public var btnSubmit:DefaultButton;
		private var btnSp:DefaultButton;
		
		private var game:Game;
		
		private var media:UIMedia;
        
		public function LevelMenu(_game:Game)
		{
			game = _game;
			media = game.uiMedia;
			
			super();
			
			title = new SUIImage();
			title.y = 410.0;
			
			btnGameMenu = media.createDefaultButton(media.imgBtnGameMenu);
			btnUpgrade = media.createDefaultButton(media.imgBtnUpgrade);
			btnRestart = media.createDefaultButton(media.imgBtnRestart);
			btnSubmit = media.createDefaultButton(media.imgBtnSubmit);
			btnSp = media.createDefaultButton(media.imgBtnSpGray);
			
			btnUpgrade.x = 5+(122+5);
			btnUpgrade.y = 450;
			btnUpgrade.callback = game.level.goUpgradeMenu;
			
			btnRestart.x = 5+2*(122+5);
			btnRestart.y = 450;
			btnRestart.callback = game.startLevel;
			
			btnGameMenu.x = 5;
			btnGameMenu.y = 450;
			btnGameMenu.callback = game.goPause;
			
			btnSubmit.x = 5+3*(122+5);
			btnSubmit.y = 450;
			btnSubmit.callback = submit;
			
			btnSp.x = 640-5-122;
			btnSp.y = 450;
			btnSp.callback = game.goSp;
			
			add(btnSp);
			add(btnUpgrade);
			add(btnGameMenu);
			add(btnSubmit);
			add(btnRestart);
			add(title);
			
		}
		
		public function go(gui:SUISystem):void
		{
			//setState(0);
			gui.setCurrent(this);
		}
		
		public function setState(state:int):void
		{
			switch(state)
			{
				case 0:
					btnSubmit.visible = false;
					btnSubmit.enabled = false;
					btnRestart.visible = false;
					btnRestart.enabled = false;
					btnUpgrade.visible = true;
					btnUpgrade.enabled = true;
					btnGameMenu.visible = true;
					btnGameMenu.enabled = true;
					break;
				case 1:
					btnSubmit.visible = false;
					btnSubmit.enabled = false;
					btnRestart.visible = false;
					btnRestart.enabled = false;
					btnUpgrade.visible = true;
					btnUpgrade.enabled = true;
					btnGameMenu.visible = true;
					btnGameMenu.enabled = true;

					break;
				case 2:
					btnSubmit.visible = game.gameState.scores>0;
					btnSubmit.enabled = game.gameState.scores>0;
					btnRestart.visible = true;
					btnRestart.enabled = true;
					btnUpgrade.visible = false;
					btnUpgrade.enabled = false;
					btnGameMenu.visible = true;
					btnGameMenu.enabled = true;
					break;
			}
		}
		
		public function submit():void
		{
			game.submitHighScores();
			btnSubmit.visible = false;
			btnSubmit.enabled = false;
		}
		
	}
}