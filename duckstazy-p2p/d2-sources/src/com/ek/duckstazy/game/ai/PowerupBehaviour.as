package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.actors.Bonus;
	import com.ek.duckstazy.game.actors.BonusEffectType;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	/**
	 * @author eliasku
	 */
	public class PowerupBehaviour extends Behaviour
	{
		public function PowerupBehaviour(ai:LahodaAI)
		{
			super(BehaviourType.POWERUP, ai);
		}
		
		public override function start():void
		{
			super.start();
			
			_timeLimit = 10.0;
			//_retrackTime = 1.0;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			var actor:Actor;
			var actors:Vector.<Actor>;
			var bonuses:Array = [];
			var bonus:Bonus = _ai.targetActor as Bonus;
			var enemy:Player = _player.getEnemy();
			var exit:Boolean;

			_ai.lookupSideFighting();
			
			if(bonus && bonus.dead && Math.random() > 0.5)
			{
				_ai.behaviours.gotoSomethingElse();
				bonus = null;
			}
			else
			{
				_timer = 0.0;
			}
			
			if (!bonus || bonus.dead)
			{
				actors = _player.scene.getActorsByType("bonus");
				for each (actor in actors)
				{
					if (actor && actor is Bonus && !actor.dead)
					{
						bonus = actor as Bonus;
						
						if(bonus.effect == BonusEffectType.STEAL && enemy && enemy.home.buns.length == 0)
							continue;
							
						if(bonus.effect == BonusEffectType.SHARK && enemy && enemy.bonusUndead > 0)
							continue;
							
						bonuses.push(actor as Bonus);
					}
				}
				
				bonus = null;
				bonuses.sort(_ai.sortOnDistanceToPlayer);
				if(bonuses.length > 0) bonus = bonuses[0];
			}
			
			if(!bonus)
			{
				exit = true;
				bonus = null;
			}
			
			_ai.targetActor = bonus;
			if(!_ai.movePath)
			{
				exit = true;
			}
			
			if(exit)
			{
				if(_player.pickedItem)
				{
					_ai.behaviours.goto(BehaviourType.TRANSFER);
				}
				else
				{
					_ai.behaviours.gotoSomethingElse();
				}
			}
			
			testEnemyDanger();
			
			_ai.lookupSpikes();
			_ai.avoidDiving();
		}
	}
}
