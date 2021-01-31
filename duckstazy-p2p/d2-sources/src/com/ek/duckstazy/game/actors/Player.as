package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.effects.BubbleText;
	import com.ek.duckstazy.effects.FeatherEffect;
	import com.ek.duckstazy.effects.FxTeleport;
	import com.ek.duckstazy.effects.HittedText;
	import com.ek.duckstazy.effects.JumpCircle;
	import com.ek.duckstazy.effects.ParticleFX;
	import com.ek.duckstazy.game.Game;
	import com.ek.duckstazy.game.InputMap;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.Replay;
	import com.ek.duckstazy.game.ai.BaseAI;
	import com.ek.duckstazy.game.ai.LahodaAI;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;
	import com.ek.duckstazy.utils.GameRandom;
	import com.ek.duckstazy.utils.XMath;
	import com.ek.library.audio.AudioLazy;

	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;















	/**
	 * @author eliasku
	 */
	public class Player extends Actor
	{
		public static const KEY_ID_DOWN:String = "down";
		public static const KEY_ID_UP:String = "up";
		public static const KEY_ID_LEFT:String = "left";
		public static const KEY_ID_RIGHT:String = "right";
		public static const KEY_ID_FIRE:String = "fire";
		
		public static const TICK_MOD:Number = 40.0;
		
		public static const COLORS:Array = [0xff6699ff, 0xffff6666];
		public static var PLAYER_GLOW:GlowFilter = new GlowFilter(0, 0.75, 2.0, 2.0, 9, 3);
		
		public static const MAX_HEALTH:int = 100;
		
		public static const RECOVER_TIME:Number = 1.0;
		public static const KICKBACK_ACC_MOD:Number = 0.3;
		
		public static const MOVEH_ACC_AIR:Number = 0.45 * TICK_MOD * TICK_MOD;
		public static const MOVEH_ACC_GROUND:Number = 1.0 * TICK_MOD * TICK_MOD;
		public static const MOVEH_VEL_MAX:Number = 4.0 * TICK_MOD;
		
		public static const JUMP_VEL:Number = -7.0 * TICK_MOD;
		//public static const JUMP_VEL_SHORT:Number = -6.0 * TICK_MOD;
		public static const DJUMP_VEL:Number = -5.5 * TICK_MOD;
		//public static const DJUMP_VEL_SHORT:Number = -3.5 * TICK_MOD;
		//public static const DJUMP_MIN_VEL:Number = -3.5 * TICK_MOD;
		public static const DJUMP_HORIZONTAL_ACC:Number = 3.0 * TICK_MOD;
		//public static const JUMP_TR:Number = -3.5 * TICK_MOD;
		
		public static const GRAVITY:Number = 0.45 * TICK_MOD * TICK_MOD;
		public static const GRAVITY_LONG:Number = 0.25 * TICK_MOD * TICK_MOD;
		
		//public static const JUMP_TIME_SHORT:Number = 8.0 / 60.0;
		public static const JUMP_TIME_TOTAL:Number = 30.0 / 60.0;
		
		public static const MOVEV_MAX:Number = 15.0 * TICK_MOD; //6.5
		public static const MOVEV_DIVE:Number = 10.0 * TICK_MOD;
		
		public static const HIT_WIDTH:Number = 20;
		public static const HIT_HEIGHT:Number = 20;
		
		public static const REPAWN_TIME:Number = 6.0;
		private static const DIVE_LOCK_TIME:Number = 1.0;
		
		private static const BONUS_QUAD_TIME:Number = 10.0;
		private static const BONUS_SPEEDUP_TIME:Number = 7.0;
		private static const BONUS_UNDEAD_TIME:Number = 10.0;
		
		public static const TELEPORT_TIME:Number = 2.0;
	
		private var _respawnTimer:Number = 0.0;
		
		private var _grounded:Boolean;
		private var _moveDir:Number = 0.0;
		private var _lookDir:int;
		
		private var _longJump:Boolean;
		private var _longJumpTimer:Number = 0.0;
		private var _doubleJump:Boolean;
		
		private var _kickTimeout:Number = 0.0;
		
		private var _dive:Boolean;
		private var _diveEnter:Number = 0.0;
		private var _diveLock:Number = 0.0;
		
		private var _sprite:DuckSprite;
		
		private var _id:int;
		private var _inputMap:InputMap = new InputMap();
		
		private var _score:int;
		private var _health:int;
		
		private var _reload:Number = 1.0;
		
		private var _fly:Boolean;
		
		private var _pickedItem:Bun;
		
		private var _home:House;
		
		private var _bonusUndead:Number = 0.0;
		private var _bonusSpeedup:Number = 0.0;
		private var _bonusQuad:Number = 0.0;
		
		private var _teleportTime:Number = 0.0;
		private var _teleportX:Number = 0.0;
		private var _teleportY:Number = 0.0;
		
		private var _ai:BaseAI;
		
		private var _profile:Object;
		private var _stats:PlayerStats;
		
		public function Player(id:int, level:Level, profile:Object) 
		{
			super(level);
			
			type = "player";
			
			gridMask = ActorMask.PLAYER;

			width = HIT_WIDTH;
			height = HIT_HEIGHT;
			
			_profile = profile;
			
			_id = id;
			initContent();
			initButtons(_id);
			
			//blendMode = BlendMode.LAYER;
			var box:Shape = new Shape();
			box.graphics.lineStyle(1, 0);
			box.graphics.drawRect(0, 0, HIT_WIDTH*1.75, height);
			//content.addChild(box);

			if(_profile && _profile.ai)
				_ai = new LahodaAI(this);
				
			_stats = new PlayerStats(this);
		}
		
		public override function onStart():void
		{
			super.onStart();

			onRespawn();
			
			if(_ai) _ai.onStart();
			_home = House.getHouse(scene, _id);
		}

		private function onRespawn():void
		{
			var startPoint:Actor = scene.getActorsByType("start_point")[_id];
			x = startPoint.x;
			y = startPoint.y;
			_lookDir = 1;
			_moveDir = 1.0;
			vx = 0.0;
			vy = 0.0;
			dead = false;
			_kickTimeout = 0.0;
			_dive = false;
			_doubleJump = false;
			resetLongJump();
			_grounded = false;
			_diveLock = 0.0;
			_health = MAX_HEALTH;
			_reload = 0.0;
			_fly = false;
			
			content.visible = true;
			
			_bonusUndead = 0.0;
			_bonusSpeedup = 0.0;
			_bonusQuad = 0.0;
			_teleportTime = 0.0;
			
			updateTransform();
			
			_sprite.startSqueeze();
		}
		
		private function initContent():void
		{
			_sprite = new DuckSprite(this);
			_sprite.skinIndex = _id + 1;
			content.addChild(_sprite);
		}

		private function initButtons(id:int):void 
		{
			var up:uint;
			var down:uint;
			var right:uint;
			var left:uint;
			var fire:uint;
			
			if(id == 0)
			{
				up = Keyboard.UP;
				down = Keyboard.DOWN;
				right = Keyboard.RIGHT;
				left = Keyboard.LEFT;
				fire = Keyboard.CONTROL;
			}
			else if(id == 1)
			{
				up = 0x57;
				down = 0x53;
				right = 0x44;
				left = 0x41;
				fire = Keyboard.TAB;
			}
			
			_inputMap.clear();
			_inputMap.addKey(KEY_ID_UP, up);
			_inputMap.addKey(KEY_ID_DOWN, down);
			_inputMap.addKey(KEY_ID_RIGHT, right);
			_inputMap.addKey(KEY_ID_LEFT, left);
			_inputMap.addKey(KEY_ID_FIRE, fire);
		}
		
		private function onDiveEnter():void
		{
			if(!_dive && !_grounded && _diveEnter >= 1.0)
			{
				vy = MOVEV_DIVE;
				_dive = true;
				_diveEnter = 0.0;
				onDropItem(false);
				onFlyExit();
				
				_sprite.onDiveEnter();
				AudioLazy.playAt("jump_1", x, y);
				
				_stats.onDiveEnter();
			}
		}
		
		private function onDiveExit(hit:Boolean = false):void
		{
			if(_dive)
			{
				_dive = false;
				if(hit)
				{
					_stats.onDiveHit();
				}
			}
		}
		
		private function onFlyEnter():void
		{
			if(!_fly)
			{
				_fly = true;
				vy = 0.0;
			}
		}
		
		private function onFlyExit():void
		{
			if(_fly)
				_fly = false;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			//trace(getMaxJumpHeight());
			
			if(level.replayMode == Replay.PLAY)
			{
				_inputMap.deserialize(level.replay.tick.getInput("player" + _id));
			}
			else
			{
				if(_ai)
				{
					_ai.update(dt);
					_inputMap.deserialize(_ai.inputMap);
				}
				else if(level.network) {
					if(level.hoster)
					{
						if(_id == 0)
						{
							_inputMap.readFromInput(Game.input);
							level.networkedTick.input0 = _inputMap.serialize();
						}
						else
						{
							_inputMap.deserialize(level.networkedTick.input1);
						}
					}
					else
					{
						if(_id == 0)
						{
							_inputMap.deserialize(level.networkedTick.input0);
						}
						else
						{						
							_inputMap.deserialize(level.networkedTick.input1);
						}
						
					}
				}
				else {
					_inputMap.readFromInput(Game.input);
				}
				
				if(level.replayMode == Replay.RECORD)
				{
					level.replay.tick.record("player" + _id, _inputMap);
				}
			}
			
			if(dead)
			{
				if(_respawnTimer > 0.0)
				{
					_respawnTimer -= dt;
					if(_respawnTimer <= 0.0)
					{
						onRespawn();
					}
				}
				
				return;
			}



			updateBonus(dt);
			
			var djump:Boolean = _doubleJump;
						
			processInput(dt);
			
			var firstVY:Number = vy;
			var ay:Number = 0.0;
			var vyMax:Number = MOVEV_MAX;
			/*if(_dive)
			{
				//_vy = MOVEV_DIVE;
				vy += GRAVITY*dt;
				if(vy > MOVEV_DIVE*3.0) vy = MOVEV_DIVE*3.0;
			}
			else
			{
				if(canDive && _inputMap.getKey(KEY_ID_DOWN))
				{
					
				}
				else
				{
					if(_fly)
					{
						vy = 0.05*GRAVITY*_sprite.flyCycle;
					}
					else
					{
						if(_longJump)// && _vy < 0.0)
						{
							vy += GRAVITY_LONG*dt;

							//var jk:Number = 1.0;
							//if(_longJumpTimer <= 5.0/60.0)
							//	jk = 0.6;
							//if(_doubleJump)
								//_vy = DJUMP_VEL*jk;
							//else
								//_vy = JUMP_VEL*jk;
							
						}
						else
							vy += GRAVITY*dt;
							
						if(vy > MOVEV_MAX) vy = MOVEV_MAX;
					}
				}
			}*/
			
			if(_dive)
			{
				ay = GRAVITY;
				vyMax = MOVEV_DIVE*3.0;
			}
			else
			{
				if(canDive && _inputMap.getKey(KEY_ID_DOWN))
				{
					
				}
				else
				{
					if(_fly)
					{
						vy = 0.05*GRAVITY*_sprite.flyCycle;
					}
					else
					{
						if(_longJump)// && _vy < 0.0)
						{
							ay = GRAVITY_LONG;

							//var jk:Number = 1.0;
							//if(_longJumpTimer <= 5.0/60.0)
							//	jk = 0.6;
							//if(_doubleJump)
								//_vy = DJUMP_VEL*jk;
							//else
								//_vy = JUMP_VEL*jk;
							
						}
						else {
							ay = GRAVITY;
						}
							
						vyMax = MOVEV_MAX;
					}
				}
			}
			
			//var maxvx:Number = MOVEH_VEL_MAX;
			//if(_dive)
			//	maxvx = MOVEH_VEL_DIVE;
	
			if(_kickTimeout > 0.0)
			{
				_kickTimeout -= dt;
				if(_kickTimeout < 0.0)
				{
					_kickTimeout = 0.0;
				}
			}
			
			var target_vx:Number = getTargetVX();
			var hacc:Number = getHorizontalAcceleration();
			
			
			var vx0:Number = vx;
			vx = XMath.addByMod(vx, target_vx, hacc*dt);
			
			
			var lastVY:Number = vy;
			
			
			
			var dx:Number = vx*dt;
			var dy:Number = vy*dt + ay*dt*dt/2.0;
			
			var vy0:Number = vy;
			vy += ay*dt;
			if(vy > vyMax) {
				vy = vyMax;
			}
			
			dx = (vx0+vx)*dt/2.0;
			dy = (vy0+vy)*dt/2.0;
			
			move2(dx, dy, 0.0, 0.0);
			
			
			
			var lastGrounded:Boolean = _grounded;
			
			checkGrounded();
			if(_grounded)
			{
				resetLongJump();
				resetDoubleJump();
			}
			
			if(!_grounded)
			{
				if(_fly)
					_sprite.jump(1);
				else
				{
					if(vy < 0.0 && _doubleJump == djump)
					{
						_sprite.jump(1);
					}
					else
					{
						if(firstVY <= 0.0)// && _inputMap.getKey(KEY_ID_UP)))
						{
							if(_doubleJump!=djump)
							{
								_sprite.jump(2, true);
							}
							else
							{
								_sprite.jump(1, _moveDir==0 && !_doubleJump);// && !_inputMap.getKey(KEY_ID_UP));
							}
						}
						else
						{
							if(_moveDir==0) _sprite.jump(2);
							else _sprite.jump(0);
						}
						
						
					}
					if(vy >= 0.4*MOVEV_MAX) _sprite.jump(2);
				}
			}
			else _sprite.jump(0, true);
			
			if(_grounded && !lastGrounded)
			{
				onLanding(lastVY);
			}
			
			_sprite.tick(dt);
			
			/*if(scene.getActorsByType("player").length > 1)
			{
				var opponent:Player = getEnemy();
				if(opponent)
				{
					PLAYER_GLOW.color = COLORS[_id];
					PLAYER_GLOW.alpha = XMath.clamp(1.0 - opponent.distanceTo(this)/500.0, 0.5, 1.0);
					content.filters = [PLAYER_GLOW];
					//transform.colorTransform = new ColorTransform();
				}
				else
				{
					content.filters = [];
				}
			}*/
			
			if(_pickedItem)
			{
				_pickedItem.onCarrierMove();
			}
		}
		
		public override function tick(dt:Number):void
		{
			if(!dead)
			{
				//_sprite.tick(dt);
			}
		}

		public function getHorizontalAcceleration():Number
		{
			var result:Number = 0.0;
			
			if(_grounded || _dive)
			{
				result = MOVEH_ACC_GROUND;
			}
			else
			{
				result = MOVEH_ACC_AIR;
			}
			
			if(_kickTimeout > 0.0)
			{
				result *= KICKBACK_ACC_MOD;
			}
			
			return result;
		}


		private function onLanding(landVel:Number):void
		{
			var vol:Number = XMath.clamp(landVel/MOVEV_MAX);
			AudioLazy.playAt("sfx_land", x, y, vol);
			var pc:int = int(vol*16);
			if(pc > 0)
				ParticleFX.createDuckBubbles(this, pc);
			
			if(_dive)
			{
				onDiveExit();
				level.cameraShaker.shake(8.0, 0.5);
				AudioLazy.playAt("die", x, y);
				vy = JUMP_VEL*0.5;
				_doubleJump = true;
				_longJump = true;
				_diveLock = DIVE_LOCK_TIME;
				var d:Number = 0.0;
				for each (var player:Player in scene.getActorsByType("player"))
				{
					if(player != this && !player.kicked && !player.dead)
					{
						if(player.checkBox(x - 64, y + HIT_WIDTH*0.75, HIT_WIDTH + 128, HIT_HEIGHT*0.25))
						{
							d = (player.x - x)/(HIT_WIDTH + 64);
							if(d > 0.0) d = 1.0 - d;
							else if(d < 0.0) d = - 1.0 - d;
							player.vy = -400.0*Math.abs(d);
							player.vx = d * 800.0;
						}
					}
				}
			}
			else
			{
				_diveLock = 0.0;
			}
				
			_diveEnter = 0.0;
			
			onFlyExit();
		}

		public function getTargetVX():Number
		{
			var maxvx:Number = MOVEH_VEL_MAX;

			if(_bonusSpeedup > 0.0)
			{
				maxvx *= 1.5;
			}
			
			if(dead)
			{
				maxvx = 0.0;
			}
			
			return _moveDir*maxvx;
		}

		private function processInput(dt:Number):void 
		{
			if(dead) return;
			
			var dir:int;
			if(_inputMap.getKey(KEY_ID_RIGHT))
				++dir;
			if(_inputMap.getKey(KEY_ID_LEFT))
				--dir;

			var door:Door = Door.getDoor(scene, _id);
			if(door && door.opened && door.checkBox(x, y, width, height))
			{
				if(x < door.x)
				{
					dir = 1;
				}
				else if(right > door.right)
				{
					dir = -1;
				}
			}
			
			
			if(dir < 0)
				_lookDir = -1;
			else if(dir > 0)
				_lookDir = 1;
			
			_moveDir = dir;
			_sprite.run(dir);
			
			if(_diveLock > 0.0)
				_diveLock -= dt;
			if(_inputMap.getKey(KEY_ID_DOWN))
			{
				if(canDive)
				{
					onFlyExit();
					_diveEnter += dt*8.0;
					if(_diveEnter >= 1.0)
						onDiveEnter();
				}
			}
			else
			{
				_diveEnter = 0.0;
				//onDiveExit();
			}
			
			if(_longJump)
			{
				_longJumpTimer += dt;
				if(_longJumpTimer >= JUMP_TIME_TOTAL)
				{
					resetLongJump();
				}
			}
			
			
			if(_inputMap.getKeyDown(KEY_ID_UP))
			{
				if(_grounded)
				{
					vy = JUMP_VEL;
					_doubleJump = false;
					_longJump = true;
					_longJumpTimer = 0.0;
					AudioLazy.playAt("jump_1", x, y);
				}
				else
				{
					if(!_dive && !_pickedItem && !_doubleJump)// && _vy > DJUMP_MIN_VEL)
					{
						_doubleJump = true;
						_longJump = true;
						_longJumpTimer = 0.0;
						
						vx = XMath.addByMod(vx, getTargetVX(), DJUMP_HORIZONTAL_ACC);
						vy = DJUMP_VEL;
						
						AudioLazy.playAt("jump_2", x, y);
						var jc:JumpCircle = new JumpCircle();
						jc.rotation = Math.atan2(vx, -vy)*180/Math.PI;
						jc.x = centerX;
						jc.y = bottom;
						layer.addChild(jc);
					}
				}
			}
			else if(_inputMap.getKeyUp(KEY_ID_UP))
			{
				
				//if(!_doubleJump && _vy < -0.0*TICK_MOD && _longJumpTimer < JUMP_TIME_SHORT)
				//if(_longJump)
				//{
					//vy = XMath.addByMod(vy, 0.0, 2.5 * TICK_MOD);
				//}
				resetLongJump();
				onFlyExit();
			}
			
			if(_inputMap.getKey(KEY_ID_UP))
			{
				if(_diveEnter <= 0.0 && !_dive && !_pickedItem && !_grounded && !kicked && !_fly && vy >= 0.0)// && _doubleJump)
				{
					onFlyEnter();
				}
			}
			
			if(_reload > 0.0)
			{
				_reload -= dt*1.2;
			}
			
			if(_inputMap.getKeyDown(KEY_ID_FIRE) && !_dive)
			{
				if(_pickedItem)
				{
					onDropItem(true);
				}
				else
				{
					var bun:Bun = checkPickUp();
					if(bun && !kicked)
					{
						bun.onPickUp(this);
						_pickedItem = bun;
						onFlyExit();
					}
					else
					{
						if(_reload <= 0.0)
						{
							onFire();
							_reload = 1.0;
						}
					}
				}
			}
				
			
			//_inputDown = true;
		}

		private function onFire():void
		{
			var pr:Projectile = new Projectile(level, this);
			scene.addActor(pr);
			
			_sprite.onFire();
			
			_stats.onFire();
		}

		public function checkGrounded():void
		{
			_grounded = (!testBox(x, y, width, height) &&
						 testBox(x, y+1.0, width, height));
		}

		protected override function onBlockCollided(hits:int):void
		{
			/*if(hits & COLLIDE_H)
			{
				if(_vx > 0.0) _vx = 0.0;
				closeBreaker();
			}*/
		}
		
		private function onDropItem(byPlayer:Boolean):void
		{
			if(_pickedItem)
			{
				_pickedItem.onDropOut(byPlayer);
				_pickedItem = null;
				//if(byPlayer) _sprite.onFire();
			}
		}
		
		private function checkPlayer(player:Player):void
		{
			var d:Number;

			if(_dive && player && player != this && !player.dead)
			{
				if(player.checkBox(x, y + HIT_HEIGHT*0.75, HIT_WIDTH, HIT_HEIGHT*0.25))
				{
					if(!player.kicked)// && player._lookDir == _lookDir)
					{
						d = Math.abs(player.y - y);
						if(d >= HIT_WIDTH*0.5)
						{
							//AssetManager.getSound("fuck").play();
							level.cameraShaker.shake(4.0, 0.5);
							_score += 1;
							if(_bonusQuad > 0.0)
								player.onKick(this, 100);
							else
								player.onKick(this, 50);
							player.vy = -100;
							player.vx = -player._lookDir * 100.0;
							
							player._sprite.startSqueeze();
							
							onDiveExit(true);
							_diveLock = DIVE_LOCK_TIME;
							vy = JUMP_VEL*0.5;
						}
					}
				}
			}
		}
		
		protected override function processActor(actor:Actor):void 
		{
			if(actor is Player)
			{
				checkPlayer(actor as Player);
			}
			else if(actor is Spikes)
			{
				(actor as Spikes).onHeroHit(this);
			}
			/*else if(actor is Coin)
			{
				(actor as Coin).onPlayerTouch(this);
				
			}*/
			else if(actor is BoxObstacle)
			{
				(actor as BoxObstacle).onHeroHit(this);
			}
			else if(actor is Jumper)
			{
				(actor as Jumper).onHeroHit(this);
			}
			else if(actor is Bonus)
			{
				processBonus(actor as Bonus);
			}
			else if(actor is Door)
			{
				var door:Door = actor as Door;
				if(door.id == _id && door.opened)
				{
					if(door.right >= right && door.x <= x && door.bottom >= bottom && door.y <= y)
					{
						ModeManager.instance.onEscape(this);
					}
				}
			}
		}

		private function rollBonusEffect():int
		{
			var effect:int;
			var enemy:Player = getEnemy();
			var diff:int;
			var iterations:int = 30;
			
			if(enemy.home && _home)
			{
				diff = enemy.home.buns.length - _home.buns.length;
			}
			
			while(iterations > 0)
			{
				effect = int(GameRandom.random(1, Bonus.EFFECTS_COUNT));
				--iterations;
				
				switch(effect)
				{
					case BonusEffectType.UNDEAD:
						if(ModeManager.instance.settings.type != ModeType.VERSUS_FIGHTING)
						{
							if(GameRandom.random() > 0.5 || health < 50) {
								iterations = 0;
							}
						}
						break;
					case BonusEffectType.QUAD:
						if(enemy.health > 0 && (GameRandom.random() > 0.3 || enemy.health < 50) && enemy.bonusUndead <= 0)
							iterations = 0;
						break;
					case BonusEffectType.SPEEDUP:
						if((GameRandom.random() > 0.3 || diff > 0) || enemy.bonusUndead > 0)
							iterations = 0;
						break;
					case BonusEffectType.SHARK:
						if(enemy.health > 1 && enemy.bonusUndead <= 0.1)
							iterations = 0;
						break;
					case BonusEffectType.STEAL:
						if(ModeManager.instance.settings.type != ModeType.VERSUS_FIGHTING)
						{
							if((GameRandom.random() > 0.5 && diff >= 1) || diff >= 2)
							{
								iterations = 0;
							}
						}
						break;
					case BonusEffectType.TELEPORT:
						if(enemy.health > 0)
							iterations = 0;
						break;
					case BonusEffectType.HEAL:
						if(ModeManager.instance.settings.type != ModeType.VERSUS_ESCAPING)
						{
							if(enemy.health < 100) {
								iterations = 0;
							}
						}
						break;
				}
			}
			
			return effect;
		}
		
		private function processBonus(bonus:Bonus):void
		{
			var text:String;
			var sfx:String;
			
			if(bonus && !bonus.dead)
			{
				bonus.onPickUp();
				_sprite.startPulse();
				
				var enemy:Player = getEnemy();
				var effect:int = bonus.effect;
				if(effect == BonusEffectType.RANDOM) effect = rollBonusEffect();
				 
				switch(effect)
				{
					case BonusEffectType.UNDEAD:
						_bonusUndead = BONUS_UNDEAD_TIME;
						text = "† UNDEAD †";
						sfx = "sfx_bonus_undead";
						break;
					case BonusEffectType.QUAD:
						_bonusQuad = BONUS_QUAD_TIME;
						text = "QUAD DAMAGE";
						sfx = "sfx_bonus_quad";
						break;
					case BonusEffectType.SPEEDUP:
						_bonusSpeedup = BONUS_SPEEDUP_TIME;
						text = "GO SPEED GO";
						sfx = "sfx_bonus_speed";
						break;
					case BonusEffectType.SHARK:
						scene.addActor(new Shark(level, this, enemy));
						text = ",,, SHARKY OUT ,,,";
						sfx = "sfx_bonus_rocket";
						break;
					case BonusEffectType.STEAL:
						_home.onStealFrom(enemy.home);
						text = "STEAL EGG";
						sfx = "sfx_bonus_steal";
						break;
					case BonusEffectType.TELEPORT:
						enemy.onTeleport();
						text = "TELEPORT";
						sfx = "sfx_bonus_teleport";
						break;
					case BonusEffectType.HEAL:
						onHeal(50);
						sfx = "sfx_bonus_heal";
						break;
				}
				
				if(sfx) {
					AudioLazy.playAt(sfx, x, y);
				}
				
				if(text) {
					var bt:BubbleText = new BubbleText(x, y, text, COLORS[_id], 0x222222);
					layer.addChild(bt);
				}
				
				_stats.onBonusCollected();
			}
		}

		private function onTeleport():void
		{
			if(_teleportTime > 0.0 || dead) return;
			
			var actors:Vector.<Actor> = scene.actors;
			var actor:Actor;
			var rc:Rectangle = scene.cameraBounds;
			var goodPlace:Boolean;
			var oldX:Number = x;
			var oldY:Number = y;
			
			
			while(!goodPlace)
			{
				x = rc.left + rc.width*GameRandom.random();
				y = rc.top + rc.height*GameRandom.random();
				updateTransform();
				
				goodPlace = true;
				
				for each(actor in actors)
				{
					if(actor.testBox(x, y, width, height))
					{
						goodPlace = false;
						break;
					}
				}
			}
			
			_teleportX = x;
			_teleportY = y;
			
			x = oldX;
			y = oldY;
			
			updateTransform();
			
			_teleportTime = TELEPORT_TIME;
			
			layer.addChild(new FxTeleport(_teleportX, _teleportY, this));
			content.addChild(new FxTeleport(0, 0, null));
		}

		/*public function onLose():void 
		{
			if(!_dead)
			{
				_dead = true;
				_respawnTimer = 0.0;
				//visible = false;
				(_level.getLayer("hud") as HUD).light.start();
				AssetManager.getSound("lose").play();
			}
		}*/
		
		public function onDeath():void 
		{
			if(!dead)
			{
				_health = 0;
				dead = true;
				_respawnTimer = REPAWN_TIME;
				content.visible = false;
				AudioLazy.playAt("die", x, y);
				//(_level.getLayer("hud") as HUD).redrawScores();
				var i:int = 8;
				var chip:Chip;
				while(i > 0)
				{
					chip = new Chip(level, "mc_seed", this);
					scene.addActor(chip);
					--i;
				}
				level.hud.light.start(1.0);
				
				var startPoint:Actor = scene.getActorsByType("start_point")[_id];
				x = startPoint.x;
				y = startPoint.y;
				updateTransform();
			}
		}
		
		public function checkPickUp():Bun
		{
			var cx:Number = x;
			var extra:Number = 0.4 + 0.5*bonusQuad;
			var w:Number = HIT_WIDTH*(1.0+extra);
			var bun:Bun;
			var buns:Vector.<Actor>;
			
			if(_lookDir < 0) cx -= HIT_WIDTH*extra;
			
			buns = scene.grid.queryRect(cx, y, w, HIT_HEIGHT, ActorMask.PICKABLE);
			
			for each(bun in buns)
			{
				if(bun && bun.isPickableFor(this))
				{
					return bun;
				}
			}
			
			return null;
		}

		public function onKick(owner:Actor, amount:int = 0, time:Number = -1.0):void 
		{
			if(!kicked && _bonusUndead <= 0.0)
			{
				if(time < 0.0)
					_kickTimeout = RECOVER_TIME;
				else 
					_kickTimeout = time;
				
				_grounded = false;
				_doubleJump = true;
				
				onDiveExit();
				onFlyExit();
				onDropItem(false);
				
				AudioLazy.playAt("kicked", x, y);
				
				if(amount > 0)
				{
					var fx:FeatherEffect = new FeatherEffect(x, y);
					fx.splatHero(XMath.clamp(32*amount/50, 5, 32), _sprite.skinBaseColor);
					layer.addChild(fx);
					
					var bt:HittedText = new HittedText(x, y, (-amount).toString(), COLORS[_id]);
					layer.addChild(bt);
					
					onDamage(owner, amount);
				}
			}
		}
		
		public function onDamage(owner:Actor, amount:int):void
		{
			var prev:int = _health;
			var safe:Boolean = (_health > 1);
			var bt:HittedText;
			
			_health -= amount;
			if(safe && _health <= 0)
			{
				_health = 1;
			}
			
			if(_health <= 0)
			{
				_health = 0;
				
				if(owner && owner is Player)
				{
					(owner as Player)._stats.onFrag();
					
					bt = new HittedText(owner.x, owner.y, "+1 FRAG", COLORS[(owner as Player).id]);
					layer.addChild(bt);
				}
				else
				{
					_stats.onFrag(-1);
					
					bt = new HittedText(x, y, "-1 FRAG", COLORS[_id]);
					layer.addChild(bt);
				}
				
				ModeManager.instance.onFrag();
				level.hud.onFrag();
				
				onDeath();
			}
			else
			{
				level.hud.light.start(0.5);
			}
			
			_stats.onDamage(owner, prev - _health);
		}
		
		public function onHeal(amount:int = 0):void 
		{
			if(amount > 0)
			{
				_health += amount;
				if(_health > Player.MAX_HEALTH) {
					_health = Player.MAX_HEALTH;
				}
				//var fx:FeatherEffect = new FeatherEffect(x, y);
				//fx.splatHero(XMath.clamp(32*amount/50, 5, 32), _sprite.skinBaseColor);
				//layer.addChild(fx);
				
				var bt:HittedText = new HittedText(x, y, "+" + amount, COLORS[_id]);
				layer.addChild(bt);
			}
		}
		
		public function get kicked():Boolean
		{
			return _kickTimeout > 0.0;
		}
		
		public function resetDoubleJump():void
		{
			_doubleJump = false;
		}
		
		public function resetLongJump():void
		{
			_longJump = false;
			_longJumpTimer = 0.0;
		}

		public function get score():int
		{
			return _score;
		}

		public function get health():int
		{
			return _health;
		}

		public function get lookDir():int
		{
			return _lookDir;
		}

		public function set grounded(value:Boolean):void
		{
			_grounded = value;
		}

		public function get grounded():Boolean
		{
			return _grounded;
		}

		public function get dive():Boolean
		{
			return _dive;
		}

		public function get respawnTimer():Number
		{
			return _respawnTimer;
		}

		public function get kickTimeout():Number
		{
			return _kickTimeout;
		}

		public function get fly():Boolean
		{
			return _fly;
		}

		public function get pickedItem():Bun
		{
			return _pickedItem;
		}
		
		public function get canDive():Boolean
		{
			return !kicked && !_dive && !_grounded && _diveLock <= 0.0 && vy > 0.0;
		}
		
		public function get diveEnterTimer():Number
		{
			return _diveEnter;
		}

		public function updateBonus(dt:Number):void
		{
			if(_bonusUndead > 0.0)
			{
				_bonusUndead -= dt;
			}
			
			if(_bonusSpeedup > 0.0)
			{
				_bonusSpeedup -= dt;
			}
			
			if(_bonusQuad > 0.0)
			{
				_bonusQuad -= dt;
			}
			
			if(_teleportTime > 0.0)
			{
				_teleportTime -= dt;
				if(_teleportTime <= 0.0)
				{
					x = _teleportX;
					y = _teleportY;
					_sprite.startSqueeze();
					updateTransform();
					AudioLazy.playAt("sfx_bonus_teleport", x, y);
				}
			}
		}

		public function get bonusQuad():Number
		{
			return _bonusQuad / BONUS_QUAD_TIME;
		}

		public function get bonusUndead():Number
		{
			return _bonusUndead / BONUS_UNDEAD_TIME;
		}

		public function get bonusSpeedup():Number
		{
			return _bonusSpeedup / BONUS_SPEEDUP_TIME;
		}

		public function get home():House
		{
			return _home;
		}

		public function get ai():BaseAI
		{
			return _ai;
		}

		public function get reload():Number
		{
			return _reload;
		}

		public function get doubleJump():Boolean
		{
			return _doubleJump;
		}

		public function get id():int
		{
			return _id;	
		}
		
		public function getJumpLength(height:Number):Number
		{
			// TODO: get jump length correctly
			var vx:Number = MOVEH_VEL_MAX;
			
			if(_bonusSpeedup > 0.0)
			{
				vx *= 1.5;
			}
			//var hmax:Number = getMaxJumpHeight();
			return -vx*height/JUMP_VEL;
		}
		
		public function getMaxJumpHeight():Number
		{
			var height:Number = 0.0;
			
			height += guessJumpHeight(JUMP_VEL, JUMP_TIME_TOTAL);
			if(!_pickedItem)
				height += guessJumpHeight(DJUMP_VEL, JUMP_TIME_TOTAL);
				
			return height;
		}
		
		public function getJumpHeight():Number
		{
			var height:Number = 0.0;
			var longTime:Number = 0.0;
			
			if(_longJump) longTime = JUMP_TIME_TOTAL - _longJumpTimer;
			// считаем всё
			if(_grounded)
			{
				height += guessJumpHeight(JUMP_VEL, JUMP_TIME_TOTAL);
				if(!_pickedItem)
					height += guessJumpHeight(DJUMP_VEL, JUMP_TIME_TOTAL);
			}
			else
			{
				if(!_doubleJump)
				{
					height += guessJumpHeight(vy, longTime);
					if(!_pickedItem)
						height += guessJumpHeight(DJUMP_VEL, JUMP_TIME_TOTAL);
				}
				else if(!_fly)
				{
					height += guessJumpHeight(vy, longTime);
				}
			}
			
			return height;
		}
		
		public function guessJumpHeight(vy:Number, longTime:Number):Number
		{
			var t:Number = 0.0;
			var height:Number = 0.0;
			var v:Number = vy;
			
			if(v < 0.0)
			{
				if(longTime > 0.0)
				{
					t = longTime;
					height += -(v*t + GRAVITY_LONG*t*t*0.5);
					v = v + GRAVITY_LONG*t;
				}
				
				if(v < 0.0)
				{
					height += v*v*0.5/GRAVITY;
				}
			}
			
			return height;
		}
		
		public function getEnemy():Player
		{
			var result:Player;
			var enemy:Player;
			
			if(scene)
			{
				for each (enemy in scene.getActorsByType("player"))
				{
					if(enemy && enemy != this)
					{
						result = enemy; 
						break;
					}
				}
			}
			
			return result;
		}
		
		public function getPickedItemPosition():Point
		{
			return _sprite.getPickedItemPosition();
		}

		public function get stats():PlayerStats
		{
			return _stats;
		}

		public function get profile():Object
		{
			return _profile;
		}
		
		public static function getPlayerByID(scene:LevelScene, id:int):Player
		{
			var actors:Vector.<Actor> = scene.getActorsByType("player");
			var player:Player;
			
			for each (player in actors)
			{
				if(player && player.id == id)
				{
					return player;
				}
			}
			
			return null;
		}

		public function get inputMap():InputMap
		{
			return _inputMap;
		}
	}
}
