package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.ui.VersusCompleteMenu;

	public class ModeManager
	{
		private static var _instance:ModeManager;
		public static function get instance():ModeManager
		{
			if(!_instance)
				_instance = new ModeManager();
			return _instance;
		}
		
		private var _level:Level;
		
		private var _settings:ModeSettings = new ModeSettings();
		
		private var _startTimer:Number;
		private var _endTimer:Number;
		private var _time:Number;
		private var _plays:int;
		
		private var _profiles:Array = [];
		private var _wins:Array = [];
		
		public function ModeManager()
		{
		}
		
		public function reset():void
		{
			_profiles.length = 0;
			_wins.length = 0;
			_plays = 0;
			
			_settings.reset();
			
			_time = 0.0;
			_startTimer = 2.0;
			_endTimer = 2.0;
		}
		
		public function update(dt:Number):void
		{
			if(_startTimer > 0.0)
			{
				_startTimer -= dt;
				if(_startTimer <= 0.0)
				{
					_startTimer = 0.0;
					startEnd();
				}
			}
			else
			{
				_time += dt;
				if(_settings.timeout > 0.0 && _time >= _settings.timeout)
				{
					_time = _settings.timeout;
					onLevelEnd(getLeaderByFrags());
				}
			}
		}
		
		private function startEnd():void
		{
			createPlayers();
			_level.updateCameraTargets("player");
			_level.hud.redrawScores();
		}
		
		private function createPlayers():void
		{
			var i:int;
			
			if(ModeManager.instance.profiles.length == 0)
			{
				_level.scene.addActor(new Player(0, _level, null));
				_level.scene.addActor(new Player(1, _level, null));
			}
			else
			{
				for each(var profile:Object in ModeManager.instance.profiles)
				{
					_level.scene.addActor( new Player(i, _level, profile) );
					++i;
				}
			}
		}
		
		public function startBegin():void
		{
			_level.addChild(new FightTimer());
			_level.updateCameraTargets("start_point");
			_level.hud.redrawScores();
		}
		
		public function onFrag():void
		{
			var player:Player;
			var players:Vector.<Actor>;
			
			if(_settings.frags > 0)
			{
				players = _level.scene.getActorsByType("player");
				
				for each (player in players)
				{
					if(player.stats.frags >= _settings.frags)
					{
						onLevelEnd(getLeaderByFrags());
						return;
					}
				}
			}
		}
		
		public function onEscape(escaper:Player):void
		{
			if(_settings.type == ModeType.VERSUS_ESCAPING)
			{
				onLevelEnd(escaper);
			}
		}

		private function getLeaderByFrags():Player
		{
			var frags:int;
			var leader:Player;
			var player:Player;
			var players:Vector.<Actor> = _level.scene.getActorsByType("player");
			
			for each (player in players)
			{
				if(player.stats.frags > frags)
				{
					frags = player.stats.frags;
					leader = player;
				}
				else if(player.stats.frags == frags)
				{
					leader = null;
				}
			}
			
			return leader;
		}
		
		public function onLevelStart():void
		{
			_time = 0.0;
			if(_level)
			{
				_level.hud.h1.playerName = _profiles[0].name;
				_level.hud.h2.playerName = _profiles[1].name;
				
				if(_settings.type == ModeType.VERSUS_FIGHTING)
				{
					removeLocksAndDoors();
				}
				
				startBegin();
			}
		}

		private function removeLocksAndDoors():void
		{
			_level.scene.removeActorsByType("house");
			_level.scene.removeActorsByType("door");
		}

		public function onLevelEnd(winner:Player):void
		{
			if(_level.active)
			{
				_plays++;
				
				if(winner)
				{
					_wins[winner.id]++;
				}
				
				var screen:VersusCompleteMenu = Game.menu.getScreen("versus_complete") as VersusCompleteMenu;
				screen.setup(_level, winner);
				
				_level.exit();
				
				Game.menu.open("versus_complete");
			}
		}

		public function get totalTime():Number
		{
			return _time;
		}
		
		public function addProfile(profile:Object):void
		{
			if(profile)
			{
				_profiles.push(profile);
				_wins.push(0);
			}
		}

		public function get profiles():Array
		{
			return _profiles;
		}

		public function getPlayerWins(id:int):int
		{
			return _wins[id];
		}

		public function get plays():int
		{
			return _plays;
		}

		public function get level():Level
		{
			return _level;
		}

		public function set level(value:Level):void
		{
			_level = value;
		}

		public function get settings():ModeSettings
		{
			return _settings;
		}

		public function get startTimer():Number
		{
			return _startTimer;
		}

		
	}
}
