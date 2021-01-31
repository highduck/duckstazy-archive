package lev
{
	import flash.display.BitmapData;
	
	import lev.gen.Generator;
	import lev.gen.Placer;
	import lev.gen.PowerSetuper;
	
	public class TestGenerator extends LevelStage
	{
		private var geom:Generator;
		private var gen2:Generator;
		
		public function TestGenerator()
		{
			var gP:PowerSetuper = new PowerSetuper(0.5, PowerSetuper.POWERS);
			
			super(0);
			
			geom = new Generator();
			geom.speed = 5.0;
			
			geom.addCircle(gP, 320, 200, 160, 0, 0.2, 0.0);
		}
		
		override public function start():void
		{
			super.start();
			hero.start(120.0);
			win = true;
			
			geom.start();
		}
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			geom.update(dt);
		}
		
		override public function draw1(canvas:BitmapData):void
		{
		}
		
	}
}