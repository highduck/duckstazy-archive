package
{
	import flash.display.BitmapData;
	
	import mx.core.SpriteAsset;
	
	
	public class Resources
	{
		[Embed(source="swf/logo.swf", symbol="logo")]
        private var rSp:Class;
        
        public var sprSp:SpriteAsset;
        
		// Инициализация	
		public function Resources()	{
			instance = this;
			
			sprSp = new rSp();
		}
		
		public static var instance:Resources;
	}
}