package com.ek.duckstazy.effects
{
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.easing.Back;
	import com.ek.library.utils.easing.Cubic;

	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author eliasku
	 */
	public class BubbleText extends GameObject 
	{
		private var _bx:Number;
		private var _by:Number;
		private var _tf:TextField;
		private var _time:Number = 0.0;
	
		public function BubbleText(x:Number, y:Number, text:String, color:uint, backColor:uint)
		{
			_tf = createTextField(0.0, 0.0, text, color, backColor);
			
			addChild(_tf);
			
			_time = 0.0;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			scaleX = 0.0;
			scaleY = 0.0;
			
			this.x = _bx = x;
			this.y = _by = y;
		}
	
		public override function tick(dt:Number):void
		{
			_time += dt;
			var t:Number = _time;
			if(t > 1.0) t = 1.0;
			var sc:Number = 1.0;
			if(t < 0.1)
			{
				sc = t / 0.1;
				sc = Back.easeOut(sc, 0, 0, 0);
			}
			
			scaleX = 
			scaleY = sc;
			y = _by - 40.0*Cubic.easeOut(t, 0, 0, 0);
			alpha = (1.0 - t*t);
			
			if(_time > 1.0)
			{
				parent.removeChild(this);
			}
		}
		
		public static function createTextField(x:Number, y:Number, text:String, color:uint = 0xffffff, backColor:uint = 0x222222, size:uint = 16):TextField
		{
			var tf:TextField = new TextField();
			var strokeSize:Number = 2.2;
			if(size < 16) strokeSize -= (16-size)*1.2/6.0;
			tf.defaultTextFormat = new TextFormat("_Impact", size, 0xffffff);
			tf.embedFonts = true;
			tf.selectable = false;
			tf.multiline = true;
			tf.antiAliasType = AntiAliasType.NORMAL;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = color;
			tf.text = text;
			tf.x = x - tf.textWidth*0.5;
			tf.y = y - tf.textHeight*0.5;
			tf.filters = [new GlowFilter(backColor, 1.0, strokeSize, strokeSize, 5, 3)];
			
			return tf;
		}
	}
}