package
{
	import flash.utils.getTimer;
	
	// тайминг такой ваще крутой нидаибацца
	public class GameTimer
	{
		
		// прошлое
		private var last:int;
		
		// миллисекунды
		public var ms:int;
		// секунды
		public var s:Number;
		
		public var fps:int;
		private var frames:int;
		private var framesTime:int;
		
		public function GameTimer()
		{
			reset();
		}
		
		public function reset():void
		{
			last = getTimer();
			ms = 1;
			s = 0.001;
	
			fps = 0;
			frames = 0;
			framesTime = 0;
		}
		
		public function update():void
		{
			var now:int = getTimer();
			       	
			ms = now - last;
			
			if(ms>300)
			{
				ms = 300;
				s = 0.3;
			}
			else if(ms<=0)
			{
				ms = 1;
				s = 0.001;
			}
			else
				s = ms*0.001;
						
			last = now;

			framesTime+=ms;
			frames++;
			
			if(framesTime>1000)
			{
				fps = frames;
				frames = 0;
				framesTime = 0;
			}
		}

	}
}