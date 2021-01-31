package com.ek.duckstazy.ui
{
	import com.ek.duckstazy.game.Game;
	import com.ek.library.core.CoreKeyboardEvent;
	import com.ek.library.core.CoreManager;
	import com.ek.library.gocs.GameObject;

	/**
	 * @author eliasku
	 */
	public class Menu extends GameObject
	{
		private var _currentScreen:MenuScreen;
		
		private var _screens:Object = {};
		
		public function Menu()
		{
			CoreManager.addEventListener(CoreKeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(e:CoreKeyboardEvent):void
		{
			if(_currentScreen) _currentScreen.onKeyDown(e);
		}
		
		public function addScreen(screen:MenuScreen):void
		{
			_screens[screen.id] = screen;
		}
		
		private function openScreen(screen:MenuScreen):void
		{
			if(_currentScreen)
			{
				removeChild(_currentScreen);
				_currentScreen.onClose();
				_currentScreen = null;
			}
			
			if(screen)
			{
				addChild(screen);
				_currentScreen = screen;
				screen.onOpen();
				Game.input.resetFocus();
			}
		}
		
		public function open(id:String):void
		{
			var screen:MenuScreen;
			
			if(_screens.hasOwnProperty(id))
			{
				screen = _screens[id];
				openScreen(screen);
			}
		}
		
		public function close():void
		{
			openScreen(null);
		}
		
		public function getScreen(id:String):MenuScreen
		{
			if(_screens.hasOwnProperty(id))
				return _screens[id];
			return null;
		}

	}
}
