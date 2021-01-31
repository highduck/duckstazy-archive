package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.audio.AudioLazy;

	import flash.display.Sprite;

	public class Door extends Actor
	{
		private var _id:int;
		private var _sprite:Sprite = new Sprite();
		private var _opened:Boolean;
		
		public function Door(level:Level)
		{
			super(level);
			
			_sprite.mouseChildren = false;
			_sprite.mouseEnabled = false;
			
			content.addChild(_sprite);
		}
		
		public override function loadProperties(xml:XML):void
		{
			super.loadProperties(xml);
			
			if(xml.hasOwnProperty("@id")) _id = xml.@id;
			
			redrawDoor();
		}
		
		//
		private function redrawDoor():void
		{
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(2, Player.COLORS[_id]);
			
			if(_opened)
			{
				_sprite.graphics.beginFill(0x000000);
				_sprite.graphics.drawRect(0, 0, width, height);
				_sprite.graphics.endFill();
			}
			else
			{
				_sprite.graphics.drawRect(0, 0, width, height);
			}
		}
		
		public override function saveProperties(xml:XML):void
		{
			super.saveProperties(xml);
			
			xml.@id = _id;
		}

		public function get id():int
		{
			return _id;
		}
		
		public function onCheckOpen():void
		{
			var result:Boolean;
			var lock:House = House.getHouse(scene, _id);
			
			if(lock)
				result = (lock.buns.length >= 4);
				
			if(result != _opened)
			{
				if(result)
				{
					AudioLazy.playAt("sfx_door_open", x, y);
				}
				else
				{
					AudioLazy.playAt("sfx_door_close", x, y);
				}
				
				_opened = result;
				redrawDoor();
			}
		}
		
		public static function getDoor(scene:LevelScene, id:int):Door
		{
			var actor:Actor;

			for each (actor in scene.actors)
			{
				if(actor is Door && (actor as Door)._id == id)
					return actor as Door;
			}
			
			return null;
		}

		public function get opened():Boolean
		{
			return _opened;
		}
	}
}
