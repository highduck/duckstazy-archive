package
{
	import ek.ekPreLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.core.SpriteAsset;
    
    public class PreLoader extends ekPreLoader
	{
		//private const ad:ekMochiAd = new ekMochiAd();
		[Embed(source="gfx/font.ttf", fontName="_default")]
        private var rDefaultFnt:Class;
		
		[Embed(source="gfx/mini.ttf", fontName="_mini")]
        private var rMiniFnt:Class;
        
       
        
		public var fakeProgress:Number;
		public var commonProgress:Number;
		public var t:Number;
		public var pulse:Number;
		public var pulsePause:Number;
		public var spC:Number;
		public var pause:Number;
		public var loaded:Boolean;
		
		public var mx:Number;
		public var my:Number;
		
		/*private const MATRIX:Matrix = new Matrix();
		private const DEF_BTN_RC:Rectangle = new Rectangle(3,3,116,22);
		private const WHITE_MASK:ColorTransform = new ColorTransform(1,1,1,1,255,255,255);
		private const RC:Rectangle = new Rectangle();
		private const POINT:Point = new Point();
		private const BLUR8:BlurFilter = new BlurFilter(4, 4, 8);*/
		
		private var PROGRESS_TEXT:String;
		
		public var tfLoading:TextField;
		public var tfProgress:TextField;
		public var filter:DropShadowFilter;
               
        public var imgProgress:BitmapData;
        public var imgLoading:BitmapData;
        
        public var imgProgressBmp:Bitmap;
        public var imgLoadingBmp:Bitmap;
        
        public var sp:SpriteAsset;
        public var spRC:Rectangle;
        
        public var mcLoading:MovieClip;
        
        public var shape:Shape;
		
		public function PreLoader()
		{
			super();
			
			mainClassName = "Game";
			
			// offline
			offlineAllowed = true;
			// аукцион
			//urlsAllowed.push("flashgamelicense.com");
			
			//if(checkLock())
			{
				stage.addChild(this);
				device.listener = this;
				gfxInit();

				/*ad.OPTIONS["res"] = width + "x" + height;
				ad.OPTIONS["id"] = "74e833da17589294"; 
				this.addChild(ad);
				ad.show();*/
			}				
		}
		
		public function gfxInit():void
		{
			new Resources();
			
			
			fakeProgress = 0;
			t = 0;
			pulse = 1;
			pulsePause = 0;
			spC= 1;
			pause= 2.5;
			loaded = false;
			
			filter = new DropShadowFilter(0.0, 0.0, 0x333333, 1, 6, 6, 8, 1);
			
			sp = Resources.instance.sprSp;
			
			sp.x = (640-sp.width)*0.5;
			sp.y = (480-sp.height)*0.5;
			sp.filters = [filter];

						
			tfLoading = new TextField();
 			tfLoading.defaultTextFormat = new TextFormat("_default", 30, 0xffffffff, false, null, null, null, null, TextFormatAlign.CENTER, null, null, null, -16);//20
 			tfLoading.embedFonts = true;
 			tfLoading.cacheAsBitmap = true;
 			tfLoading.selectable = false;
 			tfLoading.multiline = true;
 			tfLoading.autoSize = TextFieldAutoSize.LEFT;
 			tfLoading.filters = [filter];
 			tfLoading.text = "LOADING\nPLEASE WAIT"
 			tfLoading.x = (640-tfLoading.textWidth)*0.5;
 			tfLoading.y = 340;
  			
 			tfProgress = new TextField();
 			tfProgress.defaultTextFormat = new TextFormat("_default", 40, 0xffffffff, false, null, null, null, null, TextFormatAlign.LEFT);//20
 			tfProgress.embedFonts = true;
 			tfProgress.cacheAsBitmap = true;
 			tfProgress.selectable = false;
  			tfProgress.autoSize = TextFieldAutoSize.LEFT;
 			tfProgress.filters = [filter];
 			tfProgress.textColor = 0xffffff;
 			tfProgress.y = 400;

			shape = new Shape();
 			
 			mcLoading = new MovieClip();
 			mcLoading.addChild(shape);
 			mcLoading.addChild(tfProgress);
 			mcLoading.addChild(tfLoading);
 			mcLoading.addChild(sp);
 			
 			stage.addChild(mcLoading);
 			
 			spRC = sp.getRect(stage);
 			
 			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			
 		}
 		
 		public function gfxUpdate(dt:Number):void
		{
			if(!loaded && commonProgress>=1)
			{
				loaded = true;
				tfLoading.text = "LOADING\nCOMPLETED"
 				tfLoading.x = (640-tfLoading.textWidth)*0.5;
 				tfLoading.y = 340;
			}
			
			PROGRESS_TEXT = int(commonProgress*100).toString()+ "%";
		
			if(tfProgress.text!=PROGRESS_TEXT)
			{
				tfProgress.text = PROGRESS_TEXT;
				tfProgress.x = (640-tfProgress.textWidth)*0.5;
			}
			
			if(mx>spRC.x && mx<spRC.x+spRC.width && my>spRC.y && my<spRC.y+spRC.height)
			{
				if(spC<1)
				{
					spC+=dt*10;
					if(spC>1) spC = 1;
				}
			}
			else
			{
				if(spC>0)
				{
					spC-=dt*10;
					if(spC<0) spC = 0;
				}
			}
			
			t+=dt*20.0;
			if(t>80.0)
				t-=80.0;
			
			if(pulse>0)
			{
				pulse-=dt*2;
				if(pulse<0)
				{
					pulse = 0;
					pulsePause = 1;
				}
			}
			else
			{
				pulsePause-=dt;
				if(pulsePause<=0) pulse = 1;
			}
			
			if(!loaded)
			{
				tfProgress.textColor = utils.lerpColor(0x999999, 0xdddddd, pulse);
				tfLoading.textColor = utils.lerpColor(0x999999, 0xdddddd, pulse);
				
				filter.color = utils.lerpColor(0x333333, 0x555555, pulse);
				tfProgress.filters = [filter];
				tfLoading.filters = [filter];
			}
			else
			{
				pause-=dt;
				
				tfProgress.textColor = utils.lerpColor(0x999999, 0xffffff, pause/2.5);
				tfLoading.textColor = utils.lerpColor(0x999999, 0xffffff, pause/2.5);
				
				filter.color = utils.lerpColor(0x333333, 0x777777, pause/2.5);
				tfProgress.filters = [filter];
				tfLoading.filters = [filter];
			}
			
			filter.color = utils.lerpColor(0x333333, 0x555555, spC);
			sp.filters = [filter];
			
			var x:Number;
			var c:Boolean = false;
			var gr:Graphics = shape.graphics;
			
			gr.clear();
			gr.lineStyle();
			gr.beginFill(0x555555);
			gr.drawRect(0.0, 0.0, 640.0, 500.0);
			gr.endFill();
			
			x = -160.0+t;
			while(x<500.0)
			{
				gr.beginFill(0x333333);
				gr.moveTo(0.0, x);
				gr.lineTo(640.0, x+80.0);
				gr.lineTo(640.0, x+120.0);
				gr.lineTo(0.0, x+40.0);
				gr.endFill();
				
				c = !c;
				x+=80.0;
			}
 		}
 		

 		public function gfxDestroy():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			mcLoading.removeChild(sp);
			sp = null;
			
			mcLoading.removeChild(shape);
			shape = null;

			mcLoading.removeChild(tfProgress);
			tfProgress = null;
			
			mcLoading.removeChild(tfLoading);
			tfLoading = null;
			
			stage.removeChild(mcLoading);
			mcLoading = null;
			
			spRC = null;
			
 		}
		
        // СОБЫТИЕ: загрузка завершена.
		/*override protected function onComplete():void
        {
        	device.listener = null;
        	stage.removeChild(this);
        	
        	createMainClass();
        }*/
        
        override public function frame(dt:Number):void
        {
        	// Рисуем чисто по-дэфолту
        	// Рисуем до обновления, т.к. мы когда заканчиваем - сразу удаляемся
        	// это чисто для примера. На самом деле вы можете сколько угодно долго 
        	// держать окно прелоадера(например показывать рекламу или ждать пока 
        	// игрок кликнет Continue).
        	super.frame(dt);
        	
        	
        	// не рисуем автоматом, т.к. нужно ещё учитывать прогресс рекламы
        	/*var gr:Graphics = this.graphics;
        	gr.clear();
            gr.beginFill(0x000000);
            gr.drawRect(0, stage.stageHeight - 20, stage.stageWidth * progress * ad.progress, 20);
            gr.endFill();*/
        	
        	// Обновляем состояние прогресс бара.
        	this.updateProgress();
        	if(fakeProgress<1)
        	{
        		fakeProgress+=0.5*dt;
        		if(fakeProgress>1) fakeProgress = 1;
        	}
        	commonProgress = fakeProgress*progress;//*ad.progress;
        	gfxUpdate(dt);
        	
        	if(completed && commonProgress>=1 && pause<=0)// && ad.completed)
        	{
        		gfxDestroy();
        		device.listener = null;
        		stage.removeChild(this);

        		//this.removeChild(ad);
        	
        		createMainClass();
        	}
        } 
        
        public function mouseDown(event:MouseEvent):void
		{
			if(mx>sp.x && mx<sp.x+sp.width)
				if(my>sp.y && my<sp.y+sp.height)
					navigateToURL(new URLRequest("http://www.gameshed.com/"), "_blank");
		}
				
		public function mouseUp(event:MouseEvent):void
		{

		}
		
		public function mouseMove(event:MouseEvent):void
		{
			mx = event.stageX;
			my = event.stageY;
		}
        
	}
	
}