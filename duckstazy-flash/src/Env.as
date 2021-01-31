package
{
	import Envi.*;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Env
	{
		// Импорт графических ресурсов
		[Embed(source="gfx/cloud1.png")]
        private var rCloudImg1:Class;
        
		[Embed(source="gfx/cloud2.png")]
        private var rCloudImg2:Class;
        
        [Embed(source="gfx/cloud3.png")]
        private var rCloudImg3:Class;
        
        [Embed(source="gfx/grass.png")]
        private var rGrassImg:Class;
        
        [Embed(source="gfx/grass2.png")]
        private var rGrass2Img:Class;
        
        [Embed(source="gfx/fx_star.png")]
        private var rStarImg:Class;
        
        //[Embed(source="sfx/tex2.mp3")]
        //private var rTex1Snd:Class;
        
        [Embed(source="sfx/tex3.mp3")]
        private var rTex2Snd:Class;
        
        [Embed(source="sfx/power.mp3")]
        private var rPowerSnd:Class;
                
		private var imgClouds:Array;
		private var imgGrass:BitmapData;
		private var imgGrass2:BitmapData;
		private var imgGround:BitmapData;
		private var imgStar:BitmapData;
		private var imgSky:BitmapData;
		
		private var sndPower:Sound;
		//private var sndTex1:Sound;
		private var sndTex2:Sound;
		private var music:Sound;
		private var musicLenght:Number;
		private var channel:SoundChannel;
		private var musicTrans:SoundTransform;
		private var musicAttack:Number;
		public var x:Number;
		public var y:Number;
		
		public var blanc:Number;
		private var shBlanc:Shape;
		
		// Состояние окружения
		private var power:Number;
		
		// Время для нормального состояния. Циклит для смены ДЕНЬ/НОЧЬ
		public var day:Boolean;
		// Время для глюков. Циклит палитру.
		private var time:Number;
		
		
		
		// Счётчик для эффекта с травой
		private var grassCounter:Number;		
		
		// Облака
		private var clouds:Array;
		private var nightSky:Array;
		
		private var norm:EnvColor;
			
		private const hell:Array = [
			new EnvColor(0xFF0000, 0xFFFF00), 
			new EnvColor(0xFFFF00, 0xFF0000), 
			new EnvColor(0x00FF00, 0x0000FF),
			new EnvColor(0x00FFFF, 0xFFFF00),
			new EnvColor(0x0000FF, 0xFFFF00),
			new EnvColor(0xFF00FF, 0xFFFF00),
			new EnvColor(0xFF0000, 0xFFFF00)];
			
		private const hellCount:int = 7;
			
		// Текущие цвета.
		public var colors:EnvColor;
		
		public var colGrass:uint;
		public var colGround:uint;
		public var colProgress:uint;
		
		public var ctGrass:ColorTransform;
		public var ctProgress:ColorTransform;
				
		// Темп-переменная для рисования
		private var shape:Shape;
		
		// эффекты
		private var effects:Array;
		private var curEffect:EnvEffect;
		
		public function Env()
		{
			// Временные переменные.
			var x:Number = 0;
			var i:int;
			
			shape = new Shape();
			norm = new EnvColor(0x3FB5F2, 0x000000);
			
			// Текущие цвета
			colors = new EnvColor(0,0);
			
			effects = [new EnvEffect1(), new EnvEffect2(), new EnvEffect3(), new EnvEffect4()];	
			
			shBlanc = new Shape();
			
			blanc = 0.0;
			// Инициализируем траву
			grassCounter = 0.0;
			
			// Инициализируем переменные окружения
			power = 0.0;
			day = true;
			updateNorm();
			time = 0.0;
						
			
			
			// Инициализируем
			initGrass();
			initDay();
			initNight();
			
			curEffect = effects[3];//effects[int(Math.random()*effects.length)];
			
			colGrass = 0xff00ff00;
			colGround = 0xff371d06;
			colProgress = 0xff5d310c;
			ctGrass = new ColorTransform();
			utils.ARGB2ColorTransform(colGrass, ctGrass);
			ctProgress = new ColorTransform();
			utils.ARGB2ColorTransform(colProgress, ctProgress);
			
			sndPower = new rPowerSnd();
			//sndTex1 = new rTex1Snd();
			sndTex2 = new rTex2Snd();
			
			musicTrans = new SoundTransform(0);
			
			music = sndTex2;
			channel = music.play(0.0, 0, musicTrans);
			channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
			musicAttack = 0.0;
		}
	
		private function initGrass():void
		{
			var rc:Rectangle = new Rectangle(0, 0, 128, 16);
			var data:BitmapData = (new rGrassImg()).bitmapData;
			var data2:BitmapData = (new rGrass2Img()).bitmapData;
			var dest:Point = new Point();
			var i:int = 5;
			var mat:Matrix = new Matrix();
			mat.createGradientBox(640, 80, 1.57, 0, 0);
			
			imgGrass = new BitmapData(640, 8, true, 0x00000000);
			imgGrass2 = new BitmapData(640, 8, true, 0x00000000);
			imgGround = new BitmapData(640, 80, false, 0x00000000); 
			imgGrass.lock();
			imgGrass2.lock();
			
			while(i>0)
			{
				imgGrass.copyPixels(data, rc, dest, null, null, true);
				imgGrass2.copyPixels(data2, rc, dest, null, null, true);
				dest.x+=128.0;
				--i;
			} 

			imgGrass.unlock();
			imgGrass2.unlock();
			
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0x371d06, 0x5d310c], [1.0, 1.0], [0x00, 0xFF], mat);
			shape.graphics.drawRect(0.0, 0.0, 640.0, 80.0);
			shape.graphics.endFill();
			imgGround.draw(shape);
		}
			
		private function initDay():void
		{
			var x:Number = 0.0;
			var mat:Matrix = new Matrix();
			mat.createGradientBox(640, 400, 1.57, 0, 0);
		
			shape.graphics.clear();
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0x3FB5F2, 0xDDF2FF], [1.0, 1.0], [0x00, 0xFF], mat);
			shape.graphics.drawRect(0.0, 0.0, 640.0, 480.0);
			shape.graphics.endFill();
			
			imgSky = new BitmapData(640, 400, false);
			imgSky.draw(shape);
			
			imgClouds = [(new rCloudImg1()).bitmapData, (new rCloudImg2()).bitmapData, (new rCloudImg3()).bitmapData];
			
			clouds = [new EnvCloud(), new EnvCloud(), new EnvCloud(), new EnvCloud(), new EnvCloud()];
			
			for each (var it:EnvCloud in clouds)
			{
				it.init(x);
				x+=128.0 + Math.random()*22.0;
			}
			
		}
		
		private function initNight():void
		{
			var o:*;
			var i:int = 30;
			
			imgStar = (new rStarImg()).bitmapData;

			nightSky = new Array(30);

			while(i>0)
			{
				nightSky[i] = new EnvStar();
				--i;
			}

		}
		
		public function updateNorm():void
		{
			if(day)
			{
				norm.bg = 0x3FB5F2;
				norm.text = 0x000000;
			}
			else
			{
				norm.bg = 0x111133;
				norm.text = 0xFFFFFF;
			}
		}
		
		private function updateColors():void
		{
			//var pal:EnvColor = new EnvColor(0,0);
			var c:int;
			var x:Number = time;
			var p2:Number = power*power;
		
			c = int(x);	x-=c;
			//pal.lerp(x, hell[c], hell[c+1]);
			colors.lerp(x, hell[c], hell[c+1]);
			//colors.lerp(power, norm, pal);
				
			colGrass = 0xff000000|utils.lerpColor(utils.multColorScalar(0x177705, 1.0-p2), colors.bg, p2*grassCounter);
			colGround = 0xff000000|utils.lerpColor(0x371d06, utils.multColorScalar(colors.bg, grassCounter*power), p2);
			colProgress = 0xff000000|utils.lerpColor(0x5d310c, colors.bg, p2);
			
			utils.ARGB2ColorTransform(colGrass, ctGrass);
			utils.ARGB2ColorTransform(colProgress, ctProgress);		
		}
						
		public function update(dt:Number, newPower:Number):void
		{
			// Временные переменные.
			var x:Number;
			var i:int;
			var st:SoundTransform;
			
			if(newPower!=power)
			{
				if(newPower>=0.5 && power<0.5)
				{
					day = !day;
					updateNorm();
					blanc = 1.0;
					
					/*x = channel.position;
					channel.stop();
					channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
					music = sndTex2;
					channel = music.play(x);
					channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);*/
					musicTrans.volume = 1;
					channel.soundTransform = musicTrans;
					
					sndPower.play();
				}
				else if(power>=0.5 && newPower<0.5)
				{
					blanc = 1.0;
					colGrass = 0xff00ff00;
					colGround = 0xff371d06;
					colProgress = 0xff5d310c;
					utils.ARGB2ColorTransform(colGrass, ctGrass);
					utils.ARGB2ColorTransform(colProgress, ctProgress);
					curEffect = effects[int(Math.random()*effects.length)];
					
					/*x = channel.position;
					channel.stop();
					channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
					music = sndTex2;
					channel = music.play(x);
					channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);*/
				}
				
				power = newPower;
				
				if(power<0.5)
				{
					musicTrans.volume = power*0.3;
					channel.soundTransform = musicTrans;
				}
			}
			
			/*if(channel.position >= 63900.0)
			{
				st = channel.soundTransform;
				
				channel.stop();
				channel = music.play(0.0, 0, st);
			}*/

			// Обноляем счётчик с травой
			if(grassCounter>0)
			{
				grassCounter-=dt*4.0;
				if(grassCounter<0.0)
					grassCounter = 0.0;
			}
			
			if(power<0.5)
			{
				if(day)
					for each (var c:EnvCloud in clouds)
					    c.update(dt, power);
				else
					for each (var s:EnvStar in nightSky)
					    s.update(dt, power);
			}
			else
			{
				curEffect.power = power;
				curEffect.c1 = colors.bg;
				curEffect.c2 = utils.multColorScalar(colors.bg, 0.5);
				curEffect.update(dt);
				// Прокручиваем время день/ночь
				time+=dt*0.1;
				while(time>hellCount-1)
				time-=hellCount-1;
				
				x = (channel.leftPeak + channel.rightPeak)*0.5;
				// Обновляем текущие цвета
				updateColors();
								
				/*if(musicAttack<x)
					musicAttack = x;
				else if(musicAttack>0.0)
				{
					musicAttack-=dt*10.0;
					if(musicAttack<0.0)
						musicAttack = 0.0;
				}*/
				musicAttack = musicAttack*0.7 + x*0.7;
				
				curEffect.peak = musicAttack;
			}

		}

		public function draw1(canvas:BitmapData):void
		{
			// Временные переменные.
			var rc:Rectangle = new Rectangle(0.0, 0.0, 640.0, 400.0);
			var gr:Graphics = shape.graphics;
			
			
			
			if(power<0.5)
			{
				if(day)
				{
					canvas.copyPixels(imgSky, rc, new Point(0.0, 0.0));
					 
					drawSky(canvas);
				}
				else
				{
					canvas.fillRect(rc, 0x111133);
					drawNight(canvas);
				}
			}
			else
			{
				curEffect.draw(canvas);
				gr.clear();
				gr.beginFill(colors.bg, 0.4*musicAttack);
				gr.drawCircle(613.0 - x, 380.0 - y, musicAttack*30.0);
				gr.drawCircle(320.0 - (x - 293.0)*0.97, 200.0 - (y - 180.0)*0.97, musicAttack*25.0);
				gr.drawCircle(320.0 + (x - 293.0)*0.7, 200.0 + (y - 180.0)*0.7, musicAttack*10.0);
				gr.endFill();
				canvas.draw(shape);
				//canvas.applyFilter(canvas, new Rectangle(0, 0, 640, 400), new Point(), new ConvolutionFilter(3,3,null, 9));
			}
			
			
		}
		
		public function drawNight(canvas:BitmapData):void
		{
			// Временные переменные.
			var x:Number;
			var mat:Matrix = new Matrix();
			var o:*;
			var c:EnvStar;
			
			// Рисуем ОБЛАКА
			for each (o in nightSky)
			{
				c = EnvStar(o);
				x = c.t;
								
				mat.identity();
				mat.translate(-7.0, -7.0);
				mat.rotate(c.a);
				mat.scale(0.75 + 0.25*Math.sin(x*6.28), 0.75 + 0.25*Math.sin(x*6.28));
				mat.translate(c.x, c.y);
				
				canvas.draw(imgStar, mat, c.color, null, null, true);
			}
		}
		
		public function drawSky(canvas:BitmapData):void
		{
			// Временные переменные.
			var x:Number;
			var mat:Matrix = new Matrix();
			var img:BitmapData;
			
			// Рисуем ОБЛАКА
			for each (var c:EnvCloud in clouds)
			{
				x = c.counter;
				img = BitmapData(imgClouds[c.id]); 
				
				mat.identity();
				mat.translate(-img.width*0.5, -img.height*0.5);
				mat.scale(0.9 + 0.1*Math.sin(x*6.28), 0.95 + 0.05*Math.sin(x*6.28 + 3.14));
				mat.translate(c.x, c.y);
				
				canvas.draw(img, mat, null, null, null, true);
			}
		}
	
		public function draw2(canvas:BitmapData):void
		{
			// Временные переменные.
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, 0.0, 392.0);
			var rc:Rectangle = new Rectangle(0.0, 400.0, 640.0, 80.0);
			
			/**** ОСНОВА ДЛЯ ЗЕМЛИ ****/
			
			
			
			/**** ТРАВА ****/
			
			if(power<0.5)
			{
				// TODO Optimize
				canvas.draw(imgGround, new Matrix(1.0, 0.0, 0.0, 1.0, 0.0, 400.0));
				canvas.draw(imgGrass, mat, ctGrass);
			}
			else
			{
				canvas.fillRect(rc, colGround);
				canvas.draw(imgGrass2, mat, ctGrass);
			}	
		}

		public function beat():void
		{
			grassCounter = 1.0;
		}
		
		public function updateBlanc(dt:Number):void
		{
			if(blanc>0.0)
				blanc-=0.5*dt;
		}
		
		public function drawBlanc(canvas:BitmapData):void
		{
			shBlanc.graphics.clear();
			shBlanc.graphics.beginFill(0xffffff, blanc);
			shBlanc.graphics.drawRect(0.0, 0.0, 640.0, 480.0);
			shBlanc.graphics.endFill();
			canvas.draw(shBlanc);
		}

		public function loopMusic(e:Event):void
		{
			if(power<0.5)
				musicTrans.volume = power*0.3;
				
		    if(channel!=null)
		    {
		    	channel.stop();
		        channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
				channel = music.play(0.0, 0, musicTrans);
				channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
		    }
		}
	}
}