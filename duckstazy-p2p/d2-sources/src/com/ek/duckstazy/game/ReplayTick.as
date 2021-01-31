package com.ek.duckstazy.game
{
	/**
	 * @author eliasku
	 */
	public class ReplayTick
	{
		public var position:int;
		public var deltaTime:Number;
		public var inputs:Object = new Object();

		public function ReplayTick(position:int, deltaTime:Number)
		{
			this.position = position;
			this.deltaTime = deltaTime;
		}

		public function record(inputId:String, inputMap:InputMap):void
		{
			/*if(!inputs.hasOwnProperty(inputId))
				inputs[inputId] = new Object();*/
			
			inputs[inputId] = inputMap.serialize();
		}
		
		public function getInput(inputId:String):Object
		{
			return inputs[inputId];
		}
	}
}
