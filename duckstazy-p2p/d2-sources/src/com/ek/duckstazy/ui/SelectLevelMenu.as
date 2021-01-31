package com.ek.duckstazy.ui
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.List;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.ek.duckstazy.game.Game;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelUtil;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.P2PGameCommands;
	import com.ek.duckstazy.game.P2PManager;
	import com.ek.duckstazy.utils.GameRandom;
	import com.ek.library.asset.AssetManager;

	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;



	/**
	 * @author eliasku
	 */
	public class SelectLevelMenu extends MenuScreen
	{	
		
		//private var _levelButtons:Array = [];
		//private var _levelIds:Array = [];
		
		private var _btnPlay:PushButton;
		private var _btnBack:PushButton;
		
		private var _btnOpen:PushButton;
		private var _listLevels:List;
		
		private var _fileRef:FileReference;
		
		//private var _currentLevel:String;
		private var _customLevel:XML;
		
		private var _player1:ProfileControl;
		private var _player2:ProfileControl;
		
		private var _rounds:NumericStepper;
		private var _timeout:ComboBox;
		private var _randomBonus:CheckBox;
		private var _fighting:CheckBox;
		private var _fragsLimit:NumericStepper;
		
		private var _networked:Boolean;
		
		
		public function SelectLevelMenu()
		{
			super("select_level");
			
			var list:Array = [];
			var id:String;
			var index:int;
			
			while(true)
			{
				id = "level_p2_" + index;
				if(AssetManager.getItemStatus(id) & AssetManager.ITEM_READY)
				{
					list.push(id);
					index++;
				}
				else
				{
					break;
				}
			}
			
			list.push("level_ai_test");
			
			_btnOpen = new PushButton(this, 50, 50, "Open Custom...", onLoad);
			_btnOpen.setSize(100, 20);
			
			_btnPlay = new PushButton(this, 200, 200, "Play!", onLevelStart);
			_btnBack = new PushButton(this, 200, 230, "Back", onBack); 
			
			_listLevels = new List(this, 50, 80, list);
			_listLevels.setSize(100, 200);
			_listLevels.addEventListener(Event.SELECT, onLevelSelect);
			_listLevels.selectedIndex = 0;
			
			_player1 = new ProfileControl(0);
			_player1.y = 450;
			_player1.x = 300;
			_player2 = new ProfileControl(1);
			_player2.x = 20;
			_player2.y = 450;
			
			
			addChild(_player1);
			addChild(_player2);
			
			acceptCallback = onLevelStart;
			escapeCallback = onBack;
			
			_rounds = new NumericStepper(this, 200, 80, null);
			_rounds.minimum = 1;
			_rounds.maximum = 6;
			
			_timeout = new ComboBox(this, 200, 100, null);
			_timeout.addItem("Disabled");
			_timeout.addItem("60 sec");
			_timeout.addItem("90 sec");
			_timeout.addItem("180 sec");
			_timeout.selectedIndex = 0;
			
			_randomBonus = new CheckBox(this, 200, 40);
			_randomBonus.label = "Random bonus";
			
			_fighting = new CheckBox(this, 300, 40);
			_fighting.label = "Fighting Mode";
			
			_fragsLimit = new NumericStepper(this, 300, 80, null);
			_fragsLimit.minimum = 0;
			_fragsLimit.maximum = 6;
			
		}

		public override function onOpen():void
		{
			
		}
		
		private function onBack(e:Event):void
		{
			Game.menu.open("main_menu");
		}
		
		private function onLevelSelect(e:Event):void
		{
			_btnPlay.enabled = (_listLevels.selectedItem != null);
		}
		
		private function onLevelStart(e:Event):void
		{
			var level:Level = initLevel();
			var mm:ModeManager = ModeManager.instance;
			
			if(level) {
				if(_networked) {
					level.network = true;
					level.hoster = true;
					P2PManager.instance.send(P2PGameCommands.LEVEL_START, {seed:GameRandom.seed, settings:mm.settings});
				}
				
				Game.instance.startLevel(level);
			}
		}
		
		private function initLevel(customSettings:Object = null):Level
		{
			var level:Level;
			
			if(_listLevels.selectedItem)
			{				
				if(_listLevels.selectedItem == "custom")
				{
					level = LevelUtil.createXMLLevel( _customLevel );
				}
				else
				{
					level = LevelUtil.createLevel( _listLevels.selectedItem as String );
				}
				
				var mm:ModeManager = ModeManager.instance;
				
				mm.reset();
				mm.addProfile(_player1.profileSettings);
				mm.addProfile(_player2.profileSettings);
				
				if(customSettings)
				{
					mm.settings.randomBonus = customSettings.randomBonus;
					mm.settings.timeout = customSettings.timeout;
					mm.settings.type = customSettings.type;
					mm.settings.frags = customSettings.frags;
					mm.settings.rounds = customSettings.rounds;
				}
				else
				{
					mm.settings.randomBonus = _randomBonus.selected;
					
					switch(_timeout.selectedIndex)
					{
						case 1:
							mm.settings.timeout = 60.0;
							break;
						case 2:
							mm.settings.timeout = 90.0;
							break;
						case 3:
							mm.settings.timeout = 180.0;
							break;
						default:
							mm.settings.timeout = 0.0;
							break;
					} 
					
					if(_fighting.selected)
					{
						mm.settings.type = ModeType.VERSUS_FIGHTING;
					}
					else
					{
						mm.settings.type = ModeType.VERSUS_ESCAPING;
					}
					
					mm.settings.frags = _fragsLimit.value;
					
					mm.settings.rounds = int(_rounds.value);
				}
				
			}
			
			return level;
		}
		
		public function onHostedStart(seed:Number, settings:Object):void
		{
			var level:Level = initLevel(settings);
			
			if(level)
			{
				GameRandom.seed = seed;
				level.network = true;
				level.hoster = false;
				Game.instance.startLevel(level);
			}
		}
		
		public function onLoad(e:Event):void
		{
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.SELECT, onFileSelected, false, 0, true);
			_fileRef.addEventListener(Event.COMPLETE, onFileLoaded, false, 0, true);
			_fileRef.browse([new FileFilter("Level", "*.xml")]);
		}

		private function onFileSelected(event:Event):void
		{
			_fileRef.load();
		}

		private function onFileLoaded(event:Event):void
		{
			_customLevel = XML(_fileRef.data.readUTFBytes(_fileRef.data.length));
			
			if(_listLevels.items.indexOf("custom") < 0)
				_listLevels.addItem("custom");
			
			_listLevels.selectedItem = "custom";
		}
		
		
		public static function open(type:String):void
		{
			var instance:SelectLevelMenu = Game.menu.getScreen("select_level") as SelectLevelMenu;
			if(type == "network") {
				instance._networked = true;
				Game.menu.open("select_level");
			}
			else if(type == "versus") {
				instance._networked = false;
				Game.menu.open("select_level");
			}
		}
		
	}
}
