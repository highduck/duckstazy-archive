package Stages
{
	public class Stage01 extends LevelStage
	{
		
		private var t1:PillsGenerator; 
		private var t2:PillsGenerator;
		private var s:PillsGenerator;
		
		public function Stage01()
		{
			super();
			
			this.goal = 20.0;
		}

		
		public override function init():void
		{
			var pg:PillsGenerator;
			var pills:Pills = level.pills;
	
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.high = 0.5;
			pg.x = 160.0;
			pg.y = 300.0;
			pg.w = 70.0;
			pg.geom = 2;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 10;
			pg.high = 0.5;
			pg.x = 480.0;
			pg.y = 300.0;
			pg.w = 70.0;
			pg.geom = 2;
			pg.type = 1;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.high = 0.3;
			pg.x = 320.0;
			pg.y = 200.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 2;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.high = 0.1;
			pg.x = 160.0;
			pg.y = 100.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 3;
			pills.addGen(pg);
			
			pg = new PillsGenerator(pills);
			pg.count = 0;
			pg.countMax = 8;
			pg.high = 0.1;
			pg.x = 480.0;
			pg.y = 100.0;
			pg.w = 50.0;
			pg.geom = 3;
			pg.type = 3;
			pills.addGen(pg);
			
			
			t1 = new PillsGenerator(pills);
			t1.count = 0;
			t1.countMax = 1;
			t1.x = 160.0;
			t1.y = 100.0;
			t1.geom = 0;
			t1.type = 7;
			t1.enabled = false;
			
			t2 = new PillsGenerator(pills);
			t2.count = 0;
			t2.countMax = 1;
			t2.x = 480.0;
			t2.y = 100.0;
			t2.geom = 0;
			t2.type = 7;
			t2.enabled = false;
			
			s = new PillsGenerator(pills);
			s.count = 0;
			s.countMax = 1;
			s.x = 320.0;
			s.y = 200.0;
			s.geom = 0;
			s.type = 4;
			s.enabled = false;
			
			pills.addGen(t1);
			pills.addGen(t2);
			pills.addGen(s);
		
		
		}
		
		public override function update(dt:Number):void
		{
			if(level.progress.perc>=0.5)
			{
				t1.enabled = true;
				t2.enabled = true;
			}
			else if(level.progress.perc>=0.2)
			{
				s.enabled = true;
			}
			
		}
		
	}
}