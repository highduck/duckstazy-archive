package com.ek.duckstazy.edit
{
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.core.CoreManager;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;








	/**
	 * @author eliasku
	 */
	public class InspectorUI extends Window
	{
		private static const WIDTH:int = 200;
		private static const HEIGHT:int = 300;
		
		private var _ui:EditorUI;
		
		private var _prevName:String;
		private var _lblType:Label;
		private var _valType:Label;
		
		private var _lblName:Label;
		
		private var _position:VectorComponent;
		private var _hitSize:VectorComponent;
		
		private var _actor:Actor;
		
		public function InspectorUI(ui:EditorUI)
		{
			super(ui.editorContainer, Config.WIDTH - WIDTH, 0, "Inspector");
			
			_ui = ui;
			
			setSize(WIDTH, HEIGHT);
			hasMinimizeButton = true;
			minimized = true;
			
			createInspectorControls();
		}
		
		private function createInspectorControls():void
		{
			var x1:int = 2;
			var x2:int = 35;
			var y:int;
			
			_lblType = new Label(content, x1, y, "Type: ");
			_valType = new Label(content, x2, y, "");
			
			y += _lblType.height + 1;
			_lblName = new Label(content, x1, y, "Name: ");
			_lblName.addEventListener(MouseEvent.CLICK, onRename);
			_lblName.mouseChildren = true;
			_lblName.textField.mouseEnabled = true;
			
			y += _lblName.height + 3;
			_position = new VectorComponent(content, x1, y, "Position", onPositionChanged);
			
			y += _position.height + 3;
			_hitSize = new VectorComponent(content, x1, y, "Size", onHitSizeChanged);
		}

		private function onRename(event:MouseEvent):void
		{
			if(_lblName.textField.type != TextFieldType.INPUT && actor)
			{
				_lblName.textField.type = TextFieldType.INPUT;
				CoreManager.stage.focus = _lblName.textField;
				_lblName.textField.addEventListener(FocusEvent.FOCUS_OUT, onRenameExit);
				_lblName.textField.addEventListener(KeyboardEvent.KEY_DOWN, onRenameKey);
				//_lblName.addEventListener(Event.CHANGE, onNameChange);
				_lblName.textField.opaqueBackground = 0xffffff;
				_lblName.textField.selectable = true;
				_lblName.textField.setSelection(0, _lblName.textField.text.length);
				_lblName.textField.border = true;
				_lblName.textField.borderColor = 0x000000;
				_prevName = _lblName.text;
			}
		}

		private function onRenameKey(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
					_lblName.text = _prevName;
					onRenameExit(null);
					event.stopImmediatePropagation();
					break;
					
				case Keyboard.ENTER:
					onRenameExit(null);
					
					break;
			}
		}

		private function onRenameExit(event:FocusEvent):void
		{
			CoreManager.stage.focus = null;
			
			_lblName.textField.type = TextFieldType.DYNAMIC;
			_lblName.textField.removeEventListener(FocusEvent.FOCUS_OUT, onRenameExit);
			_lblName.textField.removeEventListener(KeyboardEvent.KEY_DOWN, onRenameKey);
			_lblName.textField.opaqueBackground = null;
			_lblName.textField.selectable = false;
			_lblName.textField.border = false;
			
			onNameChange(null);
		}

		private function onHitSizeChanged(e:Event):void
		{
			if(_actor)
			{
				if(_hitSize.valueX < 1) _hitSize.valueX = 1;
				if(_hitSize.valueY < 1) _hitSize.valueY = 1;
				
				_actor.width = _hitSize.valueX;
				_actor.height = _hitSize.valueY;
				
				_actor.updateTransform();
			}
		}

		private function onPositionChanged(e:Event):void
		{
			if(_actor)
			{
				_actor.x = _position.valueX;
				_actor.y = _position.valueY;
				_actor.updateTransform();
			}
		}

		private function onNameChange(e:Event):void
		{
			if(_actor)
			{
				_actor.name = _lblName.textField.text;
			}
		}

		public function get actor():Actor
		{
			return _actor;
		}

		public function set actor(value:Actor):void
		{
			_actor = value;
			if(_actor)
			{
				_valType.text = _actor.type.toUpperCase();
				_lblName.text = _actor.name;
				title = "Inspector: " + _actor.name;
				
				_position.setVector(_actor.x, _actor.y);
				_position.enabled = true;
				
				_hitSize.setVector(_actor.width, _actor.height);
				_hitSize.enabled = true;
				
			}
			else
			{
				_valType.text = "";
				_lblName.text = "";
				
				title = "Inspector";
				
				_position.setVector(0, 0);
				_position.enabled = false;
				
				_hitSize.setVector(0, 0);
				_hitSize.enabled = false;
			}
		}
	}
}