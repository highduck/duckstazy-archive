package ui
{
	import ek.ekDevice;
	import ek.sui.SUIImage;
	import ek.sui.SUIScreen;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mochi.MochiScores;
	import mochi.MochiServices;

	public class ScoresTable extends SUIScreen
	{
		private const RC:Rectangle = new Rectangle();
		private const POINT:Point = new Point();
		private const BG_FILTER:BlurFilter = new BlurFilter(16.0, 16.0, 2);
		private const BOARD_ID:String = "507e25923e6b4015";
		private const GAME_ID:String = "74e833da17589294";
		private const CLIP:MovieClip = new MovieClip();
		private const SHAPE:Shape = new Shape();
		private const SHAPE2:Shape = new Shape();
		private const BG_IMG:SUIImage = new SUIImage();
		private const BACK_IMG:BitmapData = new BitmapData(640, 480, true, 0);
		
		private var BACK_BITMAP:Bitmap;
			
		
		public var bg:BitmapData;
		public var lastScreen:SUIScreen;
		public var game:Game;
		
		public var stage:Stage;	
		
		public function ScoresTable()
		{
			game = Game.instance;
			bg = game.imgBG;
			stage = ekDevice.instance.stage;
			
			stage.addChildAt(CLIP, 1);
			CLIP.visible = false;
			
			CLIP.x = 85;
			CLIP.y = 80;
				
			SHAPE2.graphics.lineStyle(4, 0, 1, true);
			SHAPE2.graphics.drawRoundRect(85, 80, 470, 320, 4, 4);
			
			SHAPE.graphics.lineStyle(4, 0, 1, false);
			SHAPE.graphics.beginFill(0x000000, 0.5);
			SHAPE.graphics.drawRect(85, 80, 470, 320);
			SHAPE.graphics.endFill();
			SHAPE.filters = [BG_FILTER];
			
			BACK_IMG.draw(SHAPE);
			BACK_IMG.draw(SHAPE2);
			RC.x = 85;
			RC.y = 80;
			RC.width = 470;
			RC.height = 320;
			BACK_IMG.fillRect(RC, 0x7f000000);
			
			BACK_BITMAP = new Bitmap(BACK_IMG);
			BACK_BITMAP.x = -85;
			BACK_BITMAP.y = -80;
			CLIP.addChild(BACK_BITMAP);
						
			MochiServices.connect(GAME_ID, CLIP);
			MochiScores.setBoardID(BOARD_ID);
			
			super();
			
			BG_IMG.img = bg;
			BG_IMG.x = 0;
			BG_IMG.y = 0;
			add(BG_IMG);
		}
		
		
		public function showScores():void
		{
			go();
			
			MochiScores.showLeaderboard({
				res: "470x320", 
				clip: CLIP, 
				onClose: onClose,
				previewScores: true,
				showTableRank: true
				});
				//,onError: function ():void { trace("error loading leaderboard!"); } } );
			
		}
		
		public function submitScores():void
		{
			go();
			
			MochiScores.showLeaderboard({
				res: "470x320", 
				clip: CLIP, 
				onClose: onClose,
				score: game.gameState.scores,
				previewScores: true,
				showTableRank: true
				});
				//,onError: function ():void { trace("error loading leaderboard!"); } } );
			
		}
		
		
		private function go():void
		{
			POINT.x = POINT.y = 0;
			RC.x = RC.y = 0;
			RC.width = 640;
			RC.height = 480;
					
			bg.copyPixels(game.back, RC, POINT);
			bg.applyFilter(bg, RC, POINT, BG_FILTER);
			
			lastScreen = game.gui.current;
			game.gui.setCurrent(this);
			
			CLIP.visible = true;
			
			if(lastScreen==game.levelMenu)
				game.level.setPause(true);
		}
		
		public function onClose():void
		{
			game.gui.setCurrent(lastScreen);
			game.level.env.blanc = 1;
			
			CLIP.visible = false;
			
			if(lastScreen==game.levelMenu)
				game.level.setPause(false);
		}

	}
}