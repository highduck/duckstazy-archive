package 
com.ek.duckstazy.edit
{
	import com.ek.duckstazy.game.CameraLayer;
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.LevelScene;
	import com.ek.duckstazy.game.base.Actor;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;



	
	/**
	 * @author eliasku
	 */
	public class Editor extends Level
	{
		public static const GRID_SIZE:int = 24;
		
		private var _ui:EditorUI;
		private var _xml:XML;
		private var _fileRef:FileReference;
		private var _editMode:Boolean = true;
		
		public function Editor()
		{
			super();
		}
		
		protected override function initialize():void
		{
			paused = true;
			
			super.initialize();
			
			_ui = new EditorUI(this);
			addChild(_ui);
			
			mouseChildren = true;
			mouseEnabled = true;
			scrollRect = null;
			opaqueBackground = 0xaaaaaa;
			viewport.mouseChildren = true;
			viewport.mouseEnabled = true;
			
			viewport.addEventListener(MouseEvent.CLICK, onGizmoClick);
		}
		
		protected override function onSceneEnter():void
		{
			super.onSceneEnter();
			
			var layer:CameraLayer;
			
			scene.addLayer(_ui.editorLayer);
			
			for each (layer in scene.layers)
			{
				if(layer.name == "editor") continue;
				
				layer.mouseChildren = true;
				layer.mouseEnabled = true;
			}
		}
		
		protected override function onSceneExit():void
		{
			super.onSceneExit();
			
			var layer:CameraLayer;
			
			scene.removeLayer("editor");
			
			for each (layer in scene.layers)
			{
				if(layer.name == "hud" || layer.name == "editor") continue;
				
				layer.mouseChildren = true;
				layer.mouseEnabled = true;
			}
		}

		protected override function initializeCamera():void
		{
			super.initializeCamera();
			
			if(_editMode && scene)
				updateEditorCamera();
		}
		
		public function updateEditorCamera():void
		{
			var wb:Rectangle = scene.worldBounds;
			cameraController.setBounds(wb.x - 500, wb.y - 500, wb.width + 1000, wb.height + 1000);
		}
		
		public override function start():void
		{
			var actor:Actor;
			
			if(_editMode)
			{
				scene = scenes[0];
					
				for each (actor in scene.actors)
				{
					createActorGizmo(actor);
				}
			}
			else
			{
				super.start();
			}
			
			_ui.start();
		}

		public function createActorGizmo(actor:Actor):void
		{
			if(!actor.gizmo)
				actor.gizmo = new Sprite();
				
			if(!actor.gizmo.parent)
				actor.content.addChild(actor.gizmo);
				
			actor.content.mouseEnabled = true;
			actor.content.mouseChildren = false;
		}

		public override function tick(dt:Number):void
		{
			super.tick(dt);
				
			var actor:Actor;
			
			if(_editMode)
			{
				for each (actor in scene.actors)
				{
					if(actor.gizmo)
					{
						actor.gizmo.graphics.clear();
						actor.onGizmo(actor.gizmo.graphics);
					}
				}
			}
			else
			{
				
			}
		}
		
		public function onLoad():void
		{
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.SELECT, onFileSelected, false, 0, true);
			_fileRef.addEventListener(Event.COMPLETE, onFileLoaded, false, 0, true);
			_fileRef.browse( [new FileFilter("Level", "*.xml")] );
		}

		private function onFileSelected(event:Event):void
		{
			_fileRef.load();
		}

		private function onFileLoaded(event:Event):void
		{
			_xml = XML(_fileRef.data.readUTFBytes(_fileRef.data.length));
			cleanup();
			loadXML(_xml);
			start();
		}
		
		public function onSave():void
		{
			var xml:XML = saveXML();
			_fileRef = new FileReference();
			_fileRef.save(xml.toXMLString(), "level.xml");
		}
		
		public function saveXML():XML
		{
			var xml:XML = XML("<level><settings><info/></settings></level>");
			var sceneXML:XML;
			var scene:LevelScene;
			
			xml.settings[0].@start_scene = scenes[0].name;
			
			for each (scene in scenes)
			{
				sceneXML = saveScene(scene);
				xml.appendChild(sceneXML);				
			}
			
			return xml;
		}
		
		public function saveScene(scene:LevelScene):XML
		{
			var xml:XML = XML("<scene><objects/></scene>");
			var objectsNode:XML = xml.objects[0];
			var objectNode:XML;
			
			var actor:Actor;
			
			var rect:Rectangle;
			
			rect = scene.worldBounds;
			xml.@world = rect.x + "; " + rect.y + "; " + (rect.x + rect.width) + "; " + (rect.y + rect.height);
			
			rect = scene.cameraBounds;
			xml.@camera = rect.x + "; " + rect.y + "; " + (rect.x + rect.width) + "; " + (rect.y + rect.height);
			
			xml.@name = scene.name;
			
			for each (actor in scene.actors)
			{
				if(!actor || !actor.layer) continue;
				if(actor.layer.name == "editor" || actor.layer.name == "hud") continue;
				
				objectNode = XML("<object/>");
				objectNode.@type = actor.type;
				actor.saveProperties(objectNode);
				objectsNode.appendChild(objectNode);				
			}
			
			return xml;
		}

		public function onTest():void
		{
			if(_editMode)
			{
				_xml = saveXML();
				_editMode = false;
				paused = false;
			}
			else
			{	
				_editMode = true;
				paused = true;
			}
			
			cleanup();
			loadXML(_xml);
			start();
		}

		public function get editMode():Boolean
		{
			return _editMode;
		}

		public function onGizmoClick(e:MouseEvent):void
		{
			var actor:Actor = e.target as Actor;
			
			_ui.onGizmoClick(actor);
		}
		
	}
}
