package com.ek.duckstazy
{
	import com.ek.library.ui.UIText;

	/**
	 * @author eliasku
	 */
	public class Fonts 
	{
		[Embed(source="c:/WINDOWS/Fonts/impact.ttf", fontName="_Impact", mimeType="application/x-font", embedAsCFF="false")]
        private static const FONT_IMPACT:Class;
        //private static var _initialized:Boolean;
        
        public static function register():void
        {
        	UIText.registerFont(FONT_IMPACT);
        }
	}
}
