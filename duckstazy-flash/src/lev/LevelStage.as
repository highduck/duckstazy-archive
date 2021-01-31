package lev
{
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import lev.fx.StageMedia;
	
	public class LevelStage
	{
		// кол-во времени для прохождения
		public var goalTime:Number;
		
		// обратить флаг в true, если прошли уровень.
		public var win:Boolean;
		
		// уровень
		protected var level:Level;
		protected var pills:Pills;
		protected var particles:Particles;
		protected var hero:Hero;
		protected var env:Env;
		
		
		// 0 - накачай утку
		// 1 - бонус уровень (собирай данное время)
		// 2 - трип
		protected var type:int;
		
		protected var pumpProg:Number; // прогресс накачки 0->1 после power==1
		protected var pumpVel:Number; // скорость накачки
		public var collected:int;
		
		protected var startX:Number;
		protected var heroStarted:Boolean;
		
		public var media:StageMedia;
		
		protected var startTitle:BitmapData;
		protected var startCounter:Number;
		
		protected var end:Boolean;
		protected var endImg:BitmapData;
		protected var endCounter:Number;
				
		public function LevelStage(_type:int)
		{
			level = Level.instance;
			media = level.stageMedia;
			pills = level.pills;
			particles = level.pills.ps;
			hero = level.hero;
			env = level.env;
			
			if(_type==0)
			{
				goalTime = 2.0;
				pumpVel = 1.0;
			}
			else if(_type==1)
			{

			}
			else
			{

			}
			
			type = _type;
		}
		
		public function start():void
		{
			win = false;
			startCounter = 0.0;
			if(type==0)
			{
				startTitle = media.imgPump;
			}
			else if(type==1)
			{
				startTitle = media.imgParty;
			}
			else
				startTitle = media.imgTrip;
				
			pumpProg = 0.0;
			collected = 0;
			
			startX = Math.random()*(640-54);
			heroStarted = false;
			
			end = false;
		}
		
		public function onWin():void
		{
		}
		
		public function draw1(canvas:BitmapData):void
		{
			
		}
		
		public function draw2(canvas:BitmapData):void
		{
			var color:ColorTransform = new ColorTransform();
			var mat:Matrix = new Matrix();
			var a:Number = startCounter;
			var b:Number = startCounter;
			var text:TextField = level.infoText;
			
			if(startTitle!=null && a<5.0)
			{
				if(b>4.0) b = 5.0 - b;
				else if(b>2.0) b = 1.0;
				else b*=0.5;
				color.alphaMultiplier = b;
				mat.tx = 320 - startTitle.width*0.5;
				mat.ty = 180;
				canvas.draw(startTitle, mat, color);
				
				if(text.text.length!=0)
				{
					mat.tx = -text.textWidth*0.5;
					mat.ty = -text.textHeight*0.5;
					
					if(a<2)
						b = Math.sin(2.355*a/2)*1.4148;
					else if(a<4)
						b = 1.0;
					else
						b = 5.0-a;
						
					mat.scale(b, b);
					mat.translate(320, 230);
										
					canvas.draw(text, mat);
					
					if(a>4)
					{
						b = a-4;
						mat.identity();
						mat.tx = -text.textWidth*0.5;
						mat.ty = -text.textHeight*0.5;
						mat.scale(b, b);
						mat.translate(320, 410+text.textHeight*0.5);
						canvas.draw(text, mat);
					}
				}
			}
			else
			{
				if(text.text.length!=0)
				{
					mat.tx = 320 - text.textWidth*0.5;
					mat.ty = 410;
					canvas.draw(text, mat);
				}
			}
			
			if(end && endCounter<2)
			{
				mat.identity();
				mat.tx = 320 - endImg.width*0.5;
				mat.ty = 180;
				a = endCounter;

				if(a>1) color.alphaMultiplier = Math.cos(3.14*(a-1))*0.5+0.5;
				else color.alphaMultiplier = 1;
				
				canvas.draw(endImg, mat, color);
			}
		}
		
		public function update(dt:Number):void
		{
			var t:Number;
			var i:int;
			var str:String;
			
			
			if(!heroStarted)
			{
				heroStarted = true;
				hero.start(startX);
			}
			
			if(!win)
			{
				
				if(type==0)
				{
					level.progress.updateProgress(level.power+pumpProg);
					if(level.power>=1.0)
					{
						pumpProg+=dt*pumpVel;
						if(pumpProg>1.0)
							pumpProg = 1.0;
					}
					
					str = int(level.progress.perc*100).toString() + "%";
					if(level.infoText.text!= str) level.infoText.text = str;
				}
				else if(type==1)
				{
					level.progress.updateProgress(pumpProg);
					if(startTitle==null && pumpProg<goalTime)
					{
						pumpProg+=dt;
						if(pumpProg>goalTime)
							pumpProg = goalTime;
					}
					
					t = (1.0-level.progress.perc)*goalTime;
					i = t/60;
					if(i<10) str = "0" + i.toString() + ":";
					else str = i.toString() + ":";
					i = int(t)%60;
					if(i<10) str+="0"+ i.toString();
					else str+=i.toString();
					
					if(level.infoText.text!= str) level.infoText.text = str;
				}
				else if(type==2)
				{
					level.progress.updateProgress(collected);
					str = collected.toString() + " OF " + int(goalTime).toString();
					if(level.infoText.text!= str) level.infoText.text = str;
				}
				
				if(level.progress.full)
				{
					win = true;
					level.infoText.text = "";
					this.onWin();
					end = true;
					endImg = media.imgStageEnd;
					endCounter = 0.0;
				}
				else if(!end && hero.state.health<=0)
				{
					level.infoText.text = "";
					end = true;
					endImg = media.imgTheEnd;
					endCounter = 0.0;
				}
			}
			
			if(end)
				endCounter+=dt;
			
			if(startTitle!=null && startCounter<5.0)
			{
				startCounter+=dt;
				if(startCounter>=5.0)
				{
					startCounter = 5.0;
					startTitle = null;
				}
			}
		}
		
	}
}