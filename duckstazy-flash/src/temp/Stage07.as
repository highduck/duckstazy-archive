package Stages
{
	public class Stage07 extends LevelStage
	{
		
		public function Stage07()
		{
			super();
			
			this.goal = 60.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;
			

			// фильтр
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 78.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 78.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 118.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 118.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 2;
			pills.addGen(pg);
			
			// сигарета				
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 158.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 158.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 198.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 242.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 282.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 282.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 322.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 322.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 362.0;
			pg.y = 220.0;
			pg.geom = 0;
			pg.type = 1;
			pills.addGen(pg);
			
			// дым ежики
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 362.0;
			pg.y = 180.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 410.0;
			pg.y = 100.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 390.0;
			pg.y = 50.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 415.0;
			pg.y = 10.0;
			pg.geom = 0;
			pg.type = 8;
			pills.addGen(pg);
								
			// круг
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 30;
			pg.x = 220.0;
			pg.y = 200.0;
			pg.w = 180.0;
			pg.geom = 3;
			pg.type = 3;
			pills.addGen(pg);
			
			// полоска
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.x = 347.0;
			pg.y = 73.0;
			pg.w = -254.0;
			pg.h = 254.0;
			pg.geom = 4;
			pg.type = 4;
			pills.addGen(pg);
			
			// стрелка
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 6;
			pg.x = 450.0;
			pg.y = 200.0;
			pg.w = 170.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 6;
			pills.addGen(pg);
						
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 2;
			pg.x = 485.0;
			pg.y = 230.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 2;
			pg.x = 485.0;
			pg.y = 170.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 2;
			pg.x = 520.0;
			pg.y = 260.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 2;
			pg.x = 520.0;
			pg.y = 140.0;
			pg.geom = 0;
			pg.type = 6;
			pills.addGen(pg);
			
			
			
		}
		
	}
}