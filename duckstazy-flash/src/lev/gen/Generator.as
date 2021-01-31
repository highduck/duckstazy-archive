package lev.gen
{
	import flash.utils.ByteArray;
	
	public class Generator
	{
		public var map:Array; // карта генератора
		public var pills:Array; // массив таблов
		
		public var pillsCount:int; // текущее кол-во живых таблов
		public var begining:Boolean; // начало генерации
		public var finished:Boolean; // все таблы убиты, не генерируем
		
		private var pillsMan:Pills;
				
		public var regen:Boolean; // регенерировать таблы бесконечно
		
		public var speed:Number; // скорость генерации таблов
		public var counter:Number; // счётчик генерации 0 -> 1
		
		private var mapPointer:int;
		
		public var heroSqrDist:Number; // минимальный квадрат расстояния до утки при регенерации
		
		public function Generator()
		{
			counter = 0.0;
			speed = 4.0;
			mapPointer = 0;
			heroSqrDist = 1200;
			
			regen = true;
			
			pillsMan = Pills.instance;
			map = new Array();
			pills = new Array();
		}
		
		public function start():void
		{
			clearPills();
			mapPointer = 0;
			counter = 0.0;
			pillsCount = 0;
			begining = true;
			finished = false;
		}
		
		public function finish():void
		{
			for each(var it:Pill in pills)
			{
				if(it!=null)
					it.kill();
			}
					
			mapPointer = map.length;
			pillsCount = 0;
			finished = true;
		}
		
		public function clearMap():void
		{
			map.length = 0;
			mapPointer = 0;
		}
		
		public function clearPills():void
		{
			if(pills.length>0)
			{
				for each(var it:Pill in pills)
				{
					if(it!=null)
						it.kill();
				}
				
				pills.length = 0;
				pillsCount = 0;
			}
		}
		
		public function update(dt:Number):void
		{
			var o:*;
			var i:int;
			var p:Pill;
			var news:int = 0;
			
			counter+=speed*dt;
			if(!finished && counter>1.0)
			{
				if(pills.length<map.length)
				{
					if((p = pillsMan.findDead())!=null)
					{
						Placer(map[mapPointer]).place(p);
						pills.push(p);
						p.parent = parentCallback;
						++news;
						++mapPointer;
					}
				}
				else
				{
					begining = false;
					if(regen)
					{
						i = 0;
						for each(var it:Pill in pills)
						{
							if(it==null)
							{
								it = pillsMan.findDead();
								if(it!=null)
								{
									if(Placer(map[i]).placeAvoidHero(it, heroSqrDist)!=null)
									{
										it.parent = parentCallback;
										pills[i] = it;
										++news;
										break;
									}
								}
							}
							++i;
						}
					}
				}
				counter-=int(counter);
				pillsMan.actives+=news;
				pillsCount+=news;
			}
		}
		
		public function parentCallback(pill:Pill):void
		{
			var i:int = 0;
			
			for each(var it:Pill in pills)
			{
				if(it==pill)
				{
					pills[i] = null;
					--pillsCount;
					break;
				}
				++i;
			}
		}
		
		public function addCircle(setuper:Setuper, cx:Number, cy:Number, r:Number, count:int, da:Number, a0:Number):void
		{
			var i:int = count;
			var a:Number = a0;
			
			if(i==0) i = int(6.28/da);
			while(i>0)
			{
				map.push(new Placer(setuper, cx + r*Math.cos(a), cy + r*Math.sin(a)));
				--i;
				a+=da;
			}
		}
		
		public function addLine(setuper:Setuper, ox:Number, oy:Number, dx:Number, dy:Number, count:int):void
		{
			var i:int = count;
			var x:Number = ox;
			var y:Number = oy;

			while(i>0)
			{
				map.push(new Placer(setuper, x, y));
				x+=dx;
				y+=dy;
				--i;
			}
		}

	}
}