package Stages
{
	public class Stage09 extends LevelStage
	{
		public function Stage09()
		{
			super();
			
			this.goal = 60.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;


			// коробка горизонталь 
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 80.0;
			pg.y = 370.0;
			pg.w = 420.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 80.0;
			pg.y = 240.0;
			pg.w = 420.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 11;
			pg.x = 170.0;
			pg.y = 150.0;
			pg.w = 420.0;
			pg.h = 0.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			// коробка вертикаль
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 4;
			pg.x = 80.0;
			pg.y = 240.0;
			pg.w = 0.0;
			pg.h = 130.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 4;
			pg.x = 500.0;
			pg.y = 240.0;
			pg.w = 0.0;
			pg.h = 130.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 4;
			pg.x = 580.0;
			pg.y = 150.0;
			pg.w = 0.0;
			pg.h = 130.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			//* коробка диагональ
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 80.0;
			pg.y = 240.0;
			pg.w = 80.0;
			pg.h = -70.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 500.0;
			pg.y = 240.0;
			pg.w = 80.0;
			pg.h = -70.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 500.0;
			pg.y = 360.0;
			pg.w = 80.0;
			pg.h = -70.0;
			pg.geom = 4;
			pg.type = 1;
			pills.addGen(pg);
						
			// з рога усяго многа
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.x = 100.0;
			pg.y = 10.0;
			pg.w = 500.0;
			pg.h = 180.0;
			pg.high = 0.6;
			pg.geom = 1;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 100.0;
			pg.y = 10.0;
			pg.w = 500.0;
			pg.h = 180.0;
			pg.geom = 1;
			pg.type = 5;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;			
			pg.x = 100.0;
			pg.y = 10.0;
			pg.w = 500.0;
			pg.h = 180.0;
			pg.geom = 1;
			pg.type = 4;
			pills.addGen(pg);
			
			// 103
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 3;
			pg.x = 20.0;
			pg.y = 20.0;
			pg.w = 0.0;
			pg.h = 150.0;
			pg.geom = 4;
			pg.type = 8;
			pills.addGen(pg);
		}
		
	}
}