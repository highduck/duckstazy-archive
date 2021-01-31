package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.base.ActorFactory;
	import com.ek.duckstazy.ui.MainMenu;
	import com.ek.duckstazy.ui.Menu;
	import com.ek.duckstazy.ui.PauseMenu;
	import com.ek.duckstazy.ui.SelectLevelMenu;
	import com.ek.duckstazy.ui.VersusCompleteMenu;
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.core.CoreManager;
	import com.ek.library.debug.Console;
	import com.ek.library.gocs.GameObject;

	import flash.display.StageQuality;
	import flash.geom.Rectangle;










	/**
	 * @author eliasku
	 */
	public class Game extends GameObject 
	{
		private static var _instance:Game;
		
		private static var _menu:Menu;
		private static var _input:Input;
		private static var _currentLevel:Level;
		
		private static var _dt:Number = 0.0;
		
		private static var _prevReplay:Replay;
		
		
	
		public function Game()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_instance = this;
			
			ActorFactory.initialize();
			
			_menu = new Menu();
			addChild(_menu);
			
			_menu.addScreen(new MainMenu());
			_menu.addScreen(new PauseMenu());
			_menu.addScreen(new SelectLevelMenu());
			_menu.addScreen(new VersusCompleteMenu());
			
			_menu.open("main_menu");
		}
		
		public function startPrevReplay():void
		{
			if(_prevReplay)
			{
				startLevel( LevelUtil.createReplayLevel(_prevReplay) );
			}
		}
		
		public function endLevel():void
		{
			if(_currentLevel.replay)
			{
				_prevReplay = _currentLevel.replay;
			}
			
			if(_currentLevel && _currentLevel.parent)
			{
				_currentLevel.parent.removeChild(_currentLevel);
				_currentLevel = null;
			}
		}
		
		public function startLevel(level:Level):void
		{
			_menu.close();
			
			level.start();
			addChildAt(level, 0);
			_currentLevel = level;
			_input.resetFocus();
		}
		
		public override function tick(dt:Number):void
		{
			_dt = (CoreManager.rawDeltaTime / 1000.0);
			
			super.tick(_dt);
			
			if(_currentLevel)
			{
				_currentLevel.update();
			}
			
			P2PManager.instance.update();
		}
		
		public static function create():void
		{			
			CoreManager.stage.quality = StageQuality.BEST;
			
			CoreManager.stage.fullScreenSourceRect = new Rectangle(0, 0, Config.WIDTH, Config.HEIGHT);
			
			XRandom.shuffle();
			
			_input = new Input();
			
			_instance = new Game();
			CoreManager.root.addChildAt(_instance, 0);

			Console.proxy.addCommand("speed", "Game speed [time_mod]", onTimeMod);
		}

		private static function onTimeMod(value:Number):void
		{
			if(_currentLevel)
			{
				_currentLevel.timeMod = value;
			}
		}
		
		public static function get input():Input
		{
			return _input;
		}
		
		public static function get dt():Number
		{
			return _dt;
		}

		public static function get currentLevel():Level
		{
			return _currentLevel;
		}

		static public function get instance():Game
		{
			return _instance;
		}

		static public function get menu():Menu
		{
			return _menu;
		}

	}
}
