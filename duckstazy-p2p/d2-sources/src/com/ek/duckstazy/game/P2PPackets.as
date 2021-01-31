package com.ek.duckstazy.game
{
	public class P2PPackets
	{
		public static function compressTicks(ticks:Array):Array
		{
			var result:Array = [];
			var tick:Object;
			
			result.push(ticks[0].seq);
			
			for each(tick in ticks)
			{
				result.push(compressInputMapObject(tick.input0));
				result.push(compressInputMapObject(tick.input1));
			}
			
			return result;
		}
		
		public static function uncompressTicks(data:Array):Array
		{
			var ticks:Array = [];
			var cseq:int = data[0];
			var i:int = 1;
			
			while(i < data.length)
			{
				ticks.push({seq:cseq, input0:uncompressInputMapObject(data[i]), input1:uncompressInputMapObject(data[i+1])});
				++cseq;
				i+=2;
			}
			
			return ticks;
		}
		
		public static function compressInputPacket(map:Object):Array
		{
			return [compressInputMapObject(map), map.seq, map.frame];
		}
		
		public static function uncompressInputPacket(data:Array):Object
		{
			var result:Object = uncompressInputMapObject(data[0]);
		
			result.seq = data[1];
			result.frame = data[2];
			
			return result;
		}
		
		public static function compressInputMapObject(map:Object):int
		{
			var key:String;
			var keyState:int;
			var inputMask:int;
			var inputPos:int;
			
			for each (key in InputMap.PLAYER_KEYS)
			{
				if(map && map.hasOwnProperty(key))
					keyState = map[key] & 0x7;
				else
					keyState = 0;
				
				inputMask |= (keyState << inputPos);
				inputPos += 3;
			}
			
			return inputMask;
		}
		
		public static function uncompressInputMapObject(code:int):Object
		{
			var result:Object = {};
			var key:String;
			var keyState:int;
			var inputPos:int;
			
			for each (key in InputMap.PLAYER_KEYS)
			{
				keyState = (code >> inputPos) & 0x7;
				
				if(keyState > 0)
					result[key] = keyState;
					 
				inputPos += 3;
			}
			
			return result;
		}
	}
}
