package com.ek.duckstazy.game
{
	import com.ek.duckstazy.edit.Editor;
	import com.ek.duckstazy.utils.GameRandom;

	public class LevelUtil
	{
		
		public static function createReplayLevel(replay:Replay):Level
		{
			var level:Level = new Level();
				
			level.load(replay.levelId);
			
			replay.rewind();
			level.replay = replay;
			level.replayMode = Replay.PLAY;
			GameRandom.seed = replay.seed;
			
			return level;
		}
		
		public static function createLevel(levelId:String):Level
		{
			var level:Level = new Level();
			var replay:Replay = new Replay();
			
			level.load(levelId);
			
			GameRandom.shuffle();
			replay.levelId = levelId;
			replay.seed = GameRandom.seed;
			
			level.replay = replay;
			level.replayMode = Replay.RECORD;
			
			return level;
		}
		
		public static function createEditor(levelId:String):Level
		{
			var level:Level = new Editor();

			level.load(levelId);
			
			return level;
		}

		public static function createXMLLevel(xml:XML):Level
		{
			var level:Level = new Level();
			var replay:Replay = new Replay();
			
			level.loadXML(xml);
			
			GameRandom.shuffle();
			replay.levelId = level.id;
			replay.seed = GameRandom.seed;
			
			level.replay = replay;
			level.replayMode = Replay.RECORD;
			
			return level;
		}
	}
}
