package com.ek.duckstazy.edit
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	/**
	 * @author eliasku
	 */
	public class VectorComponent extends Component
	{
		private var _title:Label;
		private var _labelX:Label;
		private var _labelY:Label;
		private var _stepperX:NumericStepper;
		private var _stepperY:NumericStepper;
		private var _onChange:Function;
		
		public function VectorComponent(parent:DisplayObjectContainer, xpos:int, ypos:int, label:String, onChange:Function)
		{
			super(parent, xpos, ypos);
			
			_title.text = label;
			_onChange = onChange;
		}

		protected override function addChildren():void
		{
			var width:int = 220;
			var x1:int = 4;
			var y1:int = 4;
			
			//if(parent) width = parent.width;
			
			_title = new Label(this, x1, y1, "Title");
			
			y1 += _title.height + 3;
			_labelX = new Label(this, x1, y1, "X: ");
			_stepperX = new NumericStepper(this, x1+_labelX.width+2, y1, onValueChanged);
			_stepperX.width = width / 3 - 8;
			_labelY= new Label(this, width / 2, y1, "Y: ");
			_stepperY = new NumericStepper(this, width / 2 +_labelY.width+2, y1, onValueChanged);
			_stepperY.width = width / 3 - 8;
			
			setSize(width, y1 + _labelY.height + 3);
		}

		private function onValueChanged(e:Event):void
		{
			if(_onChange != null)
				_onChange(e);
	
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get labelX():Label
		{
			return _labelX;
		}

		public function get labelY():Label
		{
			return _labelY;
		}

		public function get stepperX():NumericStepper
		{
			return _stepperX;
		}

		public function get stepperY():NumericStepper
		{
			return _stepperY;
		}

		public function setVector(x:Number, y:Number):void
		{
			_stepperX.value = x;
			_stepperY.value = y;
		}
		
		public function get valueX():Number
		{
			return _stepperX.value;
		}

		public function get valueY():Number
		{
			return _stepperY.value;
		}
		
		public function set valueX(value:Number):void
		{
			_stepperX.value = value;
		}
		
		public function set valueY(value:Number):void
		{
			_stepperY.value = value;
		}
		
	}
}
