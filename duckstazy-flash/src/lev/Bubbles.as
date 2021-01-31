package lev
{
	import flash.display.BitmapData;
	
	import lev.fx.HintArrow;
	import lev.gen.Generator;
	import lev.gen.JumpStarter;
	import lev.gen.PartySetuper;
	import lev.gen.Placer;
	
	public class Bubbles extends LevelStage
	{
		public var gen:Generator;
		public var jumper:JumpStarter;
		public var setuper:PartySetuper;
		
		
		private var x:Number;
		private var count:int;
		private var counter:Number;
		
		private var danger:int;
		
		private var arrow1:HintArrow;
		private var arrow2:HintArrow;
		private var arrow3:HintArrow;
		private var arrowHider:Number;
	
		public function Bubbles(args:Array)
		{
			super(0);
			
			pumpVel = args[0];
			danger = args[1];
			
			arrow1 = new HintArrow(media);
			arrow2 = new HintArrow(media);
			arrow3 = new HintArrow(media);
		}
		
		override public function start():void
		{
			var y:Number = 350.0;
			var x0:Number = 40.0;
			var dx:Number = 110.0;
			var dy:Number = 30.0
			
			
			super.start();
			
			setuper = new PartySetuper();
			setuper.userCallback = partyLogic;
			
			jumper = new JumpStarter();
			jumper.userCallback = jumpLogic;
			
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
			
				setuper.dangerH = 400.0;
				
				setuper.jump = 0.1;
			}
			else if(danger==2)
			{
				setuper.powers = 0.6;
				setuper.sleeps = 0.8;
				setuper.toxics = 1.0;
			
				setuper.dangerH = 400.0;
				
				setuper.jump = 0.1;
			}
			
			gen = new Generator();
			gen.regen = false;
			gen.speed = 4.0;

			gen.map.push(new Placer(jumper, 320, 380));
			gen.map.push(new Placer(jumper, 170, 380));
			gen.map.push(new Placer(jumper, 470, 380));
			gen.start();
			
			counter = 0.1;
			count = 0;
			x = 320.0;
			
			if(Math.random()>0.5) startX = 218;
			else startX = 368;
			
			arrow1.place(320, 350, 0, 0xffffb300, true);
			arrow2.place(170, 350, 0, 0xffffb300, true);
			arrow3.place(470, 350, 0, 0xffffb300, true);
			arrow1.visibleCounter = 0.0;
			arrow2.visibleCounter = 0.0;
			arrow3.visibleCounter = 0.0;
			arrow1.visible = true;
			arrow2.visible = true;
			arrow3.visible = true;
			arrowHider = 3.0;
		}
		
		override public function onWin():void
		{
			gen.finish();
			//gen.regen = false;
		}
		
		override public function update(dt:Number):void
		{
			var o:*;
			var i:int = 0;
			var p:Pill;
			
			super.update(dt);
			
			gen.update(dt);
			
			if(count>0)
			{
				counter-=dt;
				if(counter<=0.0)
				{
					p = pills.findDead();
					if(p!=null)
					{
						setuper.start(x - 150.0 + Math.random()*300, 380, p);
						pills.actives++;
					}
					--count;
					counter = 0.1;
				}
			}
			
			if(hero.y<0)
			{
				hero.y = 0;
				if(hero.jumpVel>0) hero.jumpVel = 0;//-hero.jumpVel;
			}
			
			
			if(arrowHider>0.0)
			{
				arrowHider-=dt;
				if(arrowHider<=0.0)
				{
					arrow1.visible = arrow2.visible = arrow3.visible = false;
				}
			}
			
			arrow1.update(dt);
			arrow2.update(dt);
			arrow3.update(dt);
		}
		
		override public function draw1(canvas:BitmapData):void
		{
			arrow1.draw(canvas);
			arrow2.draw(canvas);
			arrow3.draw(canvas);
		}
		
		public function jumpLogic(pill:Pill, msg:String, dt:Number):void
		{
			var t:Number;
			var p:Pill;
			var i:int;
	
			if(msg==null)
			{
				pill.y = 420-hero.getJumpHeight();
				if(pill.y<90) pill.y = 90;
			}
			else if(msg=="born")
			{
				pill.y = 420-hero.getJumpHeight();
			}
			else if(msg=="jump")
			{
				x = pill.x;
				count += 2 + level.power*5;
			}
		}
		
		public function partyLogic(pill:Pill, msg:String, dt:Number):void
		{
			var t:Number;
	
			if(msg==null && pill.enabled)
			{
				pill.vy -= (level.power+0.1)*30.0*dt;
				pill.vx += 200.0*Math.sin((pill.t1 + pill.t2)*6.2831)*dt;
				pill.x+=pill.vx*dt;
				pill.y+=pill.vy*dt;
				
				if(pill.x >= 630)
				{
					pill.vx = -pill.vx;
					pill.t1 = -pill.t1;
					pill.x = 630
				}
				if(pill.x <= 10)
				{
					pill.vx = -pill.vx;
					pill.t1 = -pill.t1;
					pill.x = 10
				}
				
				pill.t2+=dt;
				
				if(pill.y <= -10.0)
					pill.die();
			}
			else if(msg=="born")
			{
				pill.t1 = Math.random();
				pill.t2 = 0.5 + Math.random();
				pill.vx = -10.0 + Math.random()*20.0;
				pill.vy = -5.0 - 50*level.power*Math.random();
				//pill.enabled = true;
				//pill.warning = 0.0;
			}
		}
		
	}
}