package com.ek.duckstazy.game.base
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.actors.Block;
	import com.ek.duckstazy.game.actors.Bonus;
	import com.ek.duckstazy.game.actors.BoxObstacle;
	import com.ek.duckstazy.game.actors.Bun;
	import com.ek.duckstazy.game.actors.Door;
	import com.ek.duckstazy.game.actors.House;
	import com.ek.duckstazy.game.actors.Jumper;
	import com.ek.duckstazy.game.actors.Spikes;
	import com.ek.duckstazy.game.actors.StartPoint;
	/**
	 * @author eliasku
	 */
	public class ActorFactory
	{
		private static var _registry:Object = new Object();
		
		public static function register(type:String, cls:Class):void
		{
			_registry[type] = cls;
		}
		
		public static function load(xml:XML, level:Level):Actor
		{
			var result:Actor;
			var type:String;
			
			if(level && xml && xml.hasOwnProperty("@type"))
			{
				type = xml.@type;
				result = create(type, level);
				
				if(result)
					result.loadProperties(xml);
			}
			
			return result;
		}
		
		public static function create(type:String, level:Level):Actor
		{
			var cls:Class;
			var result:Actor;
			
			if(_registry.hasOwnProperty(type))
			{
				cls = _registry[type];
			
				if(cls)
				{
					result = new cls(level);
					if(result)
					{
						result.type = type;
					}
				}
			}
			
			return result;
		}

		public static function initialize():void
		{
			ActorFactory.register("block", Block);
			ActorFactory.register("spikes", Spikes);
			ActorFactory.register("obs", BoxObstacle);
			ActorFactory.register("jumper", Jumper);
			ActorFactory.register("bun", Bun);
			ActorFactory.register("house", House);
			ActorFactory.register("block", Block);
			ActorFactory.register("start_point", StartPoint);
			ActorFactory.register("bonus", Bonus);
			ActorFactory.register("door", Door);
		}
		
		
	}
}
