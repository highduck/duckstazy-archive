package Stages
{
	public class Stage03 extends LevelStage
	{
		public function Stage03()
		{
			super();
			
			this.goal = 20.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;
			
			
			// вершины
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 60.0;
			pg.y = 170.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 640.0-60.0;
			pg.y = 170.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 320.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 480.0;
			pg.y = 360.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 160.0;
			pg.y = 360.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			
			// линии
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 60.0;
			pg.y = 170.0;
			pg.w = 520.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 160.0;
			pg.y = 360.0;
			pg.w = 160.0;
			pg.h = -340.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 320.0;
			pg.y = 20.0;
			pg.w = 160.0;
			pg.h = 340.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 60.0;
			pg.y = 170.0;
			pg.w = 420.0;
			pg.h = 190.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.x = 580.0;
			pg.y = 170.0;
			pg.w = -420.0;
			pg.h = 190.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			// бока
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.speed = 3.5;
			pg.x = 160.0;
			pg.y = 70.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 5;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.speed = 3.5;
			pg.x = 480.0;
			pg.y = 70.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 5;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 160.0;
			pg.y = 70.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 480.0;
			pg.y = 70.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
			
			
			
			
		}
		
	}
}