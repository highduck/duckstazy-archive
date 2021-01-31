package lev
{
	public class AirAttack extends LevelStage
	{
		private var regen:Number;
		private var party:Number;
		private var partyCount:int;
		
		public function AirAttack()
		{
			super(1);
			
			goalTime = 60.0;
		}
		
		
		override public function start():void
		{
			super.start();
			
			startX = 293;
			
			regen = 1.0;
			party = 1.0;
			partyCount = 0;
		}
		
		public function rainLogic(pill:Pill, msg:String, dt:Number):void
		{
			if(msg==null && pill.state==2)
			{
				pill.t2-=dt;
				
				if(pill.t2<0.0)
				{
					pill.t2 = 0.05;
					particles.startStarToxic(pill.x,  pill.y, -pill.vx, -pill.vy, 0);
				}
				
				pill.x+=pill.vx*dt;
				pill.y+=pill.vy*dt;
						
				if(pill.x<10.0 || pill.x>630.0)
				{
					pill.vx = -pill.vx;
					if(pill.x<10.0)	pill.x = 10.0;
					else pill.x = 630.0;
				}
				if(pill.y>390.0)
				{
					particles.explStarsToxic(pill.x, pill.y, 0, true);
					pill.kill();
				}
			}
		}
		
		override public function update(dt:Number):void
		{
			var pill:Pill;
			var newPills:int = 0;
			var pow:Number = level.power;
			
			super.update(dt);
			
			if(!win)
			{
				regen-=dt;
				
				if(regen<=0.0)
				{
					pill = pills.findDead();
					if(pill!=null)
					{
						pill.startMissle(10 + Math.random()*620, -10.0, 0);
						pill.t2 = 0.1;
						pill.vx = (Math.random()*300 - 150)*(pow+0.1);
						pill.vy = Math.random()*pow*200 + 100*(1.0+pow);
						pill.user = rainLogic;		
						
						regen+=2.0-pow*1.5;
						newPills++;
					}
				}
				
				if(partyCount<20)
				{
					party-=dt;
					if(party<=0.0)
					{
						pill = pills.findDead();
						if(pill!=null)
						{
							pill.startPower(10 + Math.random()*620, 390.0-Math.random()*160*pow, int(Math.random()*3.0), false);
							pill.parent = parentParty;
							party+=1.0-pow*0.75;
							newPills++;
							partyCount++;
						}
					}
				}
			}
			
			pills.actives+=newPills;
			
			/*if(hero.y<180)
			{
				hero.y = 180;
				if(hero.jumpVel>0)
				{
					hero.jumpVel = -hero.jumpVel;
					if(hero.flip) pow = hero.x+54-17;
					else pow = hero.x+17;
					particles.startRing(pow, hero.y+1, 1.0, 1.0, 1.0, 0xffffffff);
				}
				
			}*/
			hero.diveK = 1.5;
		}
		
		public function parentParty(pill:Pill):void
		{
			partyCount--;
		}
		
	}
}