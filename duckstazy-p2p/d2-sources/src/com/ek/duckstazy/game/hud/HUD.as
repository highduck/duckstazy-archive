package  
com.ek.duckstazy.game.hud
{
	import com.ek.duckstazy.effects.LightEffect;
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.DisplayUtils;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.gocs.GameObject;
	import com.ek.library.utils.StringUtil;

	import flash.display.Sprite;
	import flash.text.TextField;










	/**
	 * @author eliasku
	 */
	public class HUD extends GameObject 
	{
		private var _level:Level;
		
		private var _debug:Sprite;
		private var _energySpr:Sprite = new Sprite();
		
		
		private var _light:LightEffect;
		
		private var _h1:HealthBar;
		private var _h2:HealthBar;
		private var _tfTime:TextField;
			
		public function HUD(level:Level)
		{
			super();
			
			mouseChildren = false;
			mouseEnabled = false;
			
			name = "hud";
			
			_level = level;
			
			_light = new LightEffect(Config.WIDTH, Config.HEIGHT);
			addChild(_light);
			
			_debug = new Sprite();
			_debug.mouseChildren = false;
			_debug.mouseEnabled = false;
			addChild(_debug);
			_debug.addChild(_energySpr);

			_h1 = new HealthBar();
			_h1.playerColor = Player.COLORS[0];
			_h1.side = 1;
			
			_h2 = new HealthBar();
			_h2.playerColor = Player.COLORS[1];
			_h2.side = 0;
			
			_h1.frags = 0;
			_h2.frags = 0;
			
			_tfTime = DisplayUtils.createTextField();
			_tfTime.text = "59:59";
			_tfTime.x = (Config.WIDTH - _tfTime.textWidth)*0.5;
			_tfTime.y = 16-8;
			
			
			addChild(_h1);
			addChild(_h2);
			addChild(_tfTime);
		}
		
		public function redrawScores():void
		{
			var p1:Player;
			var p2:Player;
			var players:Vector.<Actor> = _level.scene.getActorsByType("player");
			
			if(players.length > 0)
			{ 
			
				p1 = players[0] as Player;
				p2 = players[1] as Player;
				
				if(p2.health <= 0)
				{
					_h2.respawn = p2.respawnTimer;
				}
				else
				{
					_h2.health = p2.health;
				}
				
				if(p1.health <= 0)
				{
					_h1.respawn = p1.respawnTimer;
				}
				else
				{
					_h1.health = p1.health;
				}
			}
			
			if(ModeManager.instance.settings.timeout > 0.0)
			{
				_tfTime.alpha = 1.0;
				_tfTime.text = StringUtil.timeMMSS(ModeManager.instance.settings.timeout - ModeManager.instance.totalTime);
			}
			else
			{
				_tfTime.alpha = 0.7;
				_tfTime.text = StringUtil.timeMMSS(ModeManager.instance.totalTime);
			}
						
				
			//_tfTime.x = (Config.WIDTH - _tfTime.textWidth)*0.5;
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_light.update(dt);
			
			/*var p1:Player = _level.players[0] as Player;
			var p2:Player = _level.players[1] as Player;
			var g:Graphics = _energySpr.graphics;
			const ix:Number = 20;
			const iy:Number = 100;
			const bw:Number = 100;
			const bh:Number = 4;
			
			g.clear();
			
			g.beginFill(0xffffff);
			g.drawRect(ix, iy, bw*(p1.energy / Player.ENERGY_MAX), bh);
			g.drawRect(Config.WIDTH - ix -bw, iy, bw*(p2.energy / Player.ENERGY_MAX), bh);
			g.endFill();
			
			g.lineStyle(1.0);
			g.drawRect(ix + bw*(Player.ENERGY_CUTOFF / Player.ENERGY_MAX), iy+1, 0.5, bh-2);
			g.drawRect(Config.WIDTH - ix -bw + bw*(Player.ENERGY_CUTOFF / Player.ENERGY_MAX), iy+1, 0.5, bh-2);
			g.drawRect(ix, iy, bw, bh);
			g.drawRect(ix, iy, bw, bh);
			g.drawRect(Config.WIDTH - ix -bw, iy, bw, bh);*/
			
			redrawScores();
		}

		public function get light():LightEffect
		{
			return _light;
		}

		public function get h1():HealthBar
		{
			return _h1;
		}

		public function get h2():HealthBar
		{
			return _h2;
		}
		
		public function onFrag():void
		{
			var p1:Player;
			var p2:Player;
			var players:Vector.<Actor> = _level.scene.getActorsByType("player");
			
			if(players.length > 0)
			{
				p1 = players[0] as Player;
				p2 = players[1] as Player;
				
				_h1.frags = p1.stats.frags;
				_h2.frags = p2.stats.frags;
			}
		}
	}
}
