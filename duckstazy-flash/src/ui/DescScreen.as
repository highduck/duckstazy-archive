package ui
{
	import ek.sui.SUIImage;
	import ek.sui.SUIScreen;
	import ek.sui.SUISystem;
	
	import flash.display.BitmapData;

	public class DescScreen extends SUIScreen
	{
        [Embed(source="gfx/sp_help.png")]
        private var gfxHelp:Class;
        
        [Embed(source="gfx/sp_credits.png")]
        private var gfxCredits:Class;
        
		public var btnBack:CircleButton;
		private var splash:SUIImage;
		
		private var imgHelp:BitmapData;
		private var imgCredits:BitmapData;
		
		private var gui:SUISystem;
		private var prev:SUIScreen;
        
		public function DescScreen(_gui:SUISystem)
		{
			imgHelp = (new gfxHelp()).bitmapData;
			imgCredits = (new gfxCredits()).bitmapData;
			
			super();
			
			gui = _gui;
			
			btnBack = new CircleButton();
			btnBack.x = 308.0;
			btnBack.y = 271.0;
			btnBack.radius = 55.0;
			btnBack.callback = back;
			btnBack.img = Game.instance.uiMedia.imgCBBack;
			
			splash = new SUIImage();
			
			add(splash);			
			add(btnBack);
		}
		
		public function go(info:int):void
		{
			prev = gui.current;
			gui.setCurrent(this);
			
			switch(info)
			{
			case 0:
				splash.img = imgHelp;
				btnBack.x = 308.0;
				btnBack.y = 271.0;
				break;
			case 1:
				splash.img = imgCredits;
				btnBack.x = 320.0;
				btnBack.y = 355.0;
				break;
			}
			
			splash.x = 320.0 - (splash.img.width>>1);
			splash.y = 240.0 - (splash.img.height>>1);
		}
		
		public function back():void
		{
			gui.setCurrent(prev);
			prev = null;
		}
		
	}
}