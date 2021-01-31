package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.base.Actor;

	import flash.display.Sprite;

	/**
	 * @author eliasku
	 */
	public class House extends Actor
	{
		private var _id:int;
		private var _sprite:Sprite = new Sprite();
		private var _buns:Vector.<Bun> = new Vector.<Bun>();
		private var _queueDir:int = 1;
		
		public function House(level:Level)
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
			if(xml.hasOwnProperty("@qdir")) _queueDir = xml.@qdir;
			
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(2, 0xffffff, 0.7);
			_sprite.graphics.beginFill(Player.COLORS[_id], 0.2);
			_sprite.graphics.drawRect(0, 0, width, height);
			_sprite.graphics.endFill();
		}
		
		public override function saveProperties(xml:XML):void
		{
			super.saveProperties(xml);
			
			xml.@id = _id;
			xml.@qdir = _queueDir;
		}
		
		public function onPickUp(bun:Bun):void
		{
			_buns.push(bun);
			bun.onHouseEnter(this);
			updateBunsPositions();
			
			if(_buns.length >= 4)
			{
				//Game.instance.endLevel();
			}
			
			var door:Door = Door.getDoor(scene, _id);
			if(door)
				door.onCheckOpen();
		}
		
		public function onStealFrom(other:House):void
		{
			var bun:Bun;
			
			if(other.buns.length > 0)
			{
				bun = other.buns[0];
				
				bun.onHouseExit();
				onPickUp(bun);
			}
		}

		public function onDropOut(bun:Bun):void
		{
			var i:int = _buns.indexOf(bun);
			if(i >= 0)
			{
				_buns.splice(i, 1);
				updateBunsPositions();
			}
			
			var door:Door = Door.getDoor(scene, _id);
			if(door)
				door.onCheckOpen();
		}
		
		private function updateBunsPositions():void
		{
			var i:int;
			if(_queueDir < 0) i = 3;
			for each (var bun:Bun in _buns)
			{
				bun.vx = 0.0;
				bun.vy = 0.0;
				bun.x = x + 10.0 + i*int((width-30.0)/3.0);
				bun.y = y + height - 20.0;
				bun.updateTransform();
				i += _queueDir;
			}
		}
		
		public static function getHouse(scene:LevelScene, id:int):House
		{
			var actor:Actor;
			
			for each (actor in scene.actors)
			{
				if(actor is House && (actor as House)._id == id)
					return actor as House;
			}
			
			return null;
		}

		public function get buns():Vector.<Bun>
		{
			return _buns;
		}

		public function get id():int
		{
			return _id;
		}
	}
}
