package lev
{
	
	import flash.display.BitmapData;
	
	import lev.fx.FrogActor;
	import lev.gen.Generator;
	import lev.gen.Placer;
	import lev.gen.PowerSetuper;
	
	public class TestFrogStage extends LevelStage
	{
		public var frog:FrogActor;
		private var gen1:Generator;
		private var gen2:Generator;
		private var a:Boolean;
		
		public function TestFrogStage()
		{
			var gP:PowerSetuper = new PowerSetuper(1.0, PowerSetuper.POWERS);
			
			super(0);
			
			frog = new FrogActor(media);
			frog.speedHands = 5.0;
			frog.x = 200.0;
			frog.y = 400.0-64.0;
			
			gen1 = new Generator();
			gen1.map.push(new Placer(gP, 300.0, 300.0));
			gen1.map.push(new Placer(gP, 340.0, 340.0));
			gen1.map.push(new Placer(gP, 340.0, 300.0));
			gen1.map.push(new Placer(gP, 300.0, 340.0));
			gen1.speed = 0.5;
			gen1.regen = true;
			
			gen2 = new Generator();
			gen2.map.push(new Placer(gP, 400.0, 300.0));
			gen2.map.push(new Placer(gP, 440.0, 340.0));
			gen2.map.push(new Placer(gP, 440.0, 300.0));
			gen2.map.push(new Placer(gP, 400.0, 340.0));
			gen2.speed = 10.0;
			gen2.regen = true;
		}
		
		override public function start():void
		{
			super.start();
			
			
			hero.start(120.0);
			
			win = true;
			
			a = false;
			
			gen1.start();
			gen2.start();
		}
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			frog.update(dt);
			frog.open = level.hero.x > 320.0;	
			
			if(frog.open && !a)
			{
				pills.findDead().startPower(254, 360, 0, false);
				pills.actives++;
				a = true;
			}
			
			gen1.update(dt);
			gen2.update(dt);
		}
		
		override public function draw1(canvas:BitmapData):void
		{
			frog.draw(canvas);
		}
		
	}
}