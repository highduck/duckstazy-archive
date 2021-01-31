package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.actors.Bun;
	import com.ek.duckstazy.game.actors.Door;
	import com.ek.duckstazy.game.base.Actor;
	/**
	 * @author eliasku
	 */
	public class TransferBehaviour extends Behaviour
	{
		private var _waitKeys:Array = new Array();
		
		public function TransferBehaviour(ai:LahodaAI)
		{
			super(BehaviourType.TRANSFER, ai);
		}
		
		public override function start():void
		{
			super.start();
			
			_timeLimit = 20.0;
			_retrackTime = 1.0;
			_waitKeys.length = 0;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
			{
				_ai.behaviours.gotoSomethingElse();
				return;
			}
			
			var actor:Actor;
			var key:Bun;
			var targetKey:Bun = _ai.targetActor as Bun;
			var dropSide:int;
			var ignoreSpikes:Boolean;
			
			_ai.lookupSideFighting();
			
			refreshWaitKeys();
			
			if (_player.home.buns.length >= 4 - _waitKeys.length)
			{
				_ai.targetActor = Door.getDoor(_player.scene, _player.id);
				// TODO: lock timeout exit - canExit getter?
			}
			else if (_player.pickedItem)
			{
				dropSide = testDrop();
				if(dropSide != 0)
				{
					ignoreSpikes = true;
					if(_player.lookDir != dropSide)
					{
						_ai.moveDirection = dropSide;
					}
					_ai.shooting = !_ai.shooting && (dropSide*_player.lookDir > 0);
					if(_ai.shooting)
					{
						_waitKeys.push(_player.pickedItem);
						if(_player.home.buns.length >= 3)
						{
							_timer = 0.0;
						}
						_ai.targetActor = null;
					}
				}
				else
				{
					_ai.targetActor = _player.home;
	
					if(_player.pickedItem.checkBox(_player.home.x, _player.home.y, _player.home.width, _player.home.height))
					{
						_ai.shooting = !_ai.shooting;
						if(_ai.shooting)
						{
							if(_player.home.buns.length >= 4)
							{
								_timer = 0.0;
							}
							else if(_player.home.buns.length > 0)
							{
								_ai.behaviours.gotoSomethingElse();
							}
							
							_ai.targetActor = null;
						}
					}
				}
				
				testEnemyDanger();
			}
			else
			{
				var keys:Array = [];
				if (!targetKey || (targetKey.carrier && targetKey.carrier != _player) || targetKey.house == _player.home)
				{
					targetKey = null;
					
					for each (actor in _player.scene.getActorsByType("bun"))
					{
						key = actor as Bun;
						if (key && !key.dead && !key.carrier && key.house != _player.home && !isKeyForWait(key))
						{
							keys.push(key);
						}
						
						keys.sort(_ai.sortOnDistanceToPlayer);
					}
					
					if (keys.length > 0) targetKey = keys[0];
				}

				_ai.targetActor = targetKey;

				if (targetKey)
				{
					if(!_ai.shooting)
					{
						key = _player.checkPickUp();
						if(key && !isKeyForWait(key))
						{
							_ai.shooting = true;//.checkBox(_player.x, _player.y, _player.width, _player.height);
						}
					}
					testEnemyDanger();
				}
				else
				{
					_ai.behaviours.gotoSomethingElse();
				}
			}
			
			_ai.lookupSpikes();
			_ai.avoidDiving();
		}

		private function testDrop():int
		{
			if(_player.pickedItem)
			{
				if(_player.pickedItem.aiSuccessfulDropPrediction(_player, _player.lookDir))
					return _player.lookDir;
				if(_player.pickedItem.aiSuccessfulDropPrediction(_player, -_player.lookDir))
					return -_player.lookDir;
			}
			
			return 0;
		}
		
		private function refreshWaitKeys():void
		{
			var i:int;
			var key:Bun;
			while(i < _waitKeys.length)
			{
				key = _waitKeys[i];
				if(key && (key.house || key.carrier || key.velocity <= 0.01))
				{
					_waitKeys.splice(i, 1);
					continue;
				}
				++i;
			}
		}
		
		private function isKeyForWait(key:Bun):Boolean
		{
			return _waitKeys.indexOf(key) >= 0;
		}
	}
}
