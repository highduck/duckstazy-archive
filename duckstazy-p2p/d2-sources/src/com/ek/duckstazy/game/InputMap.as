package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.actors.Player;
	/**
	 * @author eliasku
	 */
	public class InputMap
	{
		public static const KEY_UP:int = 0x1;
		public static const KEY_PRESSED:int = 0x2;
		public static const KEY_DOWN:int = 0x4;
		
		private var _keys:Object = {};
		
		public function InputMap()
		{
			
		}
		
		public function clear():void
		{
			_keys = {};
		}
		
		public function addKey(name:String, code:uint):void
		{
			var key:InputKey = new InputKey();
			key.name = name;
			key.code = code;
			_keys[name] = key;
		}
		
		public function readFromInput(input:Input):void
		{
			var key:InputKey;
			var name:String;
			
			for (name in _keys)
			{
				key = _keys[name];
				key.state = 0x0;
				
				if(input.getKey(key.code)) key.state |= InputMap.KEY_PRESSED;
				if(input.getKeyDown(key.code)) key.state |= InputMap.KEY_DOWN;
				if(input.getKeyUp(key.code)) key.state |= InputMap.KEY_UP;
			}
		}
		
		public function getKey(id:String):Boolean
		{
			if(_keys.hasOwnProperty(id))
				return (_keys[id].state & KEY_PRESSED) > 0;
			
			return false;
		}
		
		public function getKeyDown(id:String):Boolean
		{
			if(_keys.hasOwnProperty(id))
				return (_keys[id].state & KEY_DOWN) > 0;
			
			return false;
		}
		
		public function getKeyUp(id:String):Boolean
		{
			if(_keys.hasOwnProperty(id))
				return (_keys[id].state & KEY_UP) > 0;
				
			return false;
		}
		
		public function serialize():Object
		{
			var map:Object = {};
			var key:InputKey;
			var name:String;
			
			for (name in _keys)
			{
				key = _keys[name];
				
				if(key.state > 0x0)
				{
					map[name] = key.state;
				}
			}
			
			return map;
		}
		
		public function deserialize(map:Object):void
		{
			var key:InputKey;
			var name:String;
			
			for (name in _keys)
			{
				key = _keys[name];
				key.state = 0x0;
				
				if(map && map.hasOwnProperty(name))
				{
					key.state = map[name];
				}
			}
		}
		
		
		public static const PLAYER_KEYS:Array = [Player.KEY_ID_UP, Player.KEY_ID_DOWN, Player.KEY_ID_RIGHT, Player.KEY_ID_LEFT, Player.KEY_ID_FIRE];
		public static function interpolate(map:Object):Object
		{
			var state:int;
			var name:String;
			
			for each (name in PLAYER_KEYS)
			{
				state = map[name];
				
				if((state & KEY_DOWN)>0)
				{
					map[name] = KEY_PRESSED;
				}
				
				if((state & KEY_UP)>0)
				{
					map[name] = 0;
				}
			}
			
			return map;
		}
		
		public static function smooth(start:Object, end:Object):Object
		{
			var s1:int;
			var s2:int;
			var name:String;
			
			for each (name in PLAYER_KEYS)
			{
				s1 = start[name];
				s2 = end[name];
				
				if( (s1 & KEY_PRESSED) > 0 && (s2 & KEY_PRESSED) == 0 )
				{
					end[name] |= KEY_UP;
				}
				
				if( (s1 & KEY_PRESSED) == 0 && (s2 & KEY_PRESSED) > 0 )
				{
					end[name] |= KEY_DOWN;
				}
			}
			
			return end;
		}
		
		public static function clone(obj:Object):Object
		{
			var name:String;
			var result:Object = {};
			
			for (name in obj)
			{
				result[name] = obj[name];
			}
			
			return result;
		}

		public static function equal(a:Object, b:Object):Boolean
		{
			var name:String;
			var k1:int;
			var k2:int;
			
			for each (name in PLAYER_KEYS)
			{
				k1 = a[name];
				k2 = b[name];
				
				if(k1 != k2)
				{
					if(k1 == (KEY_DOWN | KEY_PRESSED) && k2 == KEY_PRESSED)
					{
						
					}
					else if(k1 == KEY_UP && k2 == 0)
					{
						
					}
					else
					{
						return false;
					}
				}
			}
			
			return true;
		}
	}
}

class InputKey
{
	public var name:String;
	public var state:int;
	public var code:uint;
}