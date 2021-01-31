package lev
{
	import flash.display.BitmapData;
	
	import lev.gen.Generator;
	import lev.gen.Placer;
	import lev.gen.PowerSetuper;
	
	public class Harvesting extends LevelStage
	{
		public var gen:Generator;
		public var powers1:PowerSetuper;
		public var powers2:PowerSetuper;
		public var powers3:PowerSetuper;
		public var prog:Number;
		
		public function Harvesting()
		{
			super(0);
			pumpVel = 0.2;
		}
		
		override public function start():void
		{
			super.start();
			startX = 293;
			win = false;
			prog = 0.0;
			
			gen = new Generator();
			powers1 = new PowerSetuper(0.0, PowerSetuper.POWER1);
			powers2 = new PowerSetuper(0.3, PowerSetuper.POWER2);
			powers3 = new PowerSetuper(1.0, PowerSetuper.POWER3);
			powers1.userCallback = pillLogic;
			powers2.userCallback = pillLogic;
			powers3.userCallback = pillLogic;
			gen.regen = true;
			gen.addLine(powers1, 40, 340, 40, 0, 15);
			
			gen.start();
		}
		
		override public function onWin():void
		{
			gen.regen = false;
		}
		
		override public function update(dt:Number):void
		{
			var o:*;
			var i:int = 0;
			
			super.update(dt);
			
			gen.update(dt);
			for each(o in gen.map)
			{
				if(i<15)
					Placer(o).y = 380-hero.getJumpHeight();
				else if(i<30)
					Placer(o).y = 380-hero.getJumpHeight()*0.5;
				else if(i<45)
					break;
				++i;
			}
			
			if(gen.map.length<30 && level.power>0.33)
			{
				i = (380-hero.getJumpHeight()*0.5);
				gen.addLine(powers2, 40, i, 40, 0, 15);
			}
			else if(gen.map.length<45 && level.power>0.66)
			{
				i = 370;
				gen.addLine(powers3, 40, i, 40, 0, 15);
			}					
				
		}
		
		override public function draw1(canvas:BitmapData):void
		{
	
		}
		
		public function pillLogic(pill:Pill, msg:String, dt:Number):void
		{
			var t:Number;
	
			if(msg==null)
			{
				t = pill.t1;
				t+=dt*(0.5+level.power*0.5);
				if(t>1.0) t-=int(t);
				pill.t1 = t;
				
				//t = 0.1;
				//pill.t2 = (1.0-t)*pill.t2 + t*(380-hero.getJumpHeight());
				
				pill.y = 380-hero.getJumpHeight()*pill.t2 + 10*Math.sin(pill.t1*6.28); 
			}
			else if(msg=="born")
			{
				pill.t1 = 0.0;
				pill.t2 = (380-pill.y)/hero.getJumpHeight();//pill.y;
			}
		}
		
	}
}