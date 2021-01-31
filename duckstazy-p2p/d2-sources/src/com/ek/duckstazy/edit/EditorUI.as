package com.ek.duckstazy.edit
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.ek.duckstazy.game.CameraController;
	import com.ek.duckstazy.game.CameraLayer;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.library.core.CoreManager;
	import com.ek.library.gocs.GameObject;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;









	/**
	 * @author eliasku
	 */
	public class EditorUI extends GameObject
	{	
		private var _editor:Editor;
		private var _editorLayer:CameraLayer;
		private var _editorContainer:Sprite;
		
		private var _window:Window;
		
		
		private var _btnSave:PushButton;
		private var _btnTest:PushButton;
		private var _btnOpen:PushButton;
		private var _btnExit:PushButton;
		private var _chkGrid:CheckBox;
		
		private var _comboLayers:ComboBox;
		private var _listObjects:List;
		
		private var _selectedLayer:CameraLayer;
		private var _selectedObject:Object;
		
		private var _objectWindow:InspectorUI;
		
		private var _bounds1:VectorComponent;
		private var _bounds2:VectorComponent;
		
		private var _panCameraStart:Point;
		private var _panMouseStart:Point;
		private var _panning:Boolean;
		
		private var _spriteGrid:Sprite = new Sprite();
		private var _spriteBounds:Sprite = new Sprite();
		private var _box:TransformControl;
		
		public function EditorUI(editor:Editor)
		{
			_editorLayer = new CameraLayer("editor", 1.0, 1.0, 0.0, 0.0);
			_editor = editor;
			
			_editorLayer.mouseChildren = true;
			_editorLayer.mouseEnabled = false;
			
			_spriteBounds.mouseEnabled = false;
			_spriteBounds.mouseChildren = false;
			_editorLayer.addChild(_spriteBounds);
			
			_spriteGrid.mouseEnabled = false;
			_spriteGrid.mouseChildren = false;
			_editorLayer.addChild(_spriteGrid);
			
			_box = new TransformControl(editor);
			_editorLayer.addChild(_box);
			
			_editorContainer = new Sprite();
			addChild(_editorContainer);
			
			_window = new Window(_editorContainer, 0, 0, "Editor");
			_window.setSize(200, 300);
			_window.hasMinimizeButton = true;
			_window.minimized = true;
			
			var cy:int = 1;
			
			_btnTest = new PushButton(_window.content, 48*0, cy, "Test", onTest);
			_btnTest.setSize(46, 16);
			
			_btnSave = new PushButton(_window.content, 48*1, cy, "Save", onSave);
			_btnSave.setSize(46, 16);
			
			_btnOpen = new PushButton(_window.content, 48*2, cy, "Open", onLoad);
			_btnOpen.setSize(46, 16);
			
			_btnExit = new PushButton(_window.content, 48*3, cy, "Exit", onExit);
			_btnExit.setSize(46, 16);
			
			cy += 18;
			
			_chkGrid = new CheckBox(_window.content, 1, cy, "Show grid", onShowGrid);
			_chkGrid.selected = _spriteGrid.visible;
			
			cy += 18;
			
			
			
			_bounds1 = new VectorComponent(_window.content, 0, cy, "Level bounds (left, top)", onBoundsChanged);
			_bounds2 = new VectorComponent(_window.content, 0, cy + _bounds1.height, "Level bounds (width, height)", onBoundsChanged);
			
			cy = 160;
			
			_comboLayers = new ComboBox(_window.content, 0, cy, "layers");
			_comboLayers.addEventListener(Event.SELECT, onLayerSelect);
			
			_listObjects = new List(_window.content, 0, cy + 24);
			_listObjects.addEventListener(Event.SELECT, onObjectSelect);
			
			
			
			
			
			CoreManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			CoreManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			CoreManager.stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			CoreManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			
			_objectWindow = new InspectorUI(this);
		}

		private function onShowGrid(e:Event):void
		{
			_spriteGrid.visible = _chkGrid.selected;
		}

		


		private function redrawGrid():void
		{
			const size:int = Editor.GRID_SIZE;
			var i:int;
			const wb:Rectangle = _editor.scene.worldBounds;
			var startX:int = size * int(wb.x / size);
			var startY:int = size * int(wb.y / size);
			var g:Graphics = _spriteGrid.graphics;
			
			g.clear();
			g.lineStyle(1, 0, 0.5);
			
			for(i = 0; i < wb.height / size; i++)
			{
				g.moveTo(startX, startY + i*size);
				g.lineTo(startX + wb.width, startY + i*size);
			}
			
			for(i = 0; i < wb.width / size; i++)
			{
				g.moveTo(startX + i*size, startY);
				g.lineTo(startX + i*size, startY + wb.height);
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var dx:int;
			var dy:int;
			
			if(_panMouseStart)
			{
				dx = _panMouseStart.x - e.stageX;
				dy = _panMouseStart.y - e.stageY;
				
				if(_panning)
				{
					_editor.cameraController.setPosition(_panCameraStart.x + dx, _panCameraStart.y + dy);
				}
			}
		}

		private function onMouseUp(event:MouseEvent):void
		{
			_panCameraStart = null;
			_panMouseStart = null;
		}

		private function onMouseDown(e:MouseEvent):void
		{
			var cc:CameraController = _editor.cameraController;
			_panCameraStart = new Point(-cc.x, -cc.y);
			_panMouseStart = new Point(e.stageX, e.stageY);
		}
		
		private function onPanEnter():void
		{
			_editor.mouseChildren = false;
			_editor.mouseEnabled = false;
			_panning = true;
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function onPanExit():void
		{
			if(_panning)
			{
				_editor.mouseChildren = true;
				_editor.mouseEnabled = true;
			}
			
			_panning = false;
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		
		public function onResize(e:Event):void
		{
			_editor.camera.setSize(CoreManager.displayWidth, CoreManager.displayHeight);
			//_editor.redrawTestSky();
			redrawBounds();
		}

		private function onBoundsChanged(e:Event):void
		{
			_editor.scene.worldBounds = new Rectangle(_bounds1.valueX, _bounds1.valueY, _bounds2.valueX, _bounds2.valueY);
			redrawBounds();
		}
		
		public function start():void
		{
			var layers:Array = [];
			var layerItem:EditorItem;
			var mainItem:EditorItem;
			var layer:CameraLayer;
			
			for each (layer in _editor.scene.layers)
			{
				layerItem = new EditorItem(layer);
				if(layer.name == "main") mainItem = layerItem;
				layers.push(layerItem);
			}
			
			_comboLayers.items = layers;
			_comboLayers.selectedItem = mainItem;
			onLayerSelect(null);
			onObjectSelect(null);
			
			_bounds1.setVector(_editor.scene.worldBounds.x, _editor.scene.worldBounds.y);
			_bounds2.setVector(_editor.scene.worldBounds.width, _editor.scene.worldBounds.height);
			
			onResize(null);
			
			redrawGrid();
		}
		
		private function redrawBounds():void
		{
			var wb:Rectangle = _editor.scene.worldBounds;
			var cb:Rectangle = _editor.scene.cameraBounds;
			var g:Graphics = _spriteBounds.graphics;
			
			g.clear();
			
			g.beginFill(0x000000, 0.5);
			g.drawRect(wb.x-100, wb.y-100, wb.width+200, wb.height+200);
			g.drawRect(wb.x, wb.y, wb.width, wb.height);
			g.endFill();
			
			g.lineStyle(1, 0xff0000);
			g.drawRect(cb.x, cb.y, cb.width, cb.height);
		}

		private function onObjectSelect(event:Event):void
		{
			var item:EditorItem = _listObjects.selectedItem as EditorItem;
			
			if(item && _selectedLayer)
				selectedObject = item.actor;
			else
				selectedObject = null;
			
			
		}

		private function onLayerSelect(event:Event):void
		{
			var item:EditorItem = _comboLayers.selectedItem as EditorItem;
			var actor:Actor;
			var items:Array = [];
			var i:int;
			
			if(item)
				_selectedLayer = item.layer;
			else
				_selectedLayer = null;
			
			if(_selectedLayer)
			{
				for(i = 0; i < _selectedLayer.numChildren; ++i)
				{
					actor = _selectedLayer.getChildAt(i) as Actor;
					if(actor)
						items.push(new EditorItem(actor));
				}
			}
			
			_listObjects.items = items;
		}

		private function onLoad(e:Event):void
		{
			_editor.onLoad();
		}
		
		private function onSave(e:Event):void
		{
			_editor.onSave();
		}
		
		private function onTest(e:Event):void
		{
			_editor.onTest();
			if(_editor.editMode)
			{
				_btnTest.label = "Test";
			}
			else
			{
				_btnTest.label = "Edit";
			}
		}
		
		private function onExit(e:Event):void
		{
			_editor.exit();
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			var focus:DisplayObject = CoreManager.stage.focus;
			var ctrl:Boolean = event.ctrlKey;
			var code:uint = event.keyCode;
			var actor:Actor;

			actor = _selectedObject as Actor;
			
			if(_editor.editMode && !event.ctrlKey && event.keyCode == Keyboard.SPACE)
				onPanEnter();
			
			switch(code)
			{					
				// exit: ESC
				case Keyboard.ESCAPE:
					if(_editor.editMode)
						onExit(null);
					else
						onTest(null);
					break;
				// save: CTRL+S
				case 0x53:
					if(ctrl && _editor.editMode)
						onSave(null);
					break;
				// test/edit: CTRL+T
				case 0x54:
					if(ctrl)
						onTest(null);
					break;
				// open: CTRL+L
				case 0x4C:
					if(ctrl && _editor.editMode)
						onLoad(null);
					break;
				default:
					if(_editor.editMode)
						_box.onKeyDown(event);
					break;
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			var code:uint = event.keyCode;
			
			switch(code)
			{
				case Keyboard.SPACE:
					onPanExit();
					break;
			}
		}
		
		
		
		public function onGizmoClick(actor:Actor):void
		{
			selectedObject = actor;
		}

		public function set selectedObject(value:Object):void
		{
			_selectedObject = value;
			_objectWindow.actor = value as Actor;
			_box.target = value;
		}

		public function get editorContainer():Sprite
		{
			return _editorContainer;
		}

		public function get editorLayer():CameraLayer
		{
			return _editorLayer;
		}
	}
}
