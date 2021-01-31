package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.actors.Player;

	public class TestBehaviour extends Behaviour
	{
		public function TestBehaviour(ai:LahodaAI)
		{
			super(BehaviourType.TEST, ai);
		}

		override public function start():void
		{
			super.start();
			
			_timeLimit = 0.0;
		}
		
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			var enemy:Player = _player.getEnemy();
			
			_ai.targetActor = enemy;
		}

	}
}
