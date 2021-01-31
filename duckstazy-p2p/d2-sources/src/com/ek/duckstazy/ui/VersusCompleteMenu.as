package com.ek.duckstazy.ui
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.DisplayUtils;
	import com.ek.duckstazy.game.Game;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelUtil;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.actors.PlayerStats;
	import com.ek.duckstazy.game.base.Actor;

	import flash.events.Event;
	import flash.text.TextField;

	public class VersusCompleteMenu extends MenuScreen
	{
		private var _panel:Panel;
		
		private var _btnContinue:PushButton;
		private var _btnExit:PushButton;
		
		private var _stats:Array = [];
		private var _tfWin:TextField;
		private var _tfTime:TextField;
		
		public function VersusCompleteMenu()
		{
			super("versus_complete");
			
			const startY:int = Config.HEIGHT*0.5 - 50;
			
			_panel = new Panel(null, 0, startY);
			_panel.setSize(Config.WIDTH, 100);
			addChild(_panel);
			
			_btnContinue = new PushButton(_panel, Config.WIDTH*0.5, 20, "CONTINUE", onContinue);
			_btnExit = new PushButton(_panel, Config.WIDTH*0.5, 50, "END GAME", onExit);
			
			var tf:TextField;
			
			tf = DisplayUtils.createTextField(16, Player.COLORS[0]);
			addChild(tf);
			tf.multiline = true;
			tf.y = 70;
			_stats.push(tf);
			
			tf = DisplayUtils.createTextField(16, Player.COLORS[1]);
			addChild(tf);
			tf.multiline = true;
			tf.x = 300;
			tf.y = 70;
			_stats.push(tf);
			
			_tfWin = DisplayUtils.createTextField(20);
			addChild(_tfWin);
			_tfWin.x = 100;
			
			_tfTime = DisplayUtils.createTextField(16);
			addChild(_tfTime);
			_tfTime.x = 100;
			_tfTime.y = 26;
			
			acceptCallback = onContinue;
			escapeCallback = onExit;
		}

		private function onExit(e:Event):void
		{
			Game.menu.open("select_level");
		}

		private function onContinue(e:Event):void
		{
			var mm:ModeManager = ModeManager.instance;
			var level:Level;
			
			if(mm.getPlayerWins(0) >= mm.settings.rounds || mm.getPlayerWins(1) >= mm.settings.rounds)
			{
				onExit(null);
			}
			else
			{
				level = LevelUtil.createLevel( ModeManager.instance.level.id );
				Game.instance.startLevel(level);
			}
		}
		
		public function setup(level:Level, winner:Player):void
		{
			var mm:ModeManager = ModeManager.instance;
			
			if(winner)
			{
				_tfWin.text = "Player " + (winner.id+1) + " win!";
				_tfTime.text = "Total time: " + timeString(int(mm.totalTime));
			}
			else
			{
				_tfWin.text = "Withdraw!";
				_tfTime.text = "Timeout (" + timeString(int(mm.totalTime)) + ")";
			}
			
			var players:Vector.<Actor> = level.scene.getActorsByType("player");
			var player:Actor;
			
			for each(player in players)
			{
				if(player as Player)
				{
					readStats(player as Player);
				}
			}
			
			if(mm.getPlayerWins(0) >= mm.settings.rounds || mm.getPlayerWins(1) >= mm.settings.rounds)
			{
				_btnContinue.visible = false;
			}
			else
			{
				_btnContinue.visible = true;
			}
		}
		
		private function timeString(seconds:int):String
		{
			var text:String = "";
			var min:int = int(seconds/60);
			var sec:int = int(seconds%60);
			
			if(min > 0)
				text += min + " min. ";
			
			if(min > 0 && sec < 10)
				text += "0";
				
			text += sec + " sec.";
			
			return text;
		}

		private function readStats(player:Player):void
		{
			var stat:PlayerStats = player.stats;
			var tf:TextField = _stats[player.id];
			var text:String = "";
			
			text += player.profile.name;
			text += "\ndamage caused: " + stat.damageCaused;
			text += "\nfrags: " + stat.frags;
			text += "\nshot accuracy: " + int(stat.shotAccuracy*100) + "%";
			text += "\ndive accuracy: " + int(stat.diveAccuracy*100) + "%";
			text += "\nbonus collected: " + stat.bonusCollected;
			if(ModeManager.instance.getPlayerWins(player.id) > 0)
			{
				text += "\n";
				text += "\nWins: " + ModeManager.instance.getPlayerWins(player.id) + " / " + ModeManager.instance.settings.rounds;
			}
			
			tf.text = text;
		}

	}
}
