package com.ek.duckstazy.game
{
	import com.ek.duckstazy.game.actors.Player;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorFactory;
	import com.ek.duckstazy.game.base.Grid;
	import com.ek.duckstazy.game.nav.NavGraph;
	import com.ek.library.utils.ParserUtil;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;



	/**
	 * @author eliasku
	 */
	public class LevelScene
	{
		private var _level:Level;
		
		private var _name:String = "default";
		
		private var _layers:Vector.<CameraLayer> = new Vector.<CameraLayer>();
		private var _layersLookup:Object = new Object();

		private var _actors:Vector.<Actor> = new Vector.<Actor>();
		private var _actorsByType:Object = new Object();
		
		private var _grid:Grid;
		
		private var _worldBounds:Rectangle;
		private var _cameraBounds:Rectangle;
		
		private var _sky:Sprite;
		
		private var _debugNavGraph:Shape = new Shape();
		private var _debugCollisionGrid:Shape = new Shape();
		
		private var _navGraph:NavGraph;
		
		
		public function LevelScene(level:Level)
		{
			_level = level;
			
			addLayer(new CameraLayer("back", 0.0, 0.0, 0.0, 0.0));
			addLayer(new CameraLayer("main", 1.0, 1.0, 0.0, 0.0));
			
			var debugLayer:CameraLayer = new CameraLayer("debug", 1.0, 1.0, 0.0, 0.0);
			var debugInfo:Boolean = false;
			
			_debugNavGraph.visible = false;
			debugLayer.addChild(_debugNavGraph);
			
			_debugCollisionGrid.visible = debugInfo;
			//debugLayer.addChild(_debugCollisionGrid);
			
			addLayer(debugLayer);
			
			_sky = new Sprite();
			_sky.mouseChildren = false;
			_sky.mouseEnabled = false;
			getLayer("back").addChild(_sky);
			
			redrawTestSky();
		}
		
		public function redrawTestSky():void
		{
			var mat:Matrix = new Matrix();
			var g:Graphics = _sky.graphics;
			mat.createGradientBox(640, 400, 1.57, 0, 0);
			g.clear();
			g.beginGradientFill(GradientType.LINEAR, [0x3FB5F2, 0xDDF2FF], [1.0, 1.0], [0x00, 0xFF], mat);
			g.drawRect(0.0, 0.0, _level.camera.sizeX, _level.camera.sizeY);
			g.endFill();
		}
			
		

		public function load(xml:XML):void
		{
			var node:XML;
			var iter:XML;
			var actor:Actor;
			
			if(xml.hasOwnProperty("@name")) _name = xml.@name;
			_worldBounds = ParserUtil.parseRectangle(xml.@world);
			if(xml.hasOwnProperty("@camera"))
				_cameraBounds = ParserUtil.parseRectangle(xml.@camera);
			else
				_cameraBounds = _worldBounds.clone();
			
			_grid = new Grid(_worldBounds.x, _worldBounds.y, _worldBounds.width, _worldBounds.height);	
			
			node = xml.objects[0];
			if(node)
			{
				for each (iter in node.object)
				{
					actor = ActorFactory.load(iter, _level);
					if(actor)
					{
						addActor(actor);
					}
				}
			}
		}

		public function onStart():void
		{
			var actor:Actor;
			var layer:CameraLayer;
			
			for each (layer in _layers)
				_level.viewport.addChild(layer);
			
			for each (actor in _actors)
				actor.onStart();
		}
		
		public function onExit():void
		{
			var layer:CameraLayer;
			
			for each (layer in _layers)
				_level.viewport.removeChild(layer);
		}
		
		public function addActor(actor:Actor):void
		{
			_actors.push(actor);
				
			getActorsByType(actor.type).push(actor);
			
			actor.scene = this;
			
			if(_level.scene == this)
				actor.onStart();
		}
		
		public function removeActor(actor:Actor):void 
		{
			var holder:Vector.<Actor> = _actorsByType[actor.type];
			
			holder.splice(holder.indexOf(actor), 1);
			_actors.splice(_actors.indexOf(actor), 1);
			
			actor.scene = null;
		}
		
		public function get worldBounds():Rectangle
		{
			return _worldBounds;
		}
		
		public function get name():String
		{
			return _name;
		}

		public function get level():Level
		{
			return _level;
		}
		
		public function get actors():Vector.<Actor>
		{
			return _actors;
		}
		
		public function get layers():Vector.<CameraLayer>
		{
			return _layers;
		}
		
		public function getLayer(name:String):CameraLayer
		{
			if(name && _layersLookup.hasOwnProperty(name))
				return _layersLookup[name];
			return null;
		}
		
		public function addLayer(layer:CameraLayer, index:int = -1):void
		{
			_layers.push(layer);
			_layersLookup[layer.name] = layer;
			
			if(_level.scene == this && layer.parent != _level.viewport)
			{
				_level.viewport.addChild(layer);
			}
		}
		
		public function removeLayer(name:String):void
		{
			var layer:CameraLayer = _layersLookup[name];
			
			if(layer.parent == _level.viewport)
			{
				_level.viewport.removeChild(layer);
			}
			
			_layers.splice(_layers.indexOf(layer), 1);
			delete _layersLookup[name];
		}
		
		public function get navGraph():NavGraph
		{
			return _navGraph;
		}
		
		public function createNavGraph():NavGraph
		{
			if(!_navGraph)
				_navGraph = NavGraph.getNavGraph(this);
				
			return _navGraph;
		}
		
		public function getActorsByType(type:String):Vector.<Actor>
		{
			if(!_actorsByType.hasOwnProperty(type))
			{
				_actorsByType[type] = new Vector.<Actor>();
			}
			
			return _actorsByType[type];
		}
		
		public function removeActorsByType(type:String):void
		{
			var actors:Vector.<Actor> = getActorsByType(type);
			
			while(actors.length > 0)
			{
				_level.scene.removeActor(actors[0]);
			}
		}
		
		
		
		public function set worldBounds(bounds:Rectangle):void
		{
			if(bounds)
				_worldBounds = bounds;
		}

		public function get cameraBounds():Rectangle
		{
			return _cameraBounds;
		}

		public function set cameraBounds(cameraBounds:Rectangle):void
		{
			_cameraBounds = cameraBounds;
		}

		public function get grid():Grid
		{
			return _grid;
		}

		public function drawDebugInfo():void
		{
			var g:Graphics;
			
			if(_navGraph && _debugNavGraph.visible)
			{
				g = _debugNavGraph.graphics;
				g.clear();
				_navGraph.draw(g);
				
				for each (var player:Player in getActorsByType("player"))
				{
					if(player.ai)
						_navGraph.drawPath(g, player.ai.movePath, player.id);
				}
			}
			
			if(_grid && _debugCollisionGrid.visible)
			{
				g = _debugCollisionGrid.graphics;
				g.clear();
				_grid.draw(g);
			}
		}

	}
}
