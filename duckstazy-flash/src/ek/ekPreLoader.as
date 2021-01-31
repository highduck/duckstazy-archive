package ek
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	
	public class ekPreLoader extends MovieClip implements ekIListener
	{
		// Массив с разрешёнными доменами запуска флешки.
		// Чтобы проверить разрешен ли ваш домен, см. checkURL()
		protected const urlsAllowed:Array = new Array();
		protected var offlineAllowed:Boolean;
		
		// Имя главного входного класса.
		protected var mainClassName:String;
		
		// ekDevice
		public var device:ekDevice;
		
		// Состояние загрузки [0;1]
		public var progress:Number;
		
		// Загрузка завершена
		public var completed:Boolean;
		
		// В конструкторе дочернего класса вызываем super() первым делом 
		public function ekPreLoader()
		{
			device = ekDevice.instance;
			device.run(stage);
            stop();
            progress = 0;
            completed = false;
		}
		
		// Проверка домена (site-lock)
		//
		// returned values:
		// true - домен в списке разрешенных
		// false - домен запрещен
		protected function checkLock():Boolean
		{
			var allowed:Boolean = false;
			var url:String = stage.loaderInfo.url;
			var urlStart:int = url.indexOf("://")+3;
			var urlEnd:int = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			var lastDot:int = domain.lastIndexOf(".")-1;
			var domEnd:int = domain.lastIndexOf(".", lastDot)+1;
			
			domain = domain.substring(domEnd, domain.length);
			
			for each(var x:String in urlsAllowed)
				if(x==domain)
					allowed = true;
					
			if(!allowed && offlineAllowed)
				allowed = (url.substr(0, 4)=="file");

			return allowed;
		}
		
		// Обновить состояние загрузки (progress, completed)
		public function updateProgress():void
        {
        	progress = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
        	
            if(!completed && framesLoaded==totalFrames && progress>=1)
            {
              	completed = true;
               	onComplete();
            }
        }
        
        // СОБЫТИЕ: загрузка завершена.
        protected function onComplete():void
        {
        	
        }
        
        protected function createMainClass():void
        {
        	 // Переходим на 2ой фрейм, перед тем как создавать главный класс..
            nextFrame();
            
        	// Рефлексия, специально для того, чтобы не связывать фреймы.
            var mainCls:Class = Class(getDefinitionByName(mainClassName));
            
            // Запускаем главный класс.
            var main:Object = new mainCls();
               
        }
        
        // Обычное обновление прогресс бара
        public function frame(dt:Number):void
        {
	       	var gr:Graphics = this.graphics;

            gr.clear();
            gr.beginFill(0x000000);
            gr.drawRect(0, stage.stageHeight / 2 - 10, stage.stageWidth * progress, 20);
            gr.endFill();
        }
        
        public function keyDown(event:KeyboardEvent):void {}
		public function keyUp(event:KeyboardEvent):void {}
	}
}