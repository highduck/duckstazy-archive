package lev
{
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import lev.fx.HintArrow;
	import lev.gen.Generator;
	import lev.gen.JumpStarter;
	import lev.gen.PartySetuper;
	import lev.gen.Placer;
	

	public class BetweenCatsStage extends LevelStage
	{
		private var gen:Generator;
		private var gen1:Generator;
		private var gen2:Generator;
		
		private var catGen:Number;
		private var catHum:Number;
		
		private var catToxic:Pill;
		private var catAttack:Number;
		
		private var catAliveL:Boolean;
		private var catAliveR:Boolean;
		private var catFinalAttack:Number;
		
		private var catStage:int;
		
		private var catArrow:HintArrow;
		
		public function BetweenCatsStage()
		{
			super(2);
			
			var i:int;
			
			catArrow = new HintArrow(media);
			
			goalTime = 100.0;
		}
				
		override public function start():void
		{
			var jumper:JumpStarter = new JumpStarter();
			var party:PartySetuper = new PartySetuper();
			var placer1:Placer = new Placer(party, 105, 296);
			var placer2:Placer = new Placer(party, 535, 296);

			var i:int;
			
			party.userCallback = partyLogic;
			
			super.start();
			
			gen = new Generator();
			
			gen.map.push(new Placer(jumper, 300.0, 370.0));
			gen.map.push(new Placer(jumper, 340.0, 340.0));
			gen.map.push(new Placer(jumper, 300.0, 310.0));
			gen.map.push(new Placer(jumper, 340.0, 280.0));
			
			gen.map.push(new Placer(jumper, 500.0, 250.0));
			gen.map.push(new Placer(jumper, 540.0, 220.0));
			gen.map.push(new Placer(jumper, 500.0, 190.0));
			gen.map.push(new Placer(jumper, 540.0, 160.0));
			
			gen.map.push(new Placer(jumper, 100.0, 250.0));
			gen.map.push(new Placer(jumper, 140.0, 220.0));
			gen.map.push(new Placer(jumper, 100.0, 190));
			gen.map.push(new Placer(jumper, 140.0, 160.0));
			
			gen.regen = false;
			gen.heroSqrDist = 0;
			gen.start();
			
			gen1 = new Generator();
			gen2 = new Generator();
			gen1.regen = gen2.regen = false;
			
			i = 40;
			while(i>0) { gen1.map.push(placer1); --i; }
			i = 40;
			while(i>0) { gen2.map.push(placer2); --i; }
						
			pills.findDead().startMatrix(320.0, 100.0);
			pills.findDead().startToxic(220.0, 180.0, 1);
			pills.findDead().startToxic(420.0, 180.0, 1);
			pills.actives+=3;
			
			catGen = 1.0;
			catHum = 0.0;
			catAttack = 0.0;
			catFinalAttack = 0.0;
			catToxic = null;
			
			catAliveL = true;
			catAliveR = true;
						
			catStage = 0;
			
			catArrow.place(110, 150, 0, 0xfff7a0e1, false);
			
			//killer.init();
			
			startX = 293;
		}
		
		public function catPillsCallback(pill:Pill, msg:String, dt:Number):void
		{
			if(msg==null)
			{
				var t:Number;
				pill.t1 += dt*0.5;
				t = (Math.cos(pill.t1*10.064)*0.2+0.8)*212.0;
				pill.x = 320.0 - t*Math.cos(pill.t1);
				pill.y = 224.0 - t*Math.sin(pill.t1);
				if(pill.state<3)
				{
					if(pill.t1>2.95 && pill.t1<3.12)
						catHum = 0.5;
					else if(pill.t1>=3.12)
					{
						pill.kill();
						level.pills.ps.startAcid(pill.x, pill.y);
						catHum = 0.0;
					}
				}
			}
		}
		
		private function launchMissle(pill:Pill, xo:Number, yo:Number):void
		{
			pill.startMissle(xo, yo, 0);
			
			
			if(catStage==0)
			{
				pill.t1 = 5.0;
				pill.vx = (27.0+level.hero.x - xo)/1.2;
				pill.vy = (20.0+level.hero.y - yo)/1.2 - 450.0*1.2;
				if(pill.vy>100.0) pill.vy = 100.0;
				else if(pill.vy<-100.0) pill.vy = -100.0;
			}
			else if(catStage==1)
			{
				pill.t1 = 5.0;
				pill.vx = (27.0+level.hero.x - xo)/1.2;
				pill.vy = (20.0+level.hero.y - yo)/1.2 - 450.0*1.2;
				if(pill.vy>100.0) pill.vy = 100.0;
				else if(pill.vy<-100.0) pill.vy = -100.0;
			}
			else if(catStage==2)
			{
				pill.t1 = 5.0;
				pill.vx = (27.0+level.hero.x - xo)/1.2;
				pill.vy = (20.0+level.hero.y - yo)/1.2 - 450.0*1.2;
				if(pill.vy>100.0) pill.vy = 100.0;
				else if(pill.vy<-100.0) pill.vy = -100.0;
			}
			pill.t2 = 0.1;
			catToxic = pill;
		}
		
		override public function update(dt:Number):void
		{
			var pill:Pill;
			var newPills:int = 0;
			var t:Number;
			var o:*;
			
			super.update(dt);
			
			if(!catAliveL)
				gen1.update(dt);
			if(!catAliveR)
				gen2.update(dt);
			gen.update(dt);
			
			if(level.power>=0.5)
			{
				gen.clearPills();
				gen.clearMap();
			}
			
			if(catToxic!=null)
			{
				if(catToxic.state!=0)
				{
					if(catToxic.state<3)
					{
						catToxic.t2-=dt;
						if(catToxic.t2<0.0)
						{
							catToxic.t2 = 0.05;
							pills.ps.startStarToxic(catToxic.x,  catToxic.y, -catToxic.vx*0.2, -catToxic.vy*0.2, 0);
						}
						
						catToxic.vy+=900.0*dt;
						catToxic.x+=catToxic.vx*dt;
						catToxic.y+=catToxic.vy*dt;
						catToxic.t1-=dt;
						
						if(catToxic.x<10.0 || catToxic.x>630.0)
						{
							catToxic.vx = -catToxic.vx*0.7;
							if(catToxic.x<10.0)	catToxic.x = 10.0;
							else catToxic.x = 630.0;
						}
						if(catToxic.y>390.0 || catToxic.y<10.0)
						{
							catToxic.vy = -catToxic.vy*0.7;
							if(catToxic.y<10.0)	catToxic.y = 10.0;
							else catToxic.y = 390.0;
						}
						if(catToxic.t1<0.0)
						{
							pills.ps.explStarsToxic(catToxic.x, catToxic.y, 0, true);
							catToxic.kill();
						}
					}
					
				}
				else catToxic = null;
			}
			
			if(level.power>=0.5)
			{
				
				if(catHum>0.0)
					catHum-=dt;
				
				catGen+=dt*2.0;
				if(catGen>1.0)
				{
					pill = pills.findDead();
					if(pill!=null)
					{
						if(catStage==0)
						{
							pill.startPower(107, 224, 1, false);
							pill.t1 = 0.0;
							pill.user = catPillsCallback;
							catGen -= 1.0;
							newPills++;
						}
					}
						
				}
				
				if(catStage!=0)
				{
					catAttack-=dt;
					if(catAliveR && catHum<=0.0 && catAttack<0.0 && catToxic==null)
					{
						pill = pills.findDead();
						if(pill!=null)
						{
							launchMissle(pill, 532, 221);
							if(catStage==0)	catAttack = 5.0;
							else if(catStage==1) catAttack = 2.0;
							else if(catStage==2) catAttack = 1.5;
							catHum = 0.5;
							newPills++;
						}
					}
				}
				
				catArrow.update(dt);
			}
			
			switch(catStage)
			{
			case 0:
				if(collected>=25)
				{
					catStage = 1;
					catArrow.visible = true;
				}
				break;
			case 1:
				if(level.hero.x>=76-54 && level.hero.x<=140 &&
					level.hero.yLast<178-40 && level.hero.y >=178-40)
				{
					level.hero.jump(120);
					level.env.blanc = 1.0;
					catAliveL = false;
					catStage = 2;
					catFinalAttack = 15.0;
					
					catArrow.x = 532.0;
					catArrow.visible = false;
					catArrow.visibleCounter = 0.0;
					utils.ctSetRGB(catArrow.color, 0xffb300);
				}
				break;
			case 2:
				catFinalAttack-=dt;
				catArrow.visible = (catFinalAttack<=5.0);
				if(catFinalAttack<0.0)
					catFinalAttack = 15.0;
				else if(catFinalAttack<5.0)
				{
					catAttack = 5.0;
					if(level.hero.x>=500-54 && level.hero.x<=566 &&
						level.hero.yLast<178-40 && level.hero.y >=178-40)
					{
						level.hero.jump(120);
						level.env.blanc = 1.0;
						catAliveR = false;
						catStage = 3;
						catArrow.visible = false;
					}
				}
				break;
			}
			
			
			pills.actives+=newPills;
		}
		
		override public function draw1(canvas:BitmapData):void
		{
			var rc:Rectangle;
			var p:Point;
			var bm:BitmapData;
			var o:*;
			
			if(level.power>=0.5)
			{
				rc = new Rectangle();
				p = new Point();
				
				if(catAliveL)
				{
					bm = media.imgCatL;
					rc.width = bm.width;
					rc.height = bm.height;
					p.x = 54;
					p.y = 137;
					canvas.copyPixels(bm, rc, p);
					
					if(catGen<0.5)
					{
						bm = media.imgCatHum;
						rc.width = bm.width;
						rc.height = bm.height;
						p.x = 92;
						p.y = 212;
						canvas.copyPixels(bm, rc, p);
					}
					else
					{
						bm = media.imgCatSmile;
						rc.width = bm.width;
						rc.height = bm.height;
						p.x = 92;
						p.y = 219;
						canvas.copyPixels(bm, rc, p);
					}
				}
				
				if(catAliveR)
				{
					bm = media.imgCatR;
					rc.width = bm.width;
					rc.height = bm.height;
					p.x = 384;
					p.y = 134;
					canvas.copyPixels(bm, rc, p);
							
					if(catHum>0.0)
					{
						bm = media.imgCatHum;
						rc.width = bm.width;
						rc.height = bm.height;
						p.x = 517;
						p.y = 209;
						canvas.copyPixels(bm, rc, p);
					}
					else
					{
						bm = media.imgCatSmile;
						rc.width = bm.width;
						rc.height = bm.height;
						p.x = 516;
						p.y = 216;
						canvas.copyPixels(bm, rc, p);
					}
				}
				
				bm = media.imgPedestalL;
				rc.width = bm.width;
				rc.height = bm.height;
				p.x = 0;
				p.y = 286;
				canvas.copyPixels(bm, rc, p);
				
				bm = media.imgPedestalR;
				rc.width = bm.width;
				rc.height = bm.height;
				p.x = 408;
				p.y = 288;
				canvas.copyPixels(bm, rc, p);
				

				catArrow.draw(canvas);
			}
		}
		
		public function partyLogic(pill:Pill, msg:String, dt:Number):void
		{
			var friction:Number = 0.7;
			if(msg==null && pill.enabled)
			{
				pill.vy += 300.0*dt;
				pill.x+=pill.vx*dt;
				pill.y+=pill.vy*dt;
				
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
				pill.vx = 300.0*(Math.random()*2.0-1.0);
				pill.vy = -300.0 - Math.random()*200.0;
			}
		}
	}
}