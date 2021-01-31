package com.ek.duckstazy.game
{
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

public class DisplayUtils
	{
		public static function createStroke(color:uint = 0x000000):GlowFilter
		{
			return new GlowFilter(color, 1.0, 1.4, 1.4, 10, 3);
		}
		
		public static function createTextField(size:uint = 27, color:uint = 0xffffff, stroke:Boolean = true, strokeColor:uint = 0x000000):TextField
		{
			var tf:TextField = new TextField();
		
			tf.selectable = false;
			var format:TextFormat = new TextFormat("_Impact", size, color);
			
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.PIXEL;
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
		
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			if(stroke)
			{
				tf.filters = [createStroke(strokeColor)];
			}
					
			return tf;
		}
	}
}
