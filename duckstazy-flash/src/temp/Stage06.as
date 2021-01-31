package Stages
{
	public class Stage06 extends LevelStage
	{
		public function Stage06()
		{
			super();
			
			this.goal = 60.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;

				
			// ежи слева
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 10.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 50.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 90.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 130.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 170.0;
			pg.y = 30.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			// ежи справа
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 630.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 590.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 550.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 510.0;
			pg.y = 60.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 470.0;
			pg.y = 30.0;
			pg.geom = 0;
			pg.type = 4;
			pills.addGen(pg);
			
			
			// красные слева
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 10.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 50.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 90.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 130.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			
			// красные справа
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 630.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 590.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 550.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 1;
			pg.x = 510.0;
			pg.y = 20.0;
			pg.geom = 0;
			pg.type = 3;
			pills.addGen(pg);
					
						
			// круги
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 7;
			pg.x = 320.0;
			pg.y = 200.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 15;
			pg.x = 320.0;
			pg.y = 200.0;
			pg.w = 110.0;
			pg.geom = 3;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 30;
			pg.high = 1.0;
			pg.x = 320.0;
			pg.y = 200.0;
			pg.w = 190.0;
			pg.geom = 3;
			pg.type = 1;
			pills.addGen(pg);
			
			
		}
		
	}
}