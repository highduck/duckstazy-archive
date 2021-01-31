package com.ek.duckstazy.particles
{
	import com.ek.library.asset.AssetManager;
	import com.ek.library.core.CoreManager;
	import com.ek.library.debug.Console;
	import com.ek.library.gocs.GameObject;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * @author Elias Ku
	 */
	public class ParticleShow extends GameObject
	{
		private var _pm:IParticleManager;
		private var _emitter:ParticleEmitter;
		
		private var _perfLastUpdate:int = getTimer();
		private var _perfTime:int;
		private var _perfCount:int;
		private var _perfResult:Number = 0.0;
		
		private var _actor:Sprite = new Sprite();
		
		public function ParticleShow()
		{
			super();
			
			_pm = new LLParticleManager();
			_pm.setStyleFactory(new ParticleShowFactory());
			//_pm = new ArrayParticleManager();
			_pm.addStylesFromXML(AssetManager.getXML("settings").particles[0]);
						
			_emitter = new ParticleEmitter(_pm, this, _actor);
			
			_emitter.addChannel("blue_bubble", 500);
			_emitter.addChannel("brown_bubble", 200);

			CoreManager.root.addChildAt(this, 0);
			
			_actor.graphics.beginFill(0x00ff00);
			_actor.graphics.drawCircle(0, 0, 20);
			_actor.graphics.endFill();
			this.addChild(_actor);
			CoreManager.root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			_actor.x = event.stageX;
			_actor.y = event.stageY;
		}
		
		public override function tick(dt:Number):void {
			//super.tick(dt);
		
			_perfLastUpdate = getTimer();
			
			_emitter.update(dt);
			_pm.update(dt);
			
			_perfTime += (getTimer() - _perfLastUpdate);
			_perfCount++;
			
			if(_perfCount > 10) {
				_perfResult = _perfTime / _perfCount;
				_perfCount = 0;
				_perfTime = 0;
			}
			
			Console.proxy.setInfo(1, "perf: " + _perfResult.toFixed(1) + " ms\nparticles: " + _pm.getActiveParticlesCount() + "\npool: " + _pm.getParticlesPoolLength());
		}
	}
}
