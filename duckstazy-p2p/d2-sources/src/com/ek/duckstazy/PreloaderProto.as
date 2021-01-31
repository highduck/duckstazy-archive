package com.ek.duckstazy
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author eliasku
	 */
	public class PreloaderProto extends Sprite 
	{
		private static const TEXT_LOADING:String = "LOADING";
		private static const TEXT_INITIALIZATION:String = "INITIALIZATION";
		private static const TEXT_ERROR:String = "ERROR";
		
		private var _progressShape:Shape = new Shape();
        private var _tfInfo:TextField = new TextField();
        
        private var _screenWidth:int;
        private var _screenHeight:int;
        
		public function PreloaderProto(parent:Sprite)
		{
			var filters:Array = [new GlowFilter(0x111111, 1.0, 1.2, 1.2, 10, BitmapFilterQuality.HIGH)];
			
			_progressShape.filters = filters;
			addChild(_progressShape);
			
			_tfInfo.defaultTextFormat = new TextFormat("iFlash 705", 8, 0xffffff);
			_tfInfo.embedFonts = true;
			_tfInfo.selectable = false;
			_tfInfo.multiline = false;
			_tfInfo.autoSize = TextFieldAutoSize.LEFT;
			_tfInfo.filters = filters;
			_tfInfo.text = TEXT_LOADING;
			_tfInfo.x = int(-0.5*_tfInfo.textWidth);
			_tfInfo.y = -2;
			addChild(_tfInfo);
			
			parent.addChild(this);
		}
		
		public function onError():void
		{
			_tfInfo.text = TEXT_ERROR;
			_tfInfo.x = int(-0.5 * _tfInfo.textWidth);
		}

		public function onStart():void 
		{
			_tfInfo.text = TEXT_INITIALIZATION;
			_tfInfo.x = int(-0.5 * _tfInfo.textWidth);
		}

		public function onProgressChanged(progress:Number):void 
		{
			var g:Graphics = _progressShape.graphics;
			
			g.clear();
			g.beginFill(0xffffff);
			g.drawRect(-150, 0, progress * 300.0, 15);
			g.endFill();
		}
	}
}
