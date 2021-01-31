package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.effects.ParticleFX;
	import com.ek.duckstazy.utils.XMath;
	import com.ek.duckstazy.utils.XRandom;
	import com.ek.library.asset.AssetManager;
	import com.ek.library.audio.AudioLazy;
	import com.ek.library.utils.easing.Exponential;
	import com.ek.library.utils.easing.Quadratic;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;






	/**
	 * @author eliasku
	 */
	public class DuckSprite extends Sprite
	{
		private var _owner:Player;
				
		private var _mcRun:MovieClip;
		private var _mcIdle:MovieClip;
		private var _mcJumpUp:MovieClip;
		private var _mcJumpDown:MovieClip;
		private var _mcFire:MovieClip;
		
		private var _skel:MovieClip;
		private var _skinIndex:int;
		
		
		private var _running:Boolean;
		private var _runFrame:Number = 1.0;
		private var _runningBlend:Number = 0.0;
		
		private var _jumpFrame:Number = 0.0;
		private var _jumpState:int = 0;
		private var _jumpStateLast:int = 0;
		private var _jumpBlend:Number = 0.0;

		private var _stepTime:Number = 0.0;
		
		private var _diveTween:Number = 0.0;
		private var _divePS:Number = 0.0;
		
		private var _fireTween:Number = 0.0;
		
		private var _fly:Number = 0.0;
		private var _flyBlend:Number = 0.0;
		
		private var _pickedBlend:Number = 0.0;
		
		private var _blinkTween:Number = 0.0;
		private var _trailsTimer:Number = 1.0;
		
		private var _squeeze:Number = 0.0;
		
		private var _pulsed:Number = 0.0;

		public function DuckSprite(owner:Player)
		{
			_owner = owner;
			
			_mcRun = AssetManager.getMovieClip("mc_duck_run");
			_mcRun.stop();
			_mcIdle = AssetManager.getMovieClip("mc_duck_idle");
			_mcIdle.stop();
			
			_mcJumpUp = AssetManager.getMovieClip("mc_duck_jump_up");
			_mcJumpUp.stop();
			_mcJumpDown = AssetManager.getMovieClip("mc_duck_jump_down");
			_mcJumpDown.stop();
			
			_mcFire = AssetManager.getMovieClip("mc_duck_fire");
			_mcFire.stop();
			
			_skel = AssetManager.getMovieClip("mc_duck_idle");
			_skel.stop();
			
			_skel.s_eye.xeye.visible = false;
			
			addChild(_skel);
			
			mouseEnabled = false;
			mouseChildren = false;
			blendMode = BlendMode.LAYER;

			redraw();
			
			blendMode = BlendMode.LAYER;
		}
		
		public function set skinIndex(value:int):void
		{
			var parts:Array = ["s_body", "s_wing", "s_eye", "s_leg_f", "s_leg_b"];
			var part:MovieClip;
			
			for each (var name:String in parts)
			{
				part = _skel[name];
				if(part)
				{
					part.gotoAndStop(value);
				}
			}
			
			_skinIndex = value;
		}
		
		public function get skinIndex():int
		{
			return _skinIndex;
		}
		
		public function get skinBaseColor():uint
		{
			switch(_skinIndex)
			{
				case 1:
					return 0xfff000;
				case 2:
					return 0xff4be8;
			}
			
			return 0xffffff;
		}
		
		public function tick(dt:Number):void
		{
			// TWEEN EFFECTS
			
			if(_squeeze > 0.0)
			{
				_squeeze -= dt*3.25;
				if(_squeeze < 0.0)
					_squeeze = 0.0;
			}
			
			if(_pulsed > 0.0)
			{
				_pulsed -= dt*3.25;
				if(_pulsed < 0.0)
					_pulsed = 0.0;
			}
			
			// PRE FLY
			if(_owner)
			{
				tickFly(dt);
			}
			
			// RUN
			_runFrame += dt*40;
			while(int(_runFrame) > _mcRun.totalFrames)
				_runFrame -= _mcRun.totalFrames;
			if(int(_runFrame) != _mcRun.currentFrame)
				_mcRun.gotoAndStop(int(_runFrame));
				
			if(_running && _runningBlend < 1.0)
				_runningBlend += dt*4.0;
			else if(!_running && _runningBlend > 0.0)
				_runningBlend -= dt*8.0;
			
			blend(_runningBlend, _mcIdle, _mcRun);
			
			if(_owner && !_owner.dead && _owner.grounded && _running)
			{
				_stepTime += dt*4.5;
				if(_stepTime > 1.0)
				{
					_stepTime -= int(_stepTime);
					
					if(XRandom.random() > 0.5)
						AudioLazy.playAt("sfx_step1", _owner.x, _owner.y, _runningBlend);
					else
						AudioLazy.playAt("sfx_step2", _owner.x, _owner.y, _runningBlend);
						
					if(_runningBlend > 0.3)
						ParticleFX.createDuckBubbles(_owner, 2);
						
					if(_owner.bonusQuad > 0.0)
					{
						_owner.level.cameraShaker.shake(2.0, 0.2);
						AudioLazy.playAt("sfx_land", _owner.x, _owner.y, _runningBlend*0.5);
					}
				}
			}
			
			// JUMP
			_jumpFrame += dt*(30 - 15*_flyBlend);
			while(int(_jumpFrame) > _mcJumpUp.totalFrames)
				_jumpFrame -= _mcJumpUp.totalFrames;
			if(int(_jumpFrame) != _mcJumpUp.currentFrame)
			{
				_mcJumpUp.gotoAndStop(int(_jumpFrame));
				_mcJumpDown.gotoAndStop(int(_jumpFrame));
			}
			
			if(_jumpState > 0 && _jumpBlend < 1.0)
				_jumpBlend += dt*8.0;
			else if(_jumpState == 0 && _jumpBlend > 0.0)
				_jumpBlend -= dt*8.0;
			
			if(_jumpState == 1)
				blend(_jumpBlend, _skel, _mcJumpUp);
			else if(_jumpState == 2)
				blend(_jumpBlend, _skel, _mcJumpDown);
			else
			{
				if(_jumpStateLast == 2)
					blend(_jumpBlend, _skel, _mcJumpDown);
				else
					blend(_jumpBlend, _skel, _mcJumpUp);
			}

			var blinking:Boolean;
			
			_blinkTween += dt;
			if(_blinkTween >= 1.0)
				_blinkTween -= int(_blinkTween);
				
			if(_owner)
			{
				blinking = _owner.kicked;
				
				if(blinking)
				{
					var add:Number = 255.0*0.7*(int(_blinkTween*16)%2);
					_owner.content.transform.colorTransform = new ColorTransform(1,1,1,1,add,add,add);
					//_owner.content.alpha = 0.3 + 0.7*(int(_blinkTween*16)%2); 
				}
				else
				{
					//_owner.content.alpha = 1.0;
					_owner.content.transform.colorTransform = new ColorTransform();
				}
				
				if(_owner.bonusUndead > 0.0)
				{
					_skel.s_eye.xeye.visible = true;
					_skel.s_eye.normal_eye.visible = false;
					_owner.content.alpha = 0.5;// = new ColorTransform(1.0, 1.0, 1.0, 0.5, 0, 0, 0);
				}
				else
				{
					_skel.s_eye.xeye.visible = false;
					_skel.s_eye.normal_eye.visible = true;
					_owner.content.alpha = 1.0;
					//_owner.content.transform.colorTransform = new ColorTransform();
				}
							
				// KICKED
				if(_owner.kickTimeout > 0.0)
				{
					if(!_owner.grounded)
					{
						blend(XMath.clamp(_owner.kickTimeout), _skel, _mcJumpDown);
					}
				}
			}

			
			// DIVE
			if(_diveTween > 0.0)
			{
				_diveTween -= dt*8.0;
				if(_diveTween < 0.0)
					_diveTween = 0.0;
			}
			
			if(_owner && _owner.dive)
			{
				_divePS += dt*62;
				ParticleFX.duckDiveParticles(_owner, int(_divePS), true);
				_divePS -= int(_divePS);
			}
			
			// POST FLY: blend
			if(_owner && _owner.fly)
			{
				_skel.s_wing.x -= 6*_flyBlend;
				_skel.s_wing.rotation += _flyBlend*(45+60*Math.sin(_fly*Math.PI*4));
			}
			
			// FIRE			
			if(_fireTween > 0.0)
			{
				_fireTween -= dt*4.0;
				if(_fireTween < 0.0) _fireTween = 0.0;
			}
			blend(Quadratic.easeOut(_fireTween, 0, 0, 0), _skel, _mcFire, ["s_wing"]);
			
			// PICKED
			if(_owner)
			{
				if(_owner.pickedItem && _pickedBlend < 1.0)
					_pickedBlend += dt*15.0;
				else if(!_owner.pickedItem && _pickedBlend > 0.0)
					_pickedBlend -= dt*8;
			}
				
			if(_pickedBlend > 0.0)
			{
				blend(_pickedBlend, _skel, _mcFire, ["s_wing"]);
				_skel.s_wing.x -= 2*_pickedBlend;
				_skel.s_wing.y += 3*_pickedBlend;
				_skel.s_wing.rotation += _pickedBlend*30.0;
			}
			
			redraw();
			
			var quadTween:Number = 0.0;
			
			if(_owner)
			{
				quadTween = Exponential.easeOut(_owner.bonusQuad, 0, 0, 0);
			}
			
			var eyeScale:Number = 1.0;
			var eyeScaleUp:Number = 0.0;
			if(_owner)
			{
				if(_owner.dive)
				{
					eyeScaleUp = 1.0;
				}
				else if(_owner.canDive && _owner.diveEnterTimer > 0.0)
				{
					eyeScaleUp = _owner.diveEnterTimer;
				}
				
				eyeScaleUp = Math.max(Math.max(eyeScaleUp, _owner.bonusSpeedup), quadTween*0.5);
			}

			eyeScale += 0.5*eyeScaleUp;
			
			if(eyeScale > 1.0)
			{
				_skel.s_eye.scaleX = _skel.s_eye.scaleY = eyeScale;
				_skel.s_eye.x -= (eyeScale-1.0)*3.0;
				_skel.s_eye.y -= (eyeScale-1.0)*3.0;
			}
			
			var squeezeFactor:Number = -0.4*(Math.sin(-Math.PI*2.0*_squeeze))*_squeeze;
			var pulseFactor:Number = 0.15*(Math.sin(-Math.PI*2.0*_pulsed))*_pulsed;
			var scale:Number = 0.5 + quadTween*0.2 + pulseFactor;
				
			_skel.scaleX = scale - squeezeFactor;
			_skel.scaleY = scale + squeezeFactor;
			
			if(_owner)
			{
				if(_owner.dive || _owner.bonusSpeedup > 0.0)
				{
					_trailsTimer -= dt*16.0;
					if(_trailsTimer <= 0.0)
					{
						_trailsTimer = 1.0;
						var a:Number = 1.0;
						if(_owner.bonusUndead > 0.0) a = 0.5;
						ParticleFX.createFakeMotion(_owner.layer, _owner.content, a);
					}
				}
			}
		}

		private function tickFly(dt:Number):void
		{
			var oldFly:Number = _fly;
			var playWing:Boolean;
			
			if(_owner.fly && _flyBlend < 1.0)
				_flyBlend += dt*4.0;
			else if(!_owner.fly && _flyBlend > 0.0)
				_flyBlend -= dt*5.0;	
			
			_fly += dt*2.25;
			if(oldFly < 0.5 && _fly >= 0.5) playWing = true;
			if(_fly > 1.0)
			{
				playWing = true;
				_fly -= int(_fly);
			}
			
			if(_flyBlend > 0.0 && playWing)
			{
				if(XRandom.random() > 0.5)
					AudioLazy.playAt("sfx_wing1", _owner.x, _owner.y, _flyBlend);
				else
					AudioLazy.playAt("sfx_wing2", _owner.x, _owner.y, _flyBlend);
			}
		}

		public function onDiveEnter():void
		{
			_diveTween = 1.0;
			ParticleFX.duckDiveParticles(_owner, 32);
			_divePS = 0;
		}
		
		public function redraw():void
		{
			var m:Matrix = new Matrix();
			m.translate(0, 18);
			
			var diveScaleFactor:Number = 0.0;
		
			if(_owner && _owner.dive)
			{
				diveScaleFactor = Math.abs(_owner.vy)/1250.0;
				filters = [new BlurFilter(int(_diveTween*4.0)+1.0, Math.abs(_owner.vy)/50.0, 3)];
			}
			else
			{
				filters = [];
			}
			
			var lookDir:int = 1;
			
			if(_owner)
			{
				lookDir = _owner.lookDir;
			}
			
			m.rotate(-_diveTween*Math.PI*2);
			m.scale(lookDir, 1.0 + diveScaleFactor);
			
			m.translate(10, 20-18);
			
			transform.matrix = m;
		}
		
		public function blend(f:Number, src:MovieClip, dest:MovieClip, filter:Array = null):void
		{
			var sprite:String;
			if(!filter) filter = ["s_body", "s_wing", "s_eye", "s_leg_f", "s_leg_b"];
			f = Math.min(1.0, Math.max(0.0, f));
			for each (sprite in filter)
				blendSprite(sprite, _skel, src, dest, f);
		}
		
		public function blendSprite(name:String, target:MovieClip, src:MovieClip, dest:MovieClip, f:Number):void
		{
			var d_src:DisplayObject = src[name];
			var d_dest:DisplayObject = dest[name];
			var d_target:DisplayObject = target[name];
			
			if(!d_src || !d_dest || !d_target) return;
			
			var inv:Number = 1.0 - f;
			d_target.x = inv*d_src.x + f*d_dest.x;
			d_target.y = inv*d_src.y + f*d_dest.y;
			d_target.rotation = inv*d_src.rotation + f*d_dest.rotation;
			d_target.scaleX = inv*d_src.scaleX + f*d_dest.scaleX;
			d_target.scaleY = inv*d_src.scaleY + f*d_dest.scaleY;
			
			
		}

		public function run(dir:int):void
		{
			var lastrun:Boolean = _running || _runningBlend <= 0.3;
			_running = (dir != 0);
			if(!lastrun && _running)
			{
				_mcRun.gotoAndStop(7);
				_stepTime = 0.1;
			}
		}
		
		public function jump(state:int, reset:Boolean = false, lastState:int = -1, blend:Number = 0.0):void
		{
			if(_jumpState != state)
				_jumpStateLast = _jumpState;
			_jumpState = state;
			if(reset) _jumpBlend = blend;
			if(lastState >= 0) _jumpStateLast = lastState;
		}
		
		
		
		public function onFire():void
		{
			_fireTween = 1.0;
			AudioLazy.playAt("jump_1", _owner.x, _owner.y);
		}

		public function get flyCycle():Number
		{
			return Math.sin(-_fly * Math.PI * 2.0);
		}

		public function startSqueeze():void
		{
			_squeeze = 1.0;
		}

		public function startPulse():void
		{
			_pulsed = 1.0;
		}
		
		public function getPickedItemPosition():Point
		{
			var p:Point = new Point(38, -23);
			p = (_skel).localToGlobal(p);
			p = _owner.layer.globalToLocal(p);
			return p;
		}
	}
}
