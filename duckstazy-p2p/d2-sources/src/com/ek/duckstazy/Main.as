package com.ek.duckstazy
{
	import com.ek.duckstazy.particles.ParticleShow;
	import com.ek.duckstazy.game.Game;

	import flash.display.Sprite;
	import flash.events.Event;



	/**
	 * @author eliasku
	 */
	[Frame(factoryClass="com.ek.duckstazy.Preloader")]
	[SWF(backgroundColor="#333333", width="760", height="600", frameRate="60")]	
	public class Main extends Sprite 
	{
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			initialize();
		}

		private function initialize():void 
		{
			initializeHandler(null);
		}

		private function initializeHandler(event:Event):void 
		{
			if(true)
			{
				dispatchEvent(new Event("initialization_ok"));
				start();
			}
			else
			{
				dispatchEvent(new Event("initialization_error"));
			}
		}

		private function start():void
		{
			//Game.create();
			new ParticleShow();

			stage.removeChild(this);
		}
	}
}
