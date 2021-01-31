package Stages
{
	public class Stage04 extends LevelStage
	{
		
		
		public function Stage04()
		{
			super();
			
			this.goal = 40.0;
		}
		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;
			
			//линии паверы
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 100.0;
			pg.y = 10.0;
			pg.w = -90.0;
			pg.h = 100.0;
			pg.geom = 4;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.x = 210.0;
			pg.y = 10.0;
			pg.w = -200.0;
			pg.h = 200.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 320.0;
			pg.y = 10.0;
			pg.w = -310.0;
			pg.h = 300.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 320.0;
			pg.y = 10.0;
			pg.w = 310.0;
			pg.h = 300.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.x = 430.0;
			pg.y = 10.0;
			pg.w = 200.0;
			pg.h = 200.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 540.0;
			pg.y = 10.0;
			pg.w = 90.0;
			pg.h = 100.0;
			pg.geom = 4;
			pg.type = 3;
			pills.addGen(pg);
			
			// линии ежы
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 6;
			pg.x = 320.0;
			pg.y = 100.0;
			pg.w = -220.0;
			pg.h = 200.0;
			pg.geom = 4;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 6;
			pg.x = 320.0;
			pg.y = 100.0;
			pg.w = 220.0;
			pg.h = 200.0;
			pg.geom = 4;
			pg.type = 4;
			pills.addGen(pg);
			
			// круги
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.high = 0.3;
			pg.x = 320.0;
			pg.y = 330.0;
			pg.w = 60.0;
			pg.geom = 2;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 7;
			pg.high = 0.7;
			pg.x = 320.0;
			pg.y = 220.0;
			pg.w = 50.0;
			pg.geom = 2;
			pg.type = 1;
			pills.addGen(pg);
			
			// опасные
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 25.0;
			pg.y = 25.0;
			pg.geom = 0;
			pg.type = 7;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 615.0;
			pg.y = 25.0;
			pg.geom = 0;
			pg.type = 7;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 30.0;
			pg.y = 370.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 610.0;
			pg.y = 370.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);	
			
		}
		
	}
}