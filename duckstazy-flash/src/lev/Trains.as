package lev
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lev.fx.FrogActor;
	import lev.gen.Generator;
	import lev.gen.JumpStarter;
	import lev.gen.Placer;
		
	public class Trains extends LevelStage
	{
		private var frog:FrogActor;
		private var cat:FrogActor;
				
		private var jumpGen:Generator;
		private var catGen:Number;

		private var frogCounter:Number;
		
		public function Trains()
		{
			super(2);
			goalTime = 100.0;
			
			frog = new FrogActor(media);
			
			frog.speedHands = 2.0;
			
			frog.x = 10.0;
			frog.y = 253;
		}
		
		override public function start():void
		{
			//var placer:Placer;
			var jumper:JumpStarter = new JumpStarter();
			
			super.start();
			
			jumpGen = new Generator();
			jumpGen.regen = false;
			jumpGen.speed = 4.0;
			
			jumpGen.map.push(new Placer(jumper, 160.0, 370.0));
			jumpGen.map.push(new Placer(jumper, 480.0, 370.0));
			
			jumpGen.map.push(new Placer(jumper, 200.0, 340.0));
			jumpGen.map.push(new Placer(jumper, 440.0, 340.0));
			
			jumpGen.map.push(new Placer(jumper, 240.0, 310.0));
			jumpGen.map.push(new Placer(jumper, 400.0, 310.0));
			
			jumpGen.map.push(new Placer(jumper, 280.0, 280.0));
			jumpGen.map.push(new Placer(jumper, 360.0, 280.0));
			
			jumpGen.map.push(new Placer(jumper, 320.0, 250.0));

			jumpGen.start();
			
			env.day = false;
			env.updateNorm();
			
			frog.openCounter = 0.0;
			frog.open = true;
			frogCounter = 1.0;
			
			catGen = 1.0;
			
			startX = 293;
		}
		
		override public function onWin():void
		{
			jumpGen.finish();
			
		}
		
		override public function update(dt:Number):void
		{
			var o:*;
			var i:int = 0;
			var p:Pill;
			var newPills:int = 0;
			
			super.update(dt);
			
			jumpGen.update(dt);

			frog.update(dt);
			
			if(frog.open && frog.openCounter>=0.5 && !win)
			{
				frogCounter+=dt*(0.5+level.power*2.0);
				if(frogCounter>=1.0)
				{
					p = pills.findDead();
					if(p!=null)
					{
						p.user = toxicLogic;
						if(Math.random()>0.2)
							p.startMissle(80, 260, 1);
						else
							p.startSleep(80, 260);
						newPills++;
						
					}
					frogCounter-=int(frogCounter);
				}
			}
			else frogCounter = 1.0;
			
			frog.speedHands = 2.0+level.power*2.0;
			
			if(level.power>=0.5 && !win)
			{
				catGen+=dt*(0.25+0.75*(level.power-0.5));
				if(catGen>1)
				{
					p = pills.findDead();
					if(p!=null)
					{
						p.user = rocketLogic;
						p.startMissle(548, 228, 0);
						p.t2 = 0.1;
						catGen -= 1.0;
						newPills++;
					}
				}
			}
			else catGen = 1.0;
			
			frog.open = (hero.y<=250 && !win);
			
			pills.actives+=newPills;
		}
		
		override public function draw1(canvas:BitmapData):void
		{
			var rc:Rectangle = new Rectangle();
			var p:Point = new Point();
			var bm:BitmapData;
			var o:*;
			

			bm = media.imgCatL;
			rc.width = bm.width;
			rc.height = bm.height;
			p.x = 495;
			p.y = 140;
			canvas.copyPixels(bm, rc, p);
			
			if(catGen<0.5)
			{
				bm = media.imgCatHum;
				rc.width = bm.width;
				rc.height = bm.height;
				p.x = 533;
				p.y = 212;
				canvas.copyPixels(bm, rc, p);
			}
			else
			{
				bm = media.imgCatSmile;
				rc.width = bm.width;
				rc.height = bm.height;
				p.x = 533;
				p.y = 219;
				canvas.copyPixels(bm, rc, p);
			}

			
			frog.draw(canvas);
			
			bm = media.imgPedestalL;
			rc.width = bm.width;
			rc.height = bm.height;
			p.x = -27;
			p.y = 400-115;
			canvas.copyPixels(bm, rc, p);
			
			bm = media.imgPedestalR;
			rc.width = bm.width;
			rc.height = bm.height;
			p.x = 432;
			p.y = 400-113;
			canvas.copyPixels(bm, rc, p);
		}
		
		public function toxicLogic(pill:Pill, msg:String, dt:Number):void
		{
			var i:int;
			var p:Pill;
			if(msg==null && pill.state==2)
			{
				if(pill.x>=630 || pill.x<=10)
				{
					pill.kill();
					if(pill.type==1)
						particles.explStarsToxic(pill.x, pill.y, 1, false);
					else if(pill.type==2)
						particles.explStarsSleep(pill.x, pill.y);
				}
				else
					pill.x+=pill.t1*(1.0+4.0*level.power)*dt;
			}
			else if(msg=="attack")
			{
				i = 1 + int(level.power*5);
				while(i>0)
				{
					p = pills.findDead();
					if(p!=null)
					{
						p.user = partyLogic;
						p.startPower(pill.x, pill.y, int(Math.random()*3), false);
						pills.actives++;
					}
					--i;
				}
			}
			else if(msg=="born")
			{
				if(pill.x>320) pill.t1 = -40;
				else pill.t1 = 40;
			}
		}
				
		public function partyLogic(pill:Pill, msg:String, dt:Number):void
		{
			var pow:Number = level.power;
			var friction:Number = 0.8-pow*0.1;
			var dx:Number;
			var dy:Number;
			
			if(msg==null && pill.enabled)
			{
				dx = hero.x - pill.x + 27;
				dy = hero.y - pill.y + 20;
				pill.vy += (300.0+dy*10)*dt
				pill.vx += dx*5*dt;
				pill.x+=pill.vx*dt;
				pill.y+=pill.vy*dt;
				
				pill.t2-=dt;
				
				if(pill.t2<0.0)
				{
					pill.t2 = 0.05;
					particles.startStarPower(pill.x,  pill.y, -pill.vx, -pill.vy, pill.id);
				}
				
				if(pill.x > 630)
				{
					pill.vx = -pill.vx*friction;
					pill.vy = pill.vy*friction;
					pill.x = 630;
				}
				if(pill.x < 10)
				{
					pill.vx = -pill.vx*friction;
					pill.vy = pill.vy*friction;
					pill.x = 10;
				}
				
				if(pill.y < 10)
				{
					pill.vy = -pill.vy*friction;
					pill.vx = pill.vx*friction;
					pill.y = 10;
				}
				if(pill.y > 390)
				{
					pill.vy = -pill.vy*friction;
					pill.vx = pill.vx*friction;
					pill.y = 390;
				}
			}
			else if(msg=="born")
			{
				pill.vx = (150.0+150.0*pow)*(Math.random()*2.0-1.0);
				pill.vy = 75.0+ Math.random()*50.0;
				pill.t2 = 0.05;
			}
		}
		
		public function rocketLogic(pill:Pill, msg:String, dt:Number):void
		{
			var i:int;
			var p:Pill;
			var pow:Number = level.power;
			if(msg==null && pill.state==2)
			{
				if(pow>=0.5)
				{
					pill.t2-=dt;
					
					if(pill.t2<0.0)
					{
						pill.t2 = 0.1;
						particles.startStarToxic(pill.x+12,  pill.y, 100*pow, 0, 0);
					}
					
					if(pill.x<=10)
					{
						pill.kill();
						particles.explStarsToxic(pill.x, pill.y, 0, true);
					}
					else
					{
						pill.x-=100*pow*dt;
					}
				}
			}
			else if(msg=="attack")
			{
				i = 1 + int(pow*5);
				while(i>0)
				{
					p = pills.findDead();
					if(p!=null)
					{
						p.user = partyLogic;
						p.startPower(pill.x, pill.y, int(Math.random()*3), false);
						pills.actives++;
					}
					--i;
				}
			}
		}
	}
	
}