package
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Pill
	{
		public const POWER:int = 0;
		public const TOXIC:int = 1;
		public const SLEEP:int = 2;
		public const HEALTH:int = 3;
		public const MATRIX:int = 4;
		public const JUMP:int = 5;

		/*public const DEAD:int = 0;
		public const BORNING:int = 1;
		public const ALIVE:int = 2;
		public const DYING:int = 3;*/

		/*public const HAPPY:int = 0;
		public const SHAKE:int = 1;
		public const SMILE:int = 2;*/
		
		private const RC:Rectangle = new Rectangle(0,0,20,20);
		private const POINT:Point = new Point(0,0);
		private const COLOR:ColorTransform = new ColorTransform();
		private const BLACK:ColorTransform = new ColorTransform(0,0,0);
		private const MAT:Matrix = new Matrix();
		
		
		// временный идентификатор
		public var id:int;

		// Прирост силы от таблетки
		public var power:Number;
		
		// Урон от таблетки
		public var damage:int;
		
		// Очки за таблетку при максимальной силе
		public var scores:int;
		
		// Время предупреждения
		public var warning:Number;
		public var enabled:Boolean;

		// захват героя
		public var hook:Boolean;
		private var hookTime:Number;
		private var hookCounter:Number;
		
		// Направление на героя
		public var spy:Boolean;
		public var hx:Number;
		public var hy:Number;
		
		// Счётчик появления
		private var appear:Number;

		public var emo:Boolean;
		private var emoType:int;
		private var emoCounter:Number;
		private var emoPause:Number;
		private var emoParam:Number;
	
		// состояние табла
		public var state:int;
	
		public var x:Number;
		public var y:Number;
		
		// округлённые координаты
		public var dx:Number;
		public var dy:Number;
		
		// временные вспомогательные переменные, используемые только внешними классами
		public var t1:Number;
		public var t2:Number;
		
		public var r:Number;
		public var rMax:Number;
		
		public var move:Boolean;
		public var v:Number;
		public var vx:Number;
		public var vy:Number;
		
		public var high:Boolean;
		public var highCounter:Number;
		
		public var type:int;
		
		private var media:PillsMedia;
		private var ps:Particles;
		private var hero:Hero;
		private var level:Level;
		
		private var imgMain:BitmapData;
		private var imgEmo:BitmapData;
		private var imgNid:BitmapData;
		
		// используется для оповещения генератора-родителя
		public var parent:Function;
		
		// используется для оповещения пользовательских событий
		public var user:Function;
   
		// Инициализируемся в массиве
		public function Pill(pillsMedia:PillsMedia, duckHero:Hero, particles:Particles, _level:Level)
		{
			media = pillsMedia;
			hero = duckHero;
			ps = particles;
			level = _level;
			init();
		}
		
		// Сбрасываемся
		public function init():void
		{
			state = 0;
			move = false;
			highCounter = 0.0;
			
			parent = null;
			user = null;
			
			/*emoCounter = 0.0;
			emoPause = 0.0;
			hook = false;
			
			emo = false;
						
			vx = 0.0;
			vy = 0.0;
			
			hx = 0.0;
			hy = 0.0;*/
		}

		// Стартуем анимацию эмоции
		private function startEmo(emotionType:int):void
		{
			switch(emotionType)
			{
			case 0:
				emoParam = 1 + int(Math.random()*3.0);
				if(Math.random()<0.5)
					emoParam = -emoParam;
			case 1:
			case 2:
				emoCounter = 3.0;
				break;
			}
			emoType = emotionType;
		}
		
		// Обновляем появление
		private function setState(newState:int):void
		{
			switch(newState)
			{
			case 0:
				if(user!=null)
				{
					user(this, "dead", 0.0);
					user = null;
				}
				if(parent!=null)
				{
					parent(this);
					parent = null;
				}
				move = false;
				break;
			case 1:
				if(user!=null)
					user(this, "born", 0.0);
				appear = 0.0;
				r = 0.0;
				break;
			case 2:
				appear = 1.0;
				r = rMax;
				break;
			}
		
			state = newState;
		}
		
		// Обновляемся
		public function update(dt:Number):Boolean
		{
			if(state!=3 && enabled && hero.state.health>0)
			{
				if(y+r > hero.y || y-r < hero.y + 40.0)
					if(x+r > hero.x || x-r < hero.x + 54.0)
						if(hero.overlapsCircle(x, y, r))
							heroTouch();
			}
			
			switch(state)
			{
			case 1:
				if(!enabled)
				{
					warning-=dt;
					if(warning<=0.0)
					{
						enabled = true;
						ps.startAcid(x, y);
						if(type==TOXIC)
							utils.playSound(media.sndToxicBorn, 1.0, x);
					}
				}
				else
				{
					appear+=10.0*dt;
					r = rMax*appear;
					if(appear>=1.0)
						setState(2);	
				}
				break;
			case 2:
				if(spy)
					updateSpy();
					
				if(hook)
					updateHook(dt);
					
				if(move) { x += vx*dt; y += vy*dt; }
				
				if(emo && media.power>0.5)
				{
					if(emoCounter>0.0)
					{
						emoCounter -= dt;
						if(emoCounter<0.0)
						{
							emoCounter = 0.0;
							emoPause = Math.random()*3.0+2.0;
						}
					}
					else
					{
						emoPause-=dt;
						if(emoPause<=0.0)
							startEmo(int(Math.random()*3.0));
					}
				}
					
				if(high)
				{
					if(level.power>=0.5)
						highCounter+=dt;//*(1.0 + 3.0*level.power);
					else
						highCounter+=dt*(1.0 + 7.0*level.power);
					if(highCounter>=1.0)
						highCounter-=int(highCounter);
				}
				
				if(type==JUMP && highCounter>0.0)
				{
					highCounter-=dt;
					if(highCounter<0.0) highCounter = 0.0;
				}
				
				break;
			case 3:
				appear-=10.0*dt;
				if(appear<=0.0)
					setState(0);
				break;
			}
			
			if(user!=null)
				user(this, null, dt);
				
			return state==0;
		}
		
		public function updateSpy():void
		{
			var dx:Number = hero.x - x + 27.0;
			var dy:Number = hero.y - y + 20.0;
			var i:Number = 1.0 / Math.sqrt(dx*dx + dy*dy);
			
			hx = dx*i;
			hy = dy*i; 
		}

		public function heroTouch():void
		{
			var i:int;
			var info:GameInfo = level.info;
						
			switch(type)
			{
			case POWER:
				if(!hero.sleep)
					level.gainPower(power);
				if(level.power>=0.5)
				{
					i = id+level.state.hell;
					level.state.scores+=level.state.calcHellScores(i);
					//else if(i==1) level.state.scores+=10;
					//else if(i==2) level.state.scores+=25;
					info.add(x, y, info.powers[i]);
					level.env.beat();
				}
				else
				{
					i = level.state.norm;
					if(i==0)
					{
						level.state.scores++;
						info.add(x, y, info.one);
					}
					else
					{
						info.add(x, y, info.powers[i-1]);
						level.state.scores+=level.state.calcHellScores(i-1);
					}
				}
				utils.playSound(media.sndPowers[id], 1.0, x);
				
				
				if(high && hero.doHigh(x, y))
				{
					media.sndHigh.play();
					ps.explStarsPower(x, y-r, id);
				}
				else
					ps.explStarsPower(x, y, id);
					
				level.stage.collected++;
					
				break;
			case TOXIC:
				i = hero.doToxicDamage(x, y, damage, id);
				if(i>=0)
				{
					if(level.power>=0.5)
					{
						if(i==0) level.state.scores+=100;
						else if(i==1) level.state.scores+=150;
						else if(i==2) level.state.scores+=200;
						info.add(x, y, info.toxics[i]);
						level.env.beat();
					}
					else
					{
						if(i==0) level.state.scores+=5;
						else if(i==1) level.state.scores+=10;
						else if(i==2) level.state.scores+=25;
						info.add(x, y, info.powers[i]);
					}
					if(user!=null)
						user(this, "attack", 0);
				}
				else info.add(x, y, info.damages[int(Math.random()*3.0)]);
				break;
			case SLEEP:
				//--delay_count;
				if(!hero.sleep)
				{
					hero.doSleep();
					level.gainSleep();
					level.env.beat();
				}
				ps.explStarsSleep(x, y);
				info.add(x, y, info.sleeps[int(Math.random()*3.0)]);
				break;
			case HEALTH:
				media.sndHeal.play();
				hero.doHeal(5);
				level.env.beat();
				break;
			case MATRIX:
				level.switchEvnPower();
				level.env.beat();
				break;
			case JUMP:
				if(highCounter<=0.0 && hero.doHigh(x, y))
				{
					media.sndJumper.play();
					highCounter = 1.0;
					level.env.beat();
					if(user!=null)
						user(this, "jump", 0.0);
				}
				return;
			}
			
			kill();
		
		}
		
		public function startPower(px:Number, py:Number, ID:int, h:Boolean):void
		{
			x = int(px);
			y = int(py);
			type = POWER;
			
			switch(ID)
			{
			case 0:
				scores = 5;
				power = 0.01;
				imgMain = media.imgPower1;
				imgEmo = media.imgPPower1;
				break;
			case 1:
				scores = 25;
				power = 0.025;
				imgMain = media.imgPower2;
				imgEmo = media.imgPPower2;
				break;
			case 2:
				scores = 50;
				power = 0.05;
				imgMain = media.imgPower3;
				imgEmo = media.imgPPower3;
				break;
			}
			
			rMax = 10.0;
			
			damage = 0;
			
			id = ID;
			
			emo = true;
			emoPause = Math.random()*3.0+2.0;
			emoCounter = 0.0;
			hx = 0.0;
			hy = 0.0;
			
			imgNid = BitmapData(media.imgNids[int(Math.random()*4)]);
			
			spy = true;
			
			hook = false;
			
			high = h;
						
			enabled = true;
			
			setState(1);
			
			ps.startAcid(x, y);
			utils.playSound(media.sndGenerate, 1.0, x);
		}
		
		public function startJump(px:Number, py:Number):void
		{
			x = int(px);
			y = int(py);
			type = JUMP;
			
			imgMain = media.imgHigh;
			
			rMax = 10.0;
			
			damage = 0;

			spy = false;
			hook = false;
			high = false;
			enabled = true;
			
			setState(1);
			
			highCounter = 0.0;
			
			ps.startAcid(x, y, 0xffffffff);
			utils.playSound(media.sndGenerate, 1.0, x);
		}
		
		public function startMatrix(px:Number, py:Number):void
		{
			x = int(px);
			y = int(py);
			type = MATRIX;
			
			imgMain = media.imgHole;
			//imgNid = null;
		
			rMax = 10.0;
			
			
			spy = false;
			hook = false;
			high = false;
						
			enabled = true;
			
			setState(1);
			
			ps.startAcid(x, y);
			utils.playSound(media.sndGenerate, 1.0, x);
		}
		
		public function startToxic(px:Number, py:Number, ID:int):void
		{
			x = int(px);
			y = int(py);
			type = TOXIC;
						
			switch(ID)
			{
			case 0:
				damage = 20;
				imgMain = media.imgToxic;
				hook = true;
				hookTime = 3.0;
				hookCounter = 0.0;
				break;
			case 1:
				damage = 20;
				imgMain = media.imgToxic2;
				hook = false;
				break;
			}
			
			id = ID;
			
			warning = 3.0;
			enabled = false;
						
			spy = false;
			
			rMax = 10.0;
			
			v = 20.0;
			
			emo = false;
			
			high = false;
			
			setState(1);
			if(level.power<0.5 && !level.env.day)
				ps.startWarning(x, y, 3.0, 1.0, 1.0, 1.0);
			else
				ps.startWarning(x, y, 3.0, 0.0, 0.0, 0.0);
			media.sndWarning.play();
		}
		
		public function startMissle(px:Number, py:Number, ID:int):void
		{
			x = int(px);
			y = int(py);
			type = TOXIC;
						
			switch(ID)
			{
			case 0:
				damage = 20;
				imgMain = media.imgToxic;
				break;
			case 1:
				damage = 20;
				imgMain = media.imgToxic2;
				break;
			}
			
			hook = false;
			
			id = ID;
			
			enabled = true;
						
			spy = false;
			
			rMax = 10.0;
			
			v = 20.0;
			
			emo = false;
			
			high = false;
			
			setState(1);
		}
		
		public function startSleep(px:Number, py:Number):void
		{
			x = int(px);
			y = int(py);
			type = SLEEP;
			
			emo = false;
			spy = false;
			hook = false;
			high = false;
			enabled = true;
						
			rMax = 10.0;
						
			imgMain = media.imgSleep;

			setState(1);
			
			ps.startAcid(x, y);
			utils.playSound(media.sndGenerate, 1.0, x);
		}
		
		public function startCure(px:Number, py:Number):void
		{
			x = int(px);
			y = int(py);
			type = HEALTH;
			
			//damage = 5;
			
			emo = false;
			spy = false;
			hook = false;
			high = false;
			enabled = true;
						
			rMax = 10.0;
						
			imgMain = media.imgCure;

			setState(1);
			
			ps.startAcid(x, y);
			utils.playSound(media.sndGenerate, 1.0, x);
		}
		
		public function kill():void
		{
			setState(3);
			appear = 0.5;
		}
		
		public function die():void
		{
			setState(0);
		}
		 
		public function updateHook(dt:Number):void
		{
			if(hookCounter>0.0)
			{
				hookCounter-=dt;
				if(hookCounter>0.0)
				{
					updateSpy();
					vx = hx*v;
					vy = hy*v;
				}
				else
				{
					// хук закончился
					move = false;
					
					// въебать эффект
					ps.startRing(x, y, -1.0, 0.25, 0.25, 0xff000000);
					//mWaves->Start(world_draw_pos(p->GetPos()), 0xff000000, 30.0f, 5.0f);
				}
			}
			else
			{
				if(utils.vec2distSqr(x, y, hero.x + 27.0, hero.y + 20.0) < 10000.0)
				{
					hookCounter = hookTime;
					move = true;
					updateSpy();
					vx = hx*v;
					vy = hy*v;
					
					// въебать эффект
					//mWaves->Start(worl_draw_pos(p->GetPos()), 0xff000000, 30.0f, 5.0f);
					ps.startRing(x, y, 1.0, 0.25, 0.125, 0xff000000);
				}
			}
		}

		public function drawEmo(canvas:BitmapData):void
		{
			if(media.power<0.5)
			{
				if(state!=2)
				{
					MAT.identity();
					MAT.tx = MAT.ty = -10;
					MAT.scale(appear, appear);
					MAT.translate(dx, dy);
					canvas.draw(imgMain, MAT, null, null, null, true);
					canvas.draw(imgNid, MAT, null, null, null, true);
				}
				else
				{
					POINT.x = dx-10;
					POINT.y = dy-10;
					canvas.copyPixels(imgMain, RC, POINT);
					canvas.copyPixels(imgNid, RC, POINT);
				}
			}
			else
			{
				if(state!=2)
				{
					MAT.identity();
					MAT.tx = MAT.ty = -10;
					MAT.scale(appear, appear);
					MAT.translate(dx, dy);
					canvas.draw(imgEmo, MAT, null, null, null, true);
				}
				else
				{
					POINT.x = dx-10;
					POINT.y = dy-10;
					canvas.copyPixels(imgEmo, RC, POINT);
				}
									
				if(emoCounter>0.0)
				{
					switch(emoType)
					{
					case 0:
						drawEmoHappy(canvas);
						break;
					case 1:
						drawEmoShake(canvas);
						break;
					case 2:
						drawEmoSmile(canvas);
						break;
					}
				}
				else
					drawNid(canvas);
			}
			
			if(high && highCounter>0.5 && state==2)
			{
				MAT.identity();
				MAT.tx = dx-12;
				MAT.ty = dy-12;
				COLOR.alphaMultiplier = 2.0-highCounter*2.0;
				canvas.draw(media.imgHigh, MAT, COLOR, null, null, false);
			}
		}
		
		public function draw(canvas:BitmapData):void
		{
			if(state!=2)
			{
				MAT.identity();
				MAT.tx = MAT.ty = -10;
				MAT.scale(appear, appear);
				MAT.translate(dx, dy);
				canvas.draw(imgMain, MAT, null, null, null, true);
			}
			else
			{
				POINT.x = dx-10;
				POINT.y = dy-10;
				canvas.copyPixels(imgMain, RC, POINT);
			}
		}

		public function drawJump(canvas:BitmapData):void
		{
			var s:Number = 0.8+0.4*Math.sin(highCounter*1.57);
			
			if(state!=2)
				s*=appear;
			
			MAT.identity();
			MAT.tx = MAT.ty = -12;
			MAT.scale(s, s);
			MAT.translate(x, y);
			
			if(level.power>=0.5)
			{
				canvas.draw(imgMain, MAT, null, BlendMode.INVERT, null, true);
			}
			else
			{
				if(level.env.day)
					canvas.draw(imgMain, MAT, BLACK, null, null, true);
				else
					canvas.draw(imgMain, MAT, null, null, null, true);
			}
			
		}
		
		private function drawNid(canvas:BitmapData):void
		{
			MAT.identity();
			MAT.tx = -4;
			MAT.ty = 2;
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);
						
			canvas.draw(media.imgSmile1, MAT, null, null, null, true);
			
			MAT.identity();
			MAT.tx = -5;
			MAT.ty = -3;
			MAT.scale(appear, appear);
			MAT.translate(dx + hx, dy + hy);
			
			canvas.draw(media.imgEyes1, MAT, null, null, null, true);
		}
		
		private function drawEmoDefault(canvas:BitmapData, alpha:Number, angle:Number):void
		{
			COLOR.alphaMultiplier = alpha;
			
			MAT.identity();
			MAT.tx = -4;
			MAT.ty = 2;
			MAT.rotate(angle);
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);
			
			canvas.draw(media.imgSmile1, MAT, COLOR, null, null, true);
			
			MAT.identity();
			MAT.tx = -5;
			MAT.ty = -3;
			MAT.rotate(angle);
			MAT.scale(appear, appear);
			MAT.translate(dx + hx, dy + hy);
			
			canvas.draw(media.imgEyes1, MAT, COLOR, null, null, true);
		}
		
		private function drawEmoHappy(canvas:BitmapData):void
		{
			//var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -6.0, 1.0);
			var col:ColorTransform;
			var a:Number = 0.5;
			var ang:Number = emoCounter/3.0;
							
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
						
			if(emoParam>0.0)
				ang = 1.0 - ang;
				
			ang*=Math.abs(emoParam)*6.28;
		
			if(a<1.0) drawEmoDefault(canvas, 1.0 - a, ang);
			COLOR.alphaMultiplier = a;
			
			MAT.identity();
			MAT.tx = -6;
			MAT.ty = 1;
			MAT.rotate(ang);
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);
			
			canvas.draw(media.imgSmile3, MAT, COLOR, null, null, true);
			
			MAT.identity();
			MAT.tx = -7;
			MAT.ty = -5;
			MAT.rotate(ang);
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);
			
			canvas.draw(media.imgEyes2, MAT, COLOR, null, null, true);		
		}
		
		private function drawEmoShake(canvas:BitmapData):void
		{
			//var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -6.0, 1.0);
			//var col:ColorTransform;
			var a:Number = 0.5;
			var off:Number = Math.sin(emoCounter*6.28);
					
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
			
			if(a<1.0) drawEmoDefault(canvas, 1.0 - a, 0.0);
			COLOR.alphaMultiplier = a;
		
			if(off<0.0)
				off = 0.0;
			else if(off>=0.0)
				off = 0.5;
					
			MAT.identity();
			MAT.tx = -6;
			MAT.ty = 1;
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);

			
			
			canvas.draw(media.imgSmile3, MAT, COLOR, null, null, true);
			
			MAT.identity();
			MAT.tx = -7;
			MAT.ty = -5;
			MAT.scale(appear, appear);
			MAT.translate(dx, dy+off);
			
			canvas.draw(media.imgEyes2, MAT, COLOR, null, null, true);
		}
		
		private function drawEmoSmile(canvas:BitmapData):void
		{
			var a:Number = 0.5;
						
			if(emoCounter>2.5) a = 3.0 - emoCounter;
			else if(emoCounter<0.5) a = emoCounter;
			a*=2.0;
			
			if(a<1.0) drawEmoDefault(canvas, 1.0 - a, 0.0);
			COLOR.alphaMultiplier = a;
						
			MAT.identity();
			MAT.tx = -8;
			MAT.ty = 1;
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);
			
			canvas.draw(media.imgSmile2, MAT, COLOR, null, null, true);
					
			MAT.identity();
			MAT.tx = -5;
			MAT.ty = -3;
			MAT.scale(appear, appear);
			MAT.translate(dx, dy);	
		
			canvas.draw(media.imgEyes1, MAT, COLOR, null, null, true);
		}

	}
}