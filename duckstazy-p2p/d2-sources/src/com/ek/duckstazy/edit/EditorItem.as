package com.ek.duckstazy.edit
{
	import com.ek.duckstazy.game.CameraLayer;
	import com.ek.duckstazy.game.base.Actor;

	import flash.display.Sprite;


	/**
	 * @author eliasku
	 */
	public class EditorItem
	{
		private var _actor:Actor;
		private var _sprite:Sprite;
		private var _layer:CameraLayer;

		public function EditorItem(target:Object = null)
		{
			this.target = target;
		}

		public function get actor():Actor
		{
			return _actor;
		}

		public function set target(value:Object):void
		{
			_actor = value as Actor;
			_sprite = value as Sprite;
			_layer = value as CameraLayer;
		}

		public function get sprite():Sprite
		{
			return _sprite;
		}
		
		public function get label():String
		{
			if(_layer)
				return 'LAYER: ' + _layer.name;
			else if(_actor)
			{
				if(_actor.type)
					return _actor.type.toLocaleUpperCase() + ': ' + _actor.name;
			}
			else if(_sprite)
				return '_SPRITE: ' + _sprite.name;
				
			return 'null';
		}

		public function get layer():CameraLayer
		{
			return _layer;
		}
		
	}
}
