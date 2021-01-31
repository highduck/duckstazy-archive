package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	/**
	 * @author eliasku
	 */
	public class FightBehaviour extends Behaviour
	{
		public function FightBehaviour(ai:LahodaAI)
		{
			super(BehaviourType.FIGHT, ai);
			
			
		}
		
		public override function start():void
		{
			super.start();
			
			_timeLimit = 1.0 + 4.0*Math.random();
			_retrackTime = 0.25;
			
			if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
			{
				_timeLimit = 5.0 + 10.0*Math.random();
			}
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			var enemy:Player = _player.getEnemy();
			
			_ai.diving = false;
			_ai.shooting = false;

			if(!enemy || enemy.dead || enemy.bonusUndead > 0.0)
			{
				_ai.behaviours.gotoSomethingElse();
				return;
			}
			
			if(_player.pickedItem)
			{
				_ai.shooting = true;
				return;
			}
			
			_ai.targetActor = enemy;

			if (_player.reload <= 0.0 && !enemy.kicked)
			{
				if(!_player.checkPickUp())
				{
					if (enemy.checkBox(_player.x - _player.width * 3, _player.y, _player.width * 3, _player.height * 2))
					{
						if(_player.lookDir != -1)
						{
							_ai.moveDirection = -1;
						}
						_ai.shooting = (_player.lookDir == -1);
					}
					else if (enemy.checkBox(_player.x + _player.width, _player.y, _player.width * 3, _player.height * 2))
					{
						if(_player.lookDir != 1)
						{
							_ai.moveDirection = 1;
						}
						_ai.shooting = (_player.lookDir == 1);
					}
				}
			}
			
			if(testSpaceBetween(_player, enemy))
			{
				if ((_player.canDive || _player.dive) && _player.bottom < enemy.y && enemy.checkBox(_player.x - _player.width, _player.bottom, _player.width * 3, _player.height * 10))
				{
					_ai.diving = true;
					if (_player.x > enemy.x)
						_ai.moveDirection = -1;
					else if (_player.x < enemy.x)
						_ai.moveDirection = 1;
					else
						_ai.moveDirection = 0;
				}
				
				if(!_ai.diving)
				{
					var jh:Number = _player.getJumpHeight();
					if(_player.y > enemy.bottom)
					{
						if(jh >= _player.y - enemy.bottom)
							_ai.moveUp = true;
					}
					else
					{
						if (_player.x > enemy.x)
							_ai.moveDirection = -1;
						else if (_player.x < enemy.x)
							_ai.moveDirection = 1;
						else
							_ai.moveDirection = 0;
						
						if(jh > 10)
							_ai.moveUp = true;
					}
				}
			}
			
			_ai.avoidDiving();
			_ai.lookupSpikes();
		}
		
		public function testSpaceBetween(a:Actor, b:Actor):Boolean
		{
			var minX:Number = Math.min(a.x, b.x);
			var minY:Number = Math.min(a.y, b.y);
			var maxX:Number = Math.max(a.right, b.right);
			var maxY:Number = Math.max(a.bottom, b.bottom);
			
			return _ai.testFreeRectangle(minX, minY, maxX - minX, maxY - minY);
		}
	}
}
