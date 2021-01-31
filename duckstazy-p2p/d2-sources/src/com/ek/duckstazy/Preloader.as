package com.ek.duckstazy
{
	import com.ek.duckstazy.game.Config;
	import com.ek.library.asset.AssetLoader;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.core.CoreManager;
	import com.ek.library.debug.Console;
	import com.ek.library.debug.Logger;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;





	/**
	 * @author eliasku
	 */
	public class Preloader extends MovieClip 
	{
		
        
		private static const ASSET_URL:String = "asset";
		
		private static const ASSETS:Object = 
		{
			"asset":"asset.xml"
		};
		
		private var _preloader:PreloaderProto;
		
		private var _descriptionLoader:AssetLoader;
        private var _descriptionLoaded:Boolean;
		
		private var _assetLoader:AssetLoader;
        private var _assetLoaded:Boolean;
        		
		public function Preloader()
		{
			super();
			stop();
			
			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			else
				onAddedToStage(null);
				
			Fonts.register();
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var flashVars:Object = stage.loaderInfo.parameters;
						
			CoreManager.initialize(stage);
			Console.createProxy("Game", 640, 384, false);
		
			AssetManager.initialize();
			Logger.throwErrors = true;
			
			if(flashVars.hasOwnProperty("asset_url"))
				AssetManager.assetURL = flashVars["asset_url"];
			else
				AssetManager.assetURL = ASSET_URL;
				
			if(flashVars.hasOwnProperty("ac"))
				AssetManager.antiCacheVersion = flashVars.ac;
				
			if(flashVars.hasOwnProperty("stat_ssid") && flashVars.hasOwnProperty("stat_url"))
				StatService.initialize(flashVars.stat_url, flashVars.stat_ssid);
				

			/*** Создаём прелоадер и выбираем сплеш для загрузки ***/
			_preloader = new PreloaderProto(this);
			_preloader.x = Config.WIDTH * 0.5;
			_preloader.y = Config.HEIGHT * 0.5;
			
			/*** Создаём запрос на загрузку ресурсов ***/
			for (var name:String in ASSETS)
				AssetManager.add(name, ASSETS[name]);
				
			_descriptionLoader = AssetManager.load();
			_descriptionLoader.addEventListener(Event.COMPLETE, onDescriptionLoaded);
			_descriptionLoader.load();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onDescriptionLoaded(event:Event):void 
		{
			_descriptionLoaded = true;
			_descriptionLoader = null;
			
			for (var name:String in ASSETS)
			{
				AssetManager.addFromXML( AssetManager.getXML(name) );
				AssetManager.remove(name);
			}
			
			_assetLoader = AssetManager.load();
			if(_assetLoader)
			{
				_assetLoader.addEventListener(Event.COMPLETE, onAssetLoaded);
				_assetLoader.load();
			}
			else
			{
				onAssetLoaded(null);
			}
		}
		
		private function onEnterFrame(event:Event):void 
		{
			var bytesLoaded:uint = root.loaderInfo.bytesLoaded;
			var bytesTotal:uint = root.loaderInfo.bytesTotal;
			var baseProgress:Number = 0.0;
			var assetProgress:Number = 0.0;
			var progress:Number = 0.0;
			
			if(_assetLoader)
				assetProgress = _assetLoader.progress;
			
			if(_assetLoaded)
				assetProgress = 1.0;
				
			if(bytesTotal > 0)
				baseProgress = Number(bytesLoaded / bytesTotal);
				
			progress = 0.5*(assetProgress + baseProgress);
			
			_preloader.onProgressChanged(progress);
			
			if(_assetLoaded && bytesLoaded >= bytesTotal)
			{
				stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				start();
			}
		}
		
		private function onAssetLoaded(e:Event):void
		{
			_assetLoaded = true;
			_assetLoader = null;
		}		

		private function start():void
        {
			nextFrame();
            
            var main:DisplayObject;
            var mainCls:Class = getDefinitionByName("com.ek.duckstazy.Main") as Class;
            main = new mainCls() as DisplayObject;
            main.addEventListener("initialization_ok", onInitComplete);
            main.addEventListener("initialization_error", onInitError);
            stage.addChildAt(main, 0);
            
            _preloader.onStart();
		}

		private function onInitError(e:Event):void 
		{
			_preloader.onError();
		}

		private function onInitComplete(e:Event):void 
		{
			if(parent)
				parent.removeChild(this);
		}
	}
}
