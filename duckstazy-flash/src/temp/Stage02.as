package Stages
{
	public class Stage02 extends LevelStage
	{
		public function Stage02()
		{
			super();
			
			this.goal = 20.0;			
		}
		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;
			
			
			// центр				
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 5;
			pg.x = 320.0;
			pg.y = 200.0;
			pg.geom = 0;
			pg.type = 5;
			pills.addGen(pg);
			
			// линии
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 13;
			pg.x = 40.0;
			pg.y = 40.0;
			pg.w = 560.0;
			pg.h = 320.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
					
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 13;
			pg.x = 40.0;
			pg.y = 360.0;
			pg.w = 560.0;
			pg.h = -320.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.x = 320.0;
			pg.y = 40.0;
			pg.w = 0.0;
			pg.h = 320.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 13;
			pg.x = 40.0;
			pg.y = 200.0;
			pg.w = 560.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 6;
			pg.x = 180.0;
			pg.y = 40.0;
			pg.w = 100.0;
			pg.h = 60.0;
			pg.geom = 4;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 6;
			pg.x = 460.0;
			pg.y = 40.0;
			pg.w = -100.0;
			pg.h = 60.0;
			pg.geom = 4;
			pg.type = 3;
			pills.addGen(pg);
		}
		
	}
}