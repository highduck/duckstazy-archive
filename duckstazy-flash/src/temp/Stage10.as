package Stages
{
	public class Stage10 extends LevelStage
	{
		public function Stage10()
		{
			super();
			
			this.goal = 60.0;
			this.finish = true;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;

			// туловище
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 140.0;
			pg.y = 340.0;
			pg.w = 400.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 140.0;
			pg.y = 160.0;
			pg.w = 0.0;
			pg.h = 140.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 120.0;
			pg.y = 40.0;
			pg.w = 0.0;
			pg.h = 120.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 140.0;
			pg.y = 40.0;
			pg.w = 100.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 240.0;
			pg.y = 40.0;
			pg.w = 0.0;
			pg.h = 260.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 280.0;
			pg.y = 297.0;
			pg.geom = 0;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 320.0;
			pg.y = 300.0;
			pg.w = 0.0;
			pg.h = -140.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 320.0;
			pg.y = 160.0;
			pg.w = 220.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 540.0;
			pg.y = 160.0;
			pg.w = 0.0;
			pg.h = 180.0;
			pg.geom = 4;
			pg.type = 2;
			pills.addGen(pg);
			
			// нос 
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 40.0;
			pg.y = 160.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 80.0;
			pg.y = 160.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			// глаз 
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 170.0;
			pg.y = 100.0;
			pg.geom = 0;
			pg.type = 7;
			pills.addGen(pg);
			
			// крыло 
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 400.0;
			pg.y = 280.0;
			pg.w = 100.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 4;
			pills.addGen(pg);
									
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 400.0;
			pg.y = 220.0;
			pg.w = 100.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 4;
			pills.addGen(pg);
								
			
		}
		
	}
}
