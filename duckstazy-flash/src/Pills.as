package
{
	import flash.display.BitmapData;
	
	public class Pills
	{
		public static const poolSize:int = 120;
		
		public static var instance:Pills;
		
		public var pool:Array;
	
		public var ps:Particles;
		public var media:PillsMedia;
		public var hero:Hero;
		
		public var actives:int;
		
		public var harvesting:Number;
		public var harvestCount:int;

		public function Pills(gameHero:Hero, particles:Particles, level:Level)
		{
			instance = this;
			
			// Временные переменные
			var i:int = poolSize;
			
			media = new PillsMedia();
			ps = particles;
			hero = gameHero;
			
			// Инициализируем массив(пул) для таблеток
			pool = new Array(poolSize);
			while(i>0)
			{
				pool[i] = new Pill(media, gameHero, particles, level);
				--i;
			}
			
			clear();
			
			harvesting = 0.0;
		}
		
		public function clear():void
		{			
			for each (var it:Pill in pool)
				it.init();
				
			actives = 0;
		}
		
		public function finish():void
		{
			var i:int;
			var process:int;
						
			process = actives;
			harvestCount = 0;
			for each (var p:Pill in pool)
			{
				if(i==process)
					break;
				
				if(p.state!=0)
				{
					if(p.type==0)
					{
						if(p.state==1 || p.state==2)
							harvestCount++;
					}
					else if(p.type==1 || p.type==2)
					{
						ps.explStarsSleep(p.x, p.y);
						p.die();
						actives--;
					}
					++i;
				}
			}
		}
		
		public function harvest(dt:Number):void
		{
			var i:int = 0;
			var to_touch:Boolean = true;
			
			harvesting+=dt*8.0;
			if(harvesting>=1.0)
			{
				harvesting-=1.0;
				harvestCount = 0;
				if(actives>0)
				{
					for each (var p:Pill in pool)
					{
						if(i==actives)
							break;
						
						if(p.state>0)
						{
							if(p.type==0)
							{
								harvestCount++;
								if(to_touch && p.state==2)
								{
									p.heroTouch();
									to_touch = false;
								}
							}					
							++i;
						}
					}
				}
			}
		}
		
		public function update(dt:Number, power:Number):void
		{
			var i:int;
			var process:int;
			
			media.power = power;
			
			process = actives;
			for each (var p:Pill in pool)
			{
				if(i==process)
					break;
					
				if(p.state)
				{
					if(p.update(dt))
						actives--;
					++i;
				}
			}
		}
		
		public function draw(canvas:BitmapData):void
		{
			var i:int;
			
			for each (var p:Pill in pool)
			{
				if(i==actives)
					break;
				
				if(p.state)
				{
					p.dx = int(p.x);
					p.dy = int(p.y);
					if(p.type==0)
						p.drawEmo(canvas);
					else if(p.type==5)
						p.drawJump(canvas);
					else
						p.draw(canvas);
						
					++i;
				}
			}
		}

		public function findDead():Pill
		{
			var o:*;
			
			for each (var p:Pill in pool)
			{
				if(!p.state)
					return p;
			}
			
			return null;
		}
		
		public function isBusy(x:Number, y:Number):Boolean
		{
			var busy:Boolean = false;
			var i:int;
			
			if(utils.vec2distSqr(hero.x+27.0, hero.y+20.0, x, y) >= 3600.0)
			{
				for each (var p:Pill in pool)
				{
					if(i==actives)
						break;
						
					if(p.state)
					{
						if(utils.vec2distSqr(p.x, p.y, x, y) < 900.0)
						{
							busy = true;
							break;
						}
						++i;
					}
				}
			}
			else busy = true;
		
			return busy;
		}
		
		public function tooCloseHero(x:Number, y:Number, sqrDist:Number = 3600.0):Boolean
		{
			var dx:Number = x-hero.x-27;
			var dy:Number = y-hero.y-20;
				
			return dx*dx+dy*dy < sqrDist;
		}
			
		/*public function checkDuck(duck:Hero, startIndex:int):int
		{		
			duck_prev_pos = duck.pos;
			var i:int = startIndex;
			var pick:Boolean;
			
			for(; i<pills_count; ++i)
			{
				var p:Pill = pool[i];
				if(p.state!=Pill.PILL_DEAD && p.state!=Pill.PILL_DYING)
				{
					if(duck.overlapsCircle(p.x, p.y, p.r))
					{
						pick = true;
						switch(p.type)
						{
						case Pill.PILL_POWER:
							powers_info[p.powerID].count--;
							//mBoard->AddPowerScores(pill_pos, p->GetPowerID());
							break;
						case Pill.PILL_TOXIC:
							if(p.toxic_warning>0.0)
								pick = false;
							else
							{
								if(duck.toxicDamage(p.x, p.y))
								{
									pick = false;
									p.kill();
									utils.playSound(attack_snd, 1.0, p.x);
								}
								--toxic_count;
							}
							break;
						case Pill.PILL_DELAY:
							--delay_count; 
							break;
						}
						if(pick)
							break;
					}
				}
			}
			return i;
		}*/

	}
}