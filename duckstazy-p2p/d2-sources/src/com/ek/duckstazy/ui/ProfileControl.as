package com.ek.duckstazy.ui
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.ek.duckstazy.game.DisplayUtils;
	import com.ek.duckstazy.game.actors.DuckSprite;
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.library.core.CoreManager;
	import com.ek.library.gocs.GameObject;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	public class ProfileControl extends GameObject
	{
		private var _id:int;
		private var _tfName:TextField;
		private var _lblName:Label;
		private var _previewContainer:Sprite;
		private var _preview:DuckSprite;
		private var _checkAI:CheckBox;
		
		public function ProfileControl(id:int)
		{
			_id = id;		
			
			_lblName = new Label(this, 100, 50, "P" + id);
			
			_preview = new DuckSprite(null);
			_preview.skinIndex = id + 1;
			_preview.run(1);

			_previewContainer = new Sprite();
			_previewContainer.addChild(_preview);
			addChild(_previewContainer);
			
			_previewContainer.x = 30;
			_previewContainer.y = 60;
			_previewContainer.scaleX = 1.3;
			_previewContainer.scaleY = 1.3;
			
			_checkAI = new CheckBox(this, 100, 80, "Mind Sucker");
			_checkAI.selected = false;
			
			scrollRect = new Rectangle(0, 0, 200, 100);
			opaqueBackground = Player.COLORS[id];
			
			_tfName = DisplayUtils.createTextField(16);
			_tfName.type = TextFieldType.INPUT;
			_tfName.x = 100;
			_tfName.y = 10;
			_tfName.selectable = true;
			_tfName.mouseEnabled = true;
			_tfName.text = "Player " + (id+1);
			_tfName.addEventListener(Event.CHANGE, onNameChanged);
			_tfName.addEventListener(FocusEvent.FOCUS_IN, onNameFocusIn);
			_tfName.addEventListener(FocusEvent.FOCUS_OUT, onNameFocusOut);
			_tfName.addEventListener(KeyboardEvent.KEY_DOWN, onNameKeyDown);
			addChild(_tfName);
		}

		private function onNameKeyDown(event:KeyboardEvent):void
		{
			if(CoreManager.stage.focus == _tfName)
			{
				event.stopPropagation();
				switch(event.keyCode)
				{
					case Keyboard.ENTER:
					case Keyboard.ESCAPE:
						onNameFocusOut(null);
						break;
				}
			}
		}
		
		private function onNameFocusOut(event:FocusEvent):void
		{
			if(_tfName == CoreManager.stage.focus)
			{
				CoreManager.stage.focus = null;
			}
		}

		private function onNameFocusIn(event:FocusEvent):void
		{
			CoreManager.stage.focus = _tfName;
		}
		
		private function onNameChanged(event:Event):void
		{
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_preview.tick(dt);
		}
		
		public function get profileSettings():Object
		{
			return {name:_tfName.text, ai:_checkAI.selected};
		}
	}
}
