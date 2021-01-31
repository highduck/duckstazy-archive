package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.hud.HUD;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.audio.AudioManager;
	import com.ek.library.core.CoreManager;
	import com.ek.library.debug.Console;
	import com.ek.library.debug.Logger;
	import com.ek.library.gocs.GameObject;

	import flash.geom.Rectangle;
	import flash.utils.getTimer;








	/**
	 * @author eliasku
	 */
	public class Level extends GameObject 
	{		
		private var _id:String;
		
		private var _viewport:GameObject;
		
		private var _camera:Camera;
		private var _cameraController:CameraController;
		private var _cameraShaker:CameraShaker;
		
		private var _scenes:Vector.<LevelScene> = new Vector.<LevelScene>();
		private var _scene:LevelScene;
		private var _startScene:LevelScene;
		
		private var _paused:Boolean;
		
		private var _frameTime:Number = 1.0 / 60.0;
		private var _frameTimer:Number = 0.0;
		private var _timeMod:Number = 1.0;
		
		private var _replay:Replay;
		private var _replayMode:String = Replay.NONE;
		
		private var _fightTimer:FightTimer = new FightTimer();
		
		private var _hud:HUD;
		
		private var _keysReset:Boolean;
		
		private var _network:Boolean;
		private var _hoster:Boolean;
		private var _inputLast:Object = {frame:0};
		private var _inputCutted:int;
		private var _inputBuffer:Array = [];
		private var _inputBufferSeq:int;
		private var _ticksBuffer:Array = [];
		private var _ticksBufferSeq:int;
		private var _networkedTick:Object = {};
		private var _networkedTickTime:Number = 1.0 / 66.0;
		private var _networkedPlayTimer:Number = 0.0;
		private var _srvDiffMax:int;
		
		private var _lastLag:Number = getTimer();
		private var _networkLag:Number = 0.0;
		
	
		private var _active:Boolean = true;
				
		public function Level()
		{
			initialize();
		}

		protected function initialize():void
		{
			mouseChildren = false;
			mouseEnabled = false;
			opaqueBackground = 0x000000;
			scrollRect = new Rectangle(0, 0, Config.WIDTH, Config.HEIGHT);
			
			_viewport = new GameObject();
			_viewport.mouseChildren = false;
			_viewport.mouseEnabled = false;
			addChild(_viewport);
			
			_hud = new HUD(this);
			addChild(_hud);
			
			_camera = new Camera(Config.WIDTH, Config.HEIGHT);
			_cameraShaker = new CameraShaker();
			_cameraController = new CameraController(this);
			
			ModeManager.instance.level = this;
		}
		
		public function load(id:String):void 
		{
			_id = id;
			loadXML(AssetManager.getXML(_id));
		}
		
		public function loadXML(xml:XML):void 
		{
			if(!_id) _id = "level_custom";
			
			var node:XML;
			var scene:LevelScene;
			
			for each (node in xml.scene)
			{
				scene = new LevelScene(this);
				scene.load(node);
				_scenes.push(scene);
			}
			
			node = xml.settings[0];
			if(node)
			{
				if(node.hasOwnProperty("@start_scene"))
					_startScene = getSceneByName(node.@start_scene);
			}
		}

		private function getSceneByName(name:String):LevelScene
		{
			for each(var scene:LevelScene in _scenes)
			{
				if(scene.name == name)
				{
					return scene;
				}
			}
			
			return null;
		}
		
		protected function initializeCamera():void
		{
			if(_scene)
				_cameraController.bounds = _scene.cameraBounds;
		}
		
		public function start():void
		{
			scene = _startScene;			
			ModeManager.instance.onLevelStart();
		}
		
		public function updateCameraTargets(type:String):void
		{
			var i:int;
			
			_cameraController.clearTargets();
		
			if(_scene)
			{
				for each (var actor:Actor in _scene.getActorsByType(type))
				{
					//if(!pl.dead)
					{
						_cameraController.addTarget(actor);
						++i;
					}
				}
				
				if(i == _scene.getActorsByType(type).length)
				{
					_cameraController.setFocus(0, 0);
				}
			}
		}
		
		private function inputSorter(a:Object, b:Object):Number
		{
		    if(a.seq > b.seq)
		    {
		        return 1;
		    }
		    else if(a.seq < b.seq)
		    {
		        return -1;
		    }
		    
		    if(a.frame > b.frame)
		    {
		        return 1;
		    }
		    else if(a.frame < b.frame)
		    {
		        return -1;
		    }
		    
		    return 0;
		}
		
		public function update():void
		{
			var ms:int = CoreManager.rawDeltaTime;
			var elapsed:Number = ms * _timeMod / 1000.0;
			var deltaTime:Number = elapsed;
			
			if(!_active)
			{
				Game.instance.endLevel();
			}
			
			_keysReset = true;
			
			if(_replayMode == Replay.PLAY)
			{
				if(!_paused)
				{
					_frameTimer += elapsed;
					while(!_replay.playCompleted && _frameTimer >= _replay.tick.deltaTime)
					{
						deltaTime = _replay.tick.deltaTime;
						_frameTimer -= deltaTime;
						
						processUpdate(deltaTime);
						
						_replay.nextTick();
					}
				}
			}
			else
			{
				if(_network)
				{					
					_ticksBuffer.sortOn("seq", Array.NUMERIC);
					_inputBuffer.sort(inputSorter);
					
					if(_hoster)
					{
						var level_ticks:Array = [];
						_frameTimer += deltaTime;
						var diff:int = 0;
						
						while(_frameTimer >= _networkedTickTime)
						{
							_networkedTick = {seq:_ticksBufferSeq};
							_ticksBufferSeq++;
							
							if(_inputBuffer.length > 0)
							{
								diff = _ticksBufferSeq - _inputBuffer[0].frame;
								if(diff > _srvDiffMax) _srvDiffMax = diff;
							}
							
							if(_inputBuffer.length > 0 && _inputBufferSeq == _inputBuffer[0].seq && _ticksBufferSeq >= _inputBuffer[0].frame)
							{
								_inputLast = InputMap.smooth(_inputLast, _inputBuffer[0]);
								_networkedTick.input1 = InputMap.clone(_inputLast);
								_inputBufferSeq++;
								_inputBuffer.splice(0, 1);
							}
							else
							{
								_inputLast = InputMap.interpolate(_inputLast);
								_networkedTick.input1 = InputMap.clone(_inputLast);
							}
								
							processUpdate(_networkedTickTime, true);
							
							level_ticks.push(_networkedTick);
							
							_frameTimer -= _networkedTickTime;
						}
						
						if(level_ticks.length > 0)
						{
							P2PManager.instance.send(P2PGameCommands.LEVEL_TICKS, level_ticks);
						}
						
						/*if(_inputBuffer.length > 1)
						{
							_inputCutted += _inputBuffer.length - 1;
							_inputBufferSeq = _inputBuffer[_inputBuffer.length-1].seq;
							_inputBuffer.splice(0, _inputBuffer.length-1);
						}*/
						
						Console.proxy.setInfo(2, "\nbuffered: " + _inputBuffer.length + "\nodd: " + _frameTimer + "\nilf: " + _inputLast.frame + "\ndiff: " + diff + " (max: " + _srvDiffMax + ")");
					}
					else
					{
						var level_input:Object;			
						var ntick:Object;
						var lagFrames:int;
						
						var p1:Player = Player.getPlayerByID(_scene, 0);
						if(p1)
						{
							p1.inputMap.readFromInput(Game.input);
							level_input = p1.inputMap.serialize();
							if(!InputMap.equal(_inputLast, level_input))
							{
								level_input.seq = _inputBufferSeq;
								_inputBufferSeq++;
								_inputLast = InputMap.clone(level_input);
							}
							else
							{
								level_input = null;
							}
						}
	
						if(level_input)
						{
							level_input.frame = _ticksBufferSeq + int(_networkLag/_networkedTickTime);
							P2PManager.instance.send(P2PGameCommands.LEVEL_INPUT1, level_input);
						}
						
						_networkedPlayTimer += deltaTime;
						
						var ptime:Number = deltaTime - _ticksBuffer.length*_networkedTickTime;
						
						while(_ticksBuffer.length > 0 && _networkedPlayTimer >= _networkedTickTime)
						{
							ntick = _ticksBuffer[0];
							if(ntick.seq == _ticksBufferSeq)
							{
								_ticksBufferSeq++;
								_networkedTick = ntick;
								processUpdate(_networkedTickTime, true);
								_ticksBuffer.splice(0, 1);
								_networkedPlayTimer -= _networkedTickTime;
								//if(_ticksBuffer.length > 0 && _networkedPlayTimer < _ticksBuffer.length*_networkedTickTime*_networkLag)
								//	_networkedPlayTimer += _networkedTickTime;
							}
							else
							{
								Logger.warning("client seq error");
								break;
							}
						}
						
						if(ptime >= _networkedTickTime)
						{
							processPrediction(ptime);
							processFrameTick(ptime);
						}
						
						Console.proxy.setInfo(2, "buffered: " + _ticksBuffer.length + "\nodd time: " + _networkedPlayTimer + "\nrt: " + _networkLag);
						
						if(_keysReset)
						{
							processLevelInput();
							
							Game.input.resetKeys();
							_keysReset = false;
						}
						
						_networkedTick = null;
					}
				}
				else
				{
					processUpdate(deltaTime, true);
				}
			}
			
			
			
			updateCamera(elapsed);
			
			if(_scene)
				_scene.drawDebugInfo();
			/**/
		}
		
		public override function tick(dt:Number):void
		{
			
		}
		
		private function processUpdate(dt:Number, tickGameObjects:Boolean = true):void
		{
			var actor:Actor;
			
			if(!_paused && dt > 0.0)
			{
				if(_replay && _replayMode == Replay.RECORD)
				{
					_replay.record(dt);
				}
				
				if(_scene)
				{
					for each (actor in _scene.actors)
					{
						actor.update(dt);
						if(tickGameObjects)
						{
							actor.tick(dt);
						}
					}
				}
				
				ModeManager.instance.update(dt);
				
				if(tickGameObjects)
				{
					super.tick(dt);
				}
			}
			
			if(_keysReset)
			{
				processLevelInput();
				
				Game.input.resetKeys();
				_keysReset = false;
			}
		}
		
		private function processFrameTick(dt:Number):void
		{
			var actor:Actor;
			
			if(!_paused && dt > 0.0)
			{
				if(_scene)
				{
					for each (actor in _scene.actors)
					{
						actor.tick(dt);
					}
				}
				
				super.tick(dt);
			}
		}
		
		private function processPrediction(dt:Number):void
		{
			var actor:Actor;
			
			if(!_paused && dt > 0.0)
			{
				if(_scene)
				{
					for each (actor in _scene.actors)
					{
						actor.predict(dt);
					}
				}
			}
		}

		private function processLevelInput():void
		{
			/*if(Game.input.getKeyDown(Keyboard.ESCAPE))
			{
				if(!_paused) pause();
			}*/
		}
		
		public function updateCamera(dt:Number):void
		{
			_cameraController.update(dt);
			_camera.applyTransform(_viewport);
			
			if(_scene)
			{
				for each (var layer:CameraLayer in _scene.layers)
					layer.update(_camera);
			}
			
			AudioManager.update(_camera.centerX, _camera.centerY);
		}


				
		public function get timeMod():Number
		{
			return _timeMod;
		}
		
		public function get camera():Camera
		{
			return _camera;
		}

		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
		}

		

		public function get cameraController():CameraController
		{
			return _cameraController;
		}

		public function get cameraShaker():CameraShaker
		{
			return _cameraShaker;
		}

		public function get viewport():GameObject
		{
			return _viewport;
		}

		public function get replay():Replay
		{
			return _replay;
		}

		public function get replayMode():String
		{
			return _replayMode;
		}

		public function set replay(replay:Replay):void
		{
			_replay = replay;
		}

		public function set replayMode(replayMode:String):void
		{
			_replayMode = replayMode;
		}

		public function set timeMod(value:Number):void
		{
			_timeMod = value;
		}
		
		public function resume():void
		{
			Game.menu.close();
			Game.input.resetFocus();
			Game.input.resetKeys();
			_paused = false;
		}
		
		public function pause():void
		{
			Game.menu.open("pause");
			_paused = true;
		}

		public function get id():String
		{
			return _id;
		}

		public function get scene():LevelScene
		{
			return _scene;
		}

		public function set scene(value:LevelScene):void
		{
			if(_scene)
			{
				onSceneExit();
				_scene = null;
			}
			
			if(value)
			{
				_scene = value;
				onSceneEnter();
			}
			
			initializeCamera();
		}

		protected function onSceneEnter():void
		{
			_scene.onStart();
		}

		protected function onSceneExit():void
		{
			_scene.onExit();
		}

		public function get scenes():Vector.<LevelScene>
		{
			return _scenes;
		}
		
		public function cleanup():void
		{
			this.scene = null;
			_scenes.length = 0;
		}

		public function get hud():HUD
		{
			return _hud;
		}

		public function get hoster():Boolean
		{
			return _hoster;
		}

		public function set hoster(value:Boolean):void
		{
			_hoster = value;
		}

		public function addNetworkedTicks(ticks:Array):void
		{
			var now:int = getTimer();
			_networkLag = (now - _lastLag)/1000.0;
			_lastLag = now;
			
			_ticksBuffer = _ticksBuffer.concat(ticks);
		}

		public function get networkedTick():Object
		{
			return _networkedTick;
		}

		public function addNetworkedInput(input:Object):void
		{
			_inputBuffer.push(input);
		}
		
		public function exit():void
		{
			_active = false;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function get network():Boolean
		{
			return _network;
		}

		public function set network(value:Boolean):void
		{
			_network = value;
		}
		
	}
}
