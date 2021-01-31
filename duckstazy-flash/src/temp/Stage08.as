package Stages
{
	public class Stage08 extends LevelStage
	{
		public function Stage08()
		{
			super();
			
			this.goal = 60.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;


			// полоска синяя
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 15;
			pg.x = 620.0;
			pg.y = 300.0;
			pg.w = -600.0;
			pg.h = 90.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			// полоска желтая
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 15;
			pg.x = 620.0;
			pg.y = 300.0;
			pg.w = -600.0;
			pg.h = -100.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			// полоска разноцветная
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 15;
			pg.x = 620.0;
			pg.y = 100.0;
			pg.w = -600.0;
			pg.h = 100.0;
			pg.geom = 4;
			pg.type = 0;
			pills.addGen(pg);
			
			// полоска красная
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 15;
			pg.x = 620.0;
			pg.y = 100.0;
			pg.w = -600.0;
			pg.h = -80.0;
			pg.geom = 4;
			pg.type = 3;
			pills.addGen(pg);
			
			// опасности
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 7;
			pg.x = 50.0;
			pg.y = 100.0;
			pg.w = 200.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 5;
			pg.x = 400.0;
			pg.y = 200.0;
			pg.w = 200.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 5;
			pills.addGen(pg);
			
			// больничка
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 5;
			pg.x = 500.0;
			pg.y = 20.0;
			pg.w = 120.0;
			pg.h = 40.0;
			pg.geom = 1;
			pg.type = 8;
			pills.addGen(pg);
			
			// ежи
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 5;
			pg.x = 20.0;
			pg.y = 20.0;
			pg.w = 600.0;
			pg.h = 280.0;
			pg.geom = 1;
			pg.type = 4;
			pills.addGen(pg);
					
		}
		
		
	}
}