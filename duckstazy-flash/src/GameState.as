package
{
	public class GameState
	{
		/*** Грейды ***/
		public var def:int; // коэффициент урона
		public var maxHP:int; // максимальное здоровье
		public var hell:int;
		public var norm:int;
		
		/*** Герой ***/
		public var health:int;
		
		/*** Уровень ***/
		public var level:int;
	
		public var scores:int;
		
		public function GameState()
		{
			reset();
		}
		
		
		// Все вернуть как сначала.
		public function reset():void
		{
			def = 0;
			maxHP = 25;
			norm = 0;
			hell = 0;
			
			health = maxHP;
			
			level = 0;
			
			scores = 0;
		}
		
		// присвоить
		public function assign(state:GameState):void
		{
			def = state.def;
			maxHP = state.maxHP;
			norm = state.norm;
			hell = state.hell;
					
			health = state.health;
			
			level = state.level;
			
			scores = state.scores;
		}
			
		public function calcHellScores(id:int):int
		{
			var i:int = 1;
			
			switch(id)
			{
				case 0: i = 5; break;
				case 1: i = 10; break;
				case 2: i = 25; break;
				case 3: i = 50; break;
				case 4: i = 100; break;
				case 5: i = 150; break;
			}
			return i;
		}

	}
}