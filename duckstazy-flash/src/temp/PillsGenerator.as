package
{
	public class PillsGenerator
	{		
		public var countMax:int;
		public var count:int;
		
		public var pause:Number;
		public var speed:Number;
		public var counter:Number;
		public var enabled:Boolean;
		
		public var high:Number;
		
		// 0 - точка (x; y)
		// 1 - прямоугольник (x; y; x+w; y+h)
		// 2 - круг (x; y), w - радиус
		// 3 - кольцо (x; y), w - радиус
		// 4 - линия (x; y) - начало координат, (w; h) - направляющие длины
		public var geom:int;
		public var x:Number;
		public var y:Number;
		public var w:Number;
		public var h:Number;
		
		// 0 - паверы123
		// 1 - павер1
		// 2 - павер2
		// 3 - павер3
		// 4 - еж
		// 5 - токсик1+2
		// 6 - токсик1
		// 7 - токсик2
		// 8 - лечился
		public var type:int;
		
		public var pills:Pills;
		
		public function PillsGenerator(pool:Pills)
		{
			pills = pool;
			
			countMax = 0;
			count = 0;
			
			enabled = true;
			speed = 0.25;
			counter = 0.0;
			pause = 0.0;
			
			high = 0.0;
			
			geom = 0;
			
			x = 0.0;
			y = 0.0;
		}
		
		public function update(dt:Number):Boolean
		{
			var ret:Boolean = false;
			
			if(countMax>count)
			{
				counter+=dt;
				if(counter>speed)
				{
					if(generate())
					{
						counter = 0.0;
						++count;
						ret = true;
					}
				}
			}
			
			return ret;
		}
		
		public function generate():Boolean
		{
			var ret:Boolean = false;
			var p:Pill = pills.findDead();
			var a:Number;
			var r:Number;
			var gx:Number;
			var gy:Number;
			var hi:Boolean;
			
			if(p!=null)
			{
				switch(geom)
				{
				case 0:
					gx = x;
					gy = y;
					break;
				case 1:
					gx = x+Math.random()*w;
					gy = y+Math.random()*h;
					break;
				case 2:
					a = Math.random()*6.28;
					r = Math.random()*w;
					gx = r*Math.cos(a) + x;
					gy = r*Math.sin(a) + y;
					break;
				case 3:
					a = Math.random()*6.28;
					gx = w*Math.cos(a) + x;
					gy = w*Math.sin(a) + y;
					break;
				case 4:
					r = int(Math.random()*countMax+1.0)/countMax;
					gx = x+r*w;
					gy = y+r*h;
					break;
				}
				if(!pills.isBusy(gx, gy))
				{
					if(type<4)
						hi = Math.random()<high;
						
					switch(type)
					{
					case 0:
						p.startPower(gx, gy, int(Math.random()*3.0), hi);
						break;
					case 1:
						p.startPower(gx, gy, 0, hi);
						break;
					case 2:
						p.startPower(gx, gy, 1, hi);
						break;
					case 3:
						p.startPower(gx, gy, 2, hi);
						break;
					case 4:
						p.startDelay(gx, gy);
						break;
					case 5:
						p.startToxic(gx, gy, int(Math.random()*2.0));
						break;
					case 6:
						p.startToxic(gx, gy, 0);
						break;
					case 7:
						p.startToxic(gx, gy, 1);
						break;
					case 8:
						p.startCure(gx, gy);
						break;
					}
					
					p.parent = this;
					ret = true;
				}
			}
			
			return ret;
		}

	}
}