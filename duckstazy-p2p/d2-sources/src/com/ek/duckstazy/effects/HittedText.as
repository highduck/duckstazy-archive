package com.ek.duckstazy.effects
{
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.easing.Back;
	import com.ek.library.utils.easing.Cubic;

	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

public class HittedText extends GameObject
	{
		private var _bx:Number;
		private var _by:Number;
		private var _tf:TextField;
		private var _showTween:Number = 0.0;
		private var _hideTween:Number = 0.0;
		private var _time:Number = 0.0;
		
		private var _r:Number = 0.0;
	
		public function HittedText(x:Number, y:Number, text:String, color:uint)
		{
			_tf = createTextField(0.0, 0.0, text, 0xffffff, color);
			
			addChild(_tf);
			
			_time = 0.0;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			scaleX = 0.0;
			scaleY = 0.0;
			
			_r = XRandom.random(-30, 30);
			
			const angle:Number = (_r-90)*Math.PI/180.0;
			_tf.x = 60*Math.cos(angle);
			_tf.y = 60*Math.sin(angle);
			
			this.x = _bx = x;
			this.y = _by = y;
		}
	
		public override function tick(dt:Number):void
		{
			
			_time += dt;
			
			if(_showTween < 1.0)
			{
				_showTween += dt*2.0;
				
				if(_showTween > 1.0)
				{
					_showTween = 1.0;
				}
				
				var t:Number = _showTween;
				var sc:Number = Back.easeOut(t, 0, 0, 0);
				
				scaleX = 
				scaleY = sc;
				
			
				rotation = _r*Cubic.easeOut(_showTween, 0,0,0);	
				//y = _by - 40.0*Cubic.easeOut(t, 0, 0, 0);
				
				//alpha = t*t;
			}
			
			
			if(_time > 1.0)
			{
				_hideTween += dt*2.0;
				if(_hideTween > 1.0)
				{
					parent.removeChild(this);
				}
				else
				{
					alpha = 1.0-_hideTween*_hideTween;
				}
			}
			
			
		}
		
		public static function createTextField(x:Number, y:Number, text:String, color:uint = 0xffffff, backColor:uint = 0x222222, size:uint = 20):TextField
		{
			var tf:TextField = new TextField();
			var strokeSize:Number = 2.2;
			if(size < 16) strokeSize -= (16-size)*1.2/6.0;
			tf.defaultTextFormat = new TextFormat("_Impact", size, 0xffffff);
			tf.embedFonts = true;
			tf.selectable = false;
			tf.multiline = true;
			tf.antiAliasType = AntiAliasType.NORMAL;
			tf.gridFitType = GridFitType.PIXEL;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = color;
			tf.text = text;
			tf.x = x - tf.textWidth*0.5;
			tf.y = y - tf.textHeight*0.5;
			tf.filters = [new GlowFilter(backColor, 1.0, strokeSize, strokeSize, 20, 2), new DropShadowFilter(1.0, 45, 0x0, 1.0, 1, 1, 1, 2)];
			
			return tf;
		}
	}
}
