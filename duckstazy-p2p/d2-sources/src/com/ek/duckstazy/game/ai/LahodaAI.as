package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.actors.Spikes;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;

	/**
	 * @author lahoda
	 */
	public class LahodaAI extends BaseAI
	{
		private var _behaviours:BehaviourManager;
		
		private var _targetActor:Actor;

		public function LahodaAI(player:Player)
		{
			super(player);
			
			_behaviours = new BehaviourManager(this);
		}

		protected override function process(dt:Number):void
		{
			super.process(dt);

			_behaviours.update(dt);
		}		

		public function lookupSpikes():void
		{
			if(player.bonusUndead > 0.0) return;
			
			var actors:Vector.<Actor> = scene.grid.queryRect(player.x - player.width, player.y, player.width * 3, player.height * 2, ActorMask.ALL);
			var actor:Actor;
			var jump:Boolean;

			for each (actor in actors)
			{
				if (actor is Spikes)
				{
					if (moveDirection < 0)
						jump = actor.checkBox(player.x - player.width, player.y, player.width * 2, player.height * 2);
					else if (moveDirection > 0)
						jump = actor.checkBox(player.x, player.y, player.width * 2, player.height * 2);
					else
					{
						jump = actor.checkBox(player.x, player.y, player.width, player.height * 2);
						if (jump)
						{
							if (Math.random() > 0.5) moveDirection = -1;
							else moveDirection = 1;
						}
					}

					if (jump)
					{
						moveUp = true;
						break;
					}
				}
			}
		}

		public function lookupSideFighting():void
		{
			var enemy:Player = player.getEnemy();

			diving = false;
			shooting = false;

			if (!player.kicked && !player.pickedItem && enemy && !enemy.dead && enemy.bonusUndead <= 0.0)
			{
				if (player.canDive || player.dive)
				{
					// попадаем в противника
					if (enemy.checkBox(player.x - player.width, player.y + player.height, player.width * 3, enemy.y + enemy.height * 0.5 - player.y - player.height))
					{
						// TODO: нет препятствий
						if (scene.grid.queryRect(player.x - player.width, player.y + player.height, player.width * 3, enemy.y + enemy.height * 0.5 - player.y - player.height, ActorMask.BLOCK).length == 0)
						{
							diving = true;
							if (player.x > enemy.x)
								moveDirection = -1;
							else if (player.x < enemy.x)
								moveDirection = 1;
							else
								moveDirection = 0;
						}
					}
				}
	
				if (player.reload <= 0.0 && !enemy.kicked)
				{
					if(!player.checkPickUp())
					{
						if (enemy.checkBox(player.x - player.width * 3, player.y, player.width * 3, player.height * 2))
						{
							if(player.lookDir != -1)
							{
								moveDirection = -1;
							}
							shooting = (player.lookDir == -1);
						}
						else if (enemy.checkBox(player.x + player.width, player.y, player.width * 3, player.height * 2))
						{
							if(player.lookDir != 1)
							{
								moveDirection = 1;
							}
							shooting = (player.lookDir == 1);
						}
						
						
					}
					else
					{
						if(!diving && player.bottom > enemy.x - enemy.height*0.5)
						{
							moveUp = true;
						}
					}
				}
			}
		}
		
		public function avoidDiving():void
		{
			var enemy:Player = player.getEnemy();

			if (enemy && !enemy.dead && enemy.dive && enemy.bottom < player.y)
			{
				// противник попадает
				if (player.checkBox(enemy.x - enemy.width, enemy.bottom, enemy.width * 3, player.bottom - enemy.bottom))
				{
					if (player.x > enemy.x)
					{
						if(enemy.vx > 0)
							moveDirection = -1;
						else
							moveDirection = 1;
					}
					else
					{
						if(enemy.vx < 0)
							moveDirection = 1;
						else
							moveDirection = -1;
					}
					
					//moveUp = true;
				}
			}
		}

		public function get targetActor():Actor
		{
			return _targetActor;
		}

		public function set targetActor(value:Actor):void
		{
			if(_targetActor != value)
			{
				if(value)
					moveToActor(value);
				else
					stopMoving();
			}
			
			_targetActor = value;
		}

		public function get behaviours():BehaviourManager
		{
			return _behaviours;
		}
	}
}
