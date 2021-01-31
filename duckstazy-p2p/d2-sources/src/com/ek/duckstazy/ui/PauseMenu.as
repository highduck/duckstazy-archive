package com.ek.duckstazy.ui
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.Game;
	import com.ek.library.core.CoreKeyboardEvent;
	import com.ek.library.core.CoreManager;

	import flash.events.Event;
	import flash.ui.Keyboard;


	public class PauseMenu extends MenuScreen
	{
		private var _panel:Panel;
		
		private var _btnResume:PushButton;
		private var _btnExit:PushButton;
		
		public function PauseMenu()
		{
			super("pause");
			
			const startY:int = Config.HEIGHT*0.5 - 100;
			
			_panel = new Panel(null, 0, startY);
			_panel.setSize(Config.WIDTH, 200);
			addChild(_panel);
			
			_btnResume = new PushButton(_panel, Config.WIDTH*0.5 - 200, 20, "RESUME", onResume);
			_btnExit = new PushButton(_panel, Config.WIDTH*0.5 - 100, 100, "END GAME", onExit);
			
			CoreManager.addEventListener(CoreKeyboardEvent.KEY_DOWN, onPause);
		}

		private function onPause(e:CoreKeyboardEvent):void
		{
			if(e.code == Keyboard.ESCAPE && Game.currentLevel)
			{
				if(Game.currentLevel.paused)
					Game.currentLevel.resume();
				else
					Game.currentLevel.pause();
			}
		}

		private function onExit(e:Event):void
		{
			Game.currentLevel.exit();
			Game.menu.open("main_menu");
		}

		private function onResume(e:Event):void
		{
			Game.currentLevel.resume();
		}

	}
}
