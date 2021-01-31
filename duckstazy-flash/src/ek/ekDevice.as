package ek
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	public class ekDevice
	{
		public static const instance:ekDevice = new ekDevice();
		
		// Главный объект сцены.
		// Устанавливается в ekLoader.
		public var stage:Stage;
		
		// Абсолютное значение времени с запуска флешки
		private var last:int;
		
		// Время с предыдущей отрисовки в секундах
		public var dt:Number;
		
		// function blabla(fps:int):void;
		public var callbackFPS:Function;
		
		// счётчик кадров
		private var fps:int;
		
		// счёткик обновления
		private var fpsCounter:int;
		
		// Качество изображения
		// 0 - самое лучшее, 2 - самое галимое.
		private var stageQuality:int;
		public function get quality():int { return stageQuality; }
		public function set quality(_quality:int):void
		{
			var value:String;
			
			switch(_quality)
			{
				case 0:
					value = StageQuality.HIGH;
					break;
				case 1:
					value = StageQuality.MEDIUM;
					break;
				case 2:
					value = StageQuality.LOW;
					break;
			}
						
			stage.quality = value;
			stageQuality = _quality;
		}
		
		public var listener:ekIListener;

		public function ekDevice() {}
		
		public function run(_stage:Stage):void
		{
			// Настройки стейджа
			stage = _stage;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            // Прослушиваем события
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onRender);//, false, int.MAX_VALUE, true);
		}
		
		public function resetTimer():void
		{
			last = getTimer();
			dt = 0.001;
	
			fps = 0;
			fpsCounter = 0;
		}

		public function onRender(e:Event):void
        {
        	var now:int = getTimer();
			var ms:int = now - last;
			
			last = now;
			dt = ms*0.001;
			
			if(ms>300) dt = 0.3;
			//else if(ms<=0) dt = 0.001;

			/*if(callbackFPS!=null)
			{
				fpsCounter-=ms;
				fps++;
				if(fpsCounter<=0)
				{
					callbackFPS(fps);
					fpsCounter+=1000;
					fps = 0;
				}
			}*/
			
        	if(listener!=null)
        		listener.frame(dt);
        }
        
		public function onKeyDown(e:KeyboardEvent):void
		{
			if(listener!=null) listener.keyDown(e);
		}
	
		public function onKeyUp(e:KeyboardEvent):void
		{
			if(listener!=null) listener.keyUp(e);
		}

	}
}