package com.ek.duckstazy.game.ai
{
	import com.ek.duckstazy.game.actors.Player;
	/**
	 * @author eliasku
	 */
	public class Behaviour
	{
		private var _type:String;
		protected var _ai:LahodaAI;
		protected var _player:Player;
		
		protected var _timer:Number = 0.0;
		protected var _timeLimit:Number = 0.0;
		
		protected var _retrack:Number = 0.0;
		protected var _retrackTime:Number = 1.0;
		
		protected var _startHP:int;
		
		public function Behaviour(type:String, ai:LahodaAI)
		{
			_type = type;
			_ai = ai;
			_player = ai.player;
		}

		public function start():void
		{
			_retrack = 0.0;
			_timer = 0.0;
			_timeLimit = 0.0;
			_retrackTime = 1.0;
			_startHP = _player.health;
			_ai.targetActor = null;
		}
		
		public function update(dt:Number):void
		{
			
		}
		
		public function handleTimers(dt:Number):void
		{
			_timer += dt;
			_retrack += dt;
			
			if(_retrack >= _retrackTime)
			{
				_retrack = 0.0;

				if(_ai.targetActor && !_ai.targetActor.dead)
				{
					_ai.moveToActor(_ai.targetActor);
				}
				else
				{
					_ai.stopMoving();
				}
			}
		}

		public function get timeLimit():Number
		{
			return _timeLimit;
		}

		public function get retrackTime():Number
		{
			return _retrackTime;
		}

		public function get type():String
		{
			return _type;
		}
		
		public function testEnemyDanger():Boolean
		{
			var enemy:Player = _player.getEnemy();
			
			if(_startHP > _player.health && enemy.distanceTo(_player) < 300)
			{
				_ai.behaviours.goto(BehaviourType.FIGHT);
				return true;
			}
			return false;
		}

		public function get timer():Number
		{
			return _timer;
		}

		
		
	}
}
