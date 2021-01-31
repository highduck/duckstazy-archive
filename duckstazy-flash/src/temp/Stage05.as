package Stages
{
	public class Stage05 extends LevelStage
	{
		private var p1:PillsGenerator;
		private var p2:PillsGenerator;
		private var p3:PillsGenerator;
		
		public function Stage05()
		{
			super();
			
			this.goal = 40.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;

			p1 = new PillsGenerator(pills);
			p1.count = 0;
			p1.countMax = 20;
			p1.x = 20.0;
			p1.y = 360.0;
			p1.w = 600.0;
			p1.h = 0.0;
			p1.geom = 4;
			p1.type = 1;
			pills.addGen(p1);
			
			p2 = new PillsGenerator(pills);
			p2.count = 0;
			p2.countMax = 20;
			p2.x = 20.0;
			p2.y = 320.0;
			p2.w = 600.0;
			p2.h = 0.0;
			p2.geom = 4;
			p2.type = 2;
			pills.addGen(p2);
			
			p3 = new PillsGenerator(pills);
			p3.count = 0;
			p3.countMax = 20;
			p3.x = 20.0;
			p3.y = 280.0;
			p3.w = 600.0;
			p3.h = 0.0;
			p3.geom = 4;
			p3.type = 3;
			pills.addGen(p3);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 20.0;
			pg.y = 20.0;
			pg.w = 600.0;
			pg.h = 100.0;
			pg.speed = 3.5;
			pg.geom = 1;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 20.0;
			pg.y = 20.0;
			pg.w = 600.0;
			pg.h = 100.0;
			pg.speed = 3.5;
			pg.geom = 1;
			pg.type = 4;
			pills.addGen(pg);
		}
		
		public override function update(dt:Number):void
		{
			var sp:Number = level.power;
			p1.high = sp;
			p2.high = sp;
			p3.high = sp;
		}
		
	}
}
			
			
			