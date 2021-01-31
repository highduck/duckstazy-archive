package com.ek.library.audio
{
	import com.ek.library.asset.AssetLoader;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.debug.Logger;
	import flash.media.Sound;
	import flash.media.SoundTransform;

	
	/**
	 * @author eliasku
	 */
	public class AudioLazy
	{
		private static var _loaders:Object = new Object();
		
		private static function playItem(item:String, transform:SoundTransform):void
		{
			var st:int;
			var sfx:Sound;
			var loader:AssetLoader;
			
			if(transform)
			{
				st = AssetManager.getItemStatus(item);
				
				if(st & AssetManager.ITEM_FOUND)
				{
					if(st & AssetManager.ITEM_READY)
					{
						sfx = AssetManager.getSound(item);
					}
					else
					{
						if(!_loaders.hasOwnProperty(item))
						{
							loader = AssetManager.load([item]);
							loader.load();
							_loaders[item] = loader;
						}
					}
				}
				
				if(sfx)
				{
					try
					{
						sfx.play(0.0, 0, transform);
					}
					catch(e:Error)
					{
						Logger.warning("[AudioLazy] " + e.message);
					}
				}
			}
		}
		
		public static function play(item:String, volume:Number = 1.0, pan:Number = 0.0):void
		{
			var st:SoundTransform = AudioManager.getSoundTransform(volume, pan);
			
			if(st)
			{
				playItem(item, st);
			}
		}
		
		public static function playAt(item:String, x:Number, y:Number, volume:Number = 1.0, pan:Number = 0.0):void
		{
			var st:SoundTransform = AudioManager.getPanorama(x, y, volume, pan);
			
			if(st)
			{
				playItem(item, st);
			}
		}
	}
}
