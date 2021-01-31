package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.actors.Player;
	/**
	 * @author eliasku
	 */
	public class BehaviourManager
	{
		public static const BEHAVIOURS:Array = [BehaviourType.TRANSFER, BehaviourType.POWERUP, BehaviourType.FIGHT];
		
		private var _ai:LahodaAI;
		
		private var _behaviours:Object = new Object();
		
		private var _current:Behaviour;
	
		public function BehaviourManager(ai:LahodaAI)
		{
			_ai = ai;
			
			_behaviours[BehaviourType.TRANSFER] = new TransferBehaviour(ai);
			_behaviours[BehaviourType.POWERUP] = new PowerupBehaviour(ai);
			_behaviours[BehaviourType.FIGHT] = new FightBehaviour(ai);
			//_behaviours[BehaviourType.TEST] = new TestBehaviour(ai);
			
			//gotoRandom();
			goto(BehaviourType.TRANSFER);
		}

		public function update(dt:Number):void
		{
			/*var g:Graphics = _ai.player.content.graphics;
			g.clear();
			if(_current)
			{
				if(_current.type == BehaviourType.FIGHT)
				{
					g.lineStyle(2, 0xff0000);
				}
				else if(_current.type == BehaviourType.POWERUP)
				{
					g.lineStyle(2, 0xffff00);
				}
				else if(_current.type == BehaviourType.TRANSFER)
				{
					g.lineStyle(2, 0x00ff00);
				}
				else
				{
					g.lineStyle(2, 0x000000);
				}
				
				g.drawCircle(30, -30, 8);
			}*/
			
			if(_current)
			{			
				_current.update(dt);
				_current.handleTimers(dt);
			}
			
			checkEnv();
		}

		private function checkEnv():void
		{
			var enemy:Player = _ai.player.getEnemy();
			
			if(enemy && enemy.home)
			{
				if(enemy.home.buns.length >= 4 || (enemy.home.buns.length >= 3 && enemy.pickedItem))
				{
					if(enemy.dead || enemy.bonusUndead > 0.0 || _ai.player.checkActor(enemy.home))
					{
						if(!isCurrentBehaviour(BehaviourType.TRANSFER))
					 	{
					 		goto(BehaviourType.TRANSFER);
					 	}
					}
					else
					{
						if(!isCurrentBehaviour(BehaviourType.FIGHT))
					 	{
					 		goto(BehaviourType.FIGHT);
					 	}
					}
				}
			}
		}
		
		public function goto(type:String):void
		{
			// start behaviour
			_current = _behaviours[type];
			if(_current)
			{
				_current.start();
			}
			else
			{
				trace("WRONG TYPE");
			}
		}
		
		public function isCurrentBehaviour(type:String):Boolean
		{
			return _current && _current.type == type;
		}
		
		public function gotoSomethingElse():void
		{
			if(!_current)
			{
				gotoRandom();
			}
			else
			{
				var arr:Array = BEHAVIOURS.concat();
				arr.splice(arr.indexOf(_current.type), 1);
				if(arr.length > 0)
				{
					goto(arr[int(Math.random()*arr.length)]);
				}
				else
				{
					trace("WRONG TYPE");
				}
			}
			
		}

		private function gotoRandom():void
		{
			goto(BEHAVIOURS[int(Math.random()*BEHAVIOURS.length)]);
		}
	}
}
