package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.base.Actor;

	public class PlayerStats
	{
		private var _owner:Player;
		
		private var _totalShots:int;
		private var _goodShots:int;
		
		private var _diveTotal:int;
		private var _diveHits:int;
		
		//private var _idle:int;
		private var _frags:int;
		private var _damageCaused:int;
		private var _damageTaken:int;
		private var _bonusCollected:int;

		public function PlayerStats(owner:Player)
		{
			_owner = owner;
		}

		public function onFire():void
		{
			_totalShots++;
		}
		
		public function onGoodShot():void
		{
			_goodShots++;
		}
		
		public function onDiveEnter():void
		{
			_diveTotal++;
		}
		
		public function onDiveHit():void
		{
			_diveHits++;
		}
		
		public function onBonusCollected():void
		{
			_bonusCollected++;
		}
		
		public function onDamage(killer:Actor, amount:int):void
		{
			_damageTaken += amount;
			
			if(killer)
			{
				var enemy:Player = killer as Player;
				if(enemy && enemy != _owner)
				{
					enemy.stats._damageCaused += amount;
				}
			}
		}

		public function onFrag(amount:int = 1):void
		{
			_frags+=amount;
		}

		public function get frags():int
		{
			return _frags;
		}

		public function get damageCaused():int
		{
			return _damageCaused;
		}

		public function get damageTaken():int
		{
			return _damageTaken;
		}

		public function get shotAccuracy():Number
		{
			if(_totalShots > 0)
				return _goodShots / _totalShots;
			return 0;
		}
		
		public function get diveAccuracy():Number
		{
			if(_diveTotal > 0)
				return _diveHits / _diveTotal;
			return 0;
		}

		public function get bonusCollected():int
		{
			return _bonusCollected;
		}
		
		

	}
}
