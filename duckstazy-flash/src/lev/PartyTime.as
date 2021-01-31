package lev
{
	import flash.display.BitmapData;
	
	import lev.gen.Generator;
	import lev.gen.PartySetuper;

	public class PartyTime extends LevelStage
	{
		public var gen:Generator;
		public var setuper:PartySetuper;
		
		private var danger:int;
	
		public function PartyTime(args:Array)
		{
			super(1);
			
			goalTime = args[0];
			danger = args[1];
		}
		
		override public function start():void
		{
			var y:Number = 350.0;
			var x0:Number = 40.0;
			var dx:Number = 110.0;
			var dy:Number = 30.0
			
			super.start();
			
			setuper = new PartySetuper();
			if(danger==0)
			{
				//setuper.sleeps = 1.0;
				//setuper.toxics = 1.0;
				//setuper.sleeps = 1.0;
				setuper.dangerH = 0.0;
				setuper.jump = 0.1;
			}
			else if(danger==1)
			{
				setuper.powers = 0.8;
				setuper.sleeps = 0.9;
				setuper.toxics = 1.0;
			
				setuper.dangerH = 200.0;
				
				setuper.jump = 0.1;
			}
			else if(danger==2)
			{
				setuper.powers = 0.6;
				setuper.sleeps = 0.8;
				setuper.toxics = 1.0;
			
				setuper.dangerH = 300.0;
				
				setuper.jump = 0.1;
			}
			gen = new Generator();
			gen.regen = true;
			gen.speed = 8.0;
			
			
			while(y>=50)
			{
				gen.addLine(setuper, x0+dx*0.5, y, dx, 0, 5);
				gen.addLine(setuper, x0, y-dy, dx, 0, 6);
				y-=dy*2;
			}
			
			gen.start();
			
			startX = 20.0 + 600.0*Math.random();
			//startPause = true;
		}
		
		override public function onWin():void
		{
			//gen.finish();
			gen.regen = false;
		}
		
		override public function update(dt:Number):void
		{
			var o:*;
			var i:int = 0;
			
			super.update(dt);
		
			if(gen.speed>2.0)
			{
				gen.speed-=dt*0.5;
				if(gen.speed<2.0) gen.speed = 2.0;
			}
				
			gen.update(dt);							
		}
		
		override public function draw1(canvas:BitmapData):void
		{
	
		}
		
	}
}