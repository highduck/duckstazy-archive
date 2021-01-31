package lev
{
	
	import flash.display.BitmapData;
	
	import lev.fx.FrogActor;
	import lev.fx.HintArrow;
	import lev.gen.Generator;
	import lev.gen.JumpStarter;
	import lev.gen.PartySetuper;
	import lev.gen.Placer;
	
	public class DoubleFrog extends LevelStage
	{
		private var frog1:FrogActor;
		private var frog2:FrogActor;
		private var frog1c:Number;
		private var frog2c:Number;
		private var frogGen1:Generator;
		private var frogGen2:Generator;
		
		private var gen:Generator;
		
		private var jumper:JumpStarter;
		private var setuper:PartySetuper;
		
		private var arrow1:HintArrow;
		private var arrow2:HintArrow;
		private var arrowHider:Number;
		
		public function DoubleFrog()
		{
			super(2);
			goalTime = 100.0;
			
			frog1 = new FrogActor(media);
			frog2 = new FrogActor(media);
			
			frog1.speedHands = 5.0;
			frog2.speedHands = 5.0;
			
			frog1.x = 0.0;
			frog2.x = 640.0-144.0;
			frog2.y = frog1.y = 400.0-64;
			
			arrow1 = new HintArrow(media);
			arrow2 = new HintArrow(media);

		}
		
		override public function start():void
		{
			var placer:Placer;
			
			super.start();
			
			setuper = new PartySetuper();
			setuper.userCallback = partyLogic;
			
			jumper = new JumpStarter();
			jumper.userCallback = jumpLogic;
			
			setuper.dangerH = 0.0;
			setuper.jump = 0.1;
			
			frogGen1 = new Generator();
			frogGen1.regen = true;
			frogGen1.speed = 4.0;
			placer = new Placer(setuper, 72, 346);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			frogGen1.map.push(placer);
			
			frogGen2 = new Generator();
			frogGen2.regen = true;
			frogGen2.speed = 4.0;
			placer = new Placer(setuper, 640-72, 346);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			frogGen2.map.push(placer);
			
			frog1c = 0.0;
			frog2c = 0.0;
			//frogGen1.finish();
			//frogGen2.finish();
			
			gen = new Generator();
			gen.regen = false;
			gen.speed = 4.0;

			gen.map.push(new Placer(jumper, 170, 380));
			gen.map.push(new Placer(jumper, 470, 380));
			
			arrow1.place(190, 360, 3.14*0.25, 0xfff7a0e1, true);
			arrow2.place(450, 360, -3.14*0.25, 0xfff7a0e1, true);
			arrow1.visibleCounter = 0.0;
			arrow2.visibleCounter = 0.0;
			arrow1.visible = true;
			arrow2.visible = true;
			arrowHider = 3.0;
			
			gen.start();
			
			startX = 293;
		}
		
		override public function onWin():void
		{
			gen.finish();
		}
		
		override public function update(dt:Number):void
		{
			var o:*;
			var i:int = 0;
			var p:Pill;
			
			super.update(dt);
			
			gen.update(dt);

			if(frog1.open && frog1.openCounter>=1.0)
			{
				frogGen1.update(dt);
				frog1c-=dt;
				if(frog1c<=0.0)
				{
					frog1c = 0.0;
					frog1.open = false;
				}
			}
			
			if(frog2.open && frog2.openCounter>=1.0)
			{
				frogGen2.update(dt);
				frog2c-=dt;
				if(frog2c<=0.0)
				{
					frog2c = 0.0;
					frog2.open = false;
				}
			}
			
			frog1.update(dt);
			frog2.update(dt);
			
			if(arrowHider>0.0)
			{
				arrowHider-=dt;
				if(arrowHider<=0.0)
				{
					arrow1.visible = arrow2.visible = false;
				}
			}
			
			arrow1.update(dt);
			arrow2.update(dt);
			
		}
		
		override public function draw1(canvas:BitmapData):void
		{
			frog1.draw(canvas);
			frog2.draw(canvas);
			arrow1.draw(canvas);
			arrow2.draw(canvas);
		}
		
		public function jumpLogic(pill:Pill, msg:String, dt:Number):void
		{
			var frog:FrogActor;
			if(msg=="jump")
			{
				if(pill.x>320)
				{
					frog = frog1;
					frog1c = 3.0;
				}
				else
				{
					frog = frog2;
					frog2c = 3.0;
				}
				
				if(frog.openCounter<=0.0)
					frog.open = true;
			}
		}
		
		public function partyLogic(pill:Pill, msg:String, dt:Number):void
		{
			var friction:Number = 0.7+level.power*0.3;
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
				pill.vx = (150.0+150.0*level.power)*(Math.random()*2.0-1.0);
				pill.vy = -100.0 - Math.random()*200.0 - 200.0*level.power;
			}
		}
	}
}
