package com.ek.duckstazy.game.actors
{
	import com.ek.duckstazy.game.Level;
	import com.ek.duckstazy.game.ModeManager;
	import com.ek.duckstazy.game.ModeType;
	import com.ek.duckstazy.game.base.Actor;
	import com.ek.duckstazy.game.base.ActorMask;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author eliasku
	 */
	public class Bun extends Actor
	{
		private var _startX:Number = 0.0;
		private var _startY:Number = 0.0;
		
		private var _sprite:Sprite = new Sprite();
		private var _carrier:Player;
		private var _house:House;
		
		private var _lastHouse:House;
		private var _lastCarrier:Player;
		
		public function Bun(level:Level)
		{
			super(level);
			
			_sprite.mouseEnabled = false;
			_sprite.mouseChildren = false;
			
			redraw();
			
			content.addChild(_sprite);
			
			width = 8;
			height = 8;
			
			gridMask = ActorMask.PICKABLE;
		}

		private function redraw():void
		{
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(2);
			_sprite.graphics.beginFill(0xff9900);
			_sprite.graphics.drawCircle(4, 4, 8);
			_sprite.graphics.endFill();
		
			var color:uint = 0xcccccc;
			
			if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
			{
				if(_lastCarrier)
				{
					color = Player.COLORS[_lastCarrier.id];
				}
			}
			else
			{
				if(_lastHouse)
				{
					color = Player.COLORS[_lastHouse.id];
				}
			}
		
			_sprite.graphics.lineStyle();
			_sprite.graphics.beginFill(color);
			_sprite.graphics.drawCircle(4, 4, 4);
			_sprite.graphics.endFill();
		}
		
		public override function onStart():void
		{
			super.onStart();
			
			_startX = x;
			_startY = y;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);
			
			if(_carrier)
			{
				//updateCarrier(dt);
			}
			else if(_house)
			{
				//updateHouse(dt);
			}
			else
			{
				updateNormal(dt);
			}
			
		}

		private function updateHouse(dt:Number):void
		{
		}

		private function updateCarrier(dt:Number):void
		{
		}

		private function updateNormal(dt:Number):void
		{
			var oldVelocity:Number = velocity;
			var fr:Number = Math.exp(-8.0*dt);
			
			vy += Player.GRAVITY*dt;
			
			if(move(dt, new Point()))
			{
				vx *= fr;
				vy *= fr;
			}
			
			if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
			{
				if(oldVelocity > 1000 && velocity <= 1000)
				{
					_lastCarrier = null;
					redraw();
				}
			}
		}
		
		protected override function onPrediction(dt:Number):void
		{
			if(_carrier || _house) return;
			
			var fr:Number = Math.exp(-8.0*dt);
			
			_predVY += Player.GRAVITY*dt;
			
			if(predictableMove(dt, true))
			{
				_predVX *= fr;
				_predVY *= fr;
			}
		}

		protected override function processActor(actor:Actor):void 
		{
			if(!_house && !_carrier)
			{
				var house:House = actor as House;
				var player:Player;
				
				if(house)
				{
					house.onPickUp(this);
				}
				
				if(actor is Spikes)
				{
					onRespawn();
				}
				
				if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING && _lastCarrier)
				{
					player = actor as Player;
					if(player && player != _lastCarrier)
					{
						player.onKick(_lastCarrier, Math.min(100, Math.max(1, velocity*0.0005)));
						_lastCarrier = null;
						redraw();
					}
				}
			}
		}
		
		public function get carrier():Player
		{
			return _carrier;
		}
		
		
		public function onCarrierMove():void
		{
			if(_carrier)
			{
				/*
				if(_carrier.lookDir > 0)
					x = _carrier.x + 24.0;
				else
					x = _carrier.x - 12.0;
					
				y = _carrier.y + 4.0;*/
				var p:Point = _carrier.getPickedItemPosition();
				x = p.x-4;
				y = p.y-4;
				
				updateTransform();
			}
		}
		
		public function onPickUp(carrier:Player):void
		{
			_carrier = carrier;
			_lastCarrier = carrier;
			redraw();
			onHouseExit();
			if(carrier.layer == layer)
			{
				layer.setChildIndex(content, layer.getChildIndex(carrier.content)-1);
			}
		}

		
		public function onDropOut(byPlayer:Boolean):void
		{
			var oldX:Number = x;
			var oldY:Number = y;
			
			if(_carrier)
			{
				x = _carrier.x;
				y = _carrier.y;
				
				vx = oldX - x;
				vy = oldY - y;
				
				move(1.0, new Point());
				
				if(byPlayer)
				{
					vx = _carrier.lookDir*200.0;
					vy = -100.0;
					if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
					{
						vx = _carrier.lookDir*400.0;
						vy = -100.0;
					}
				}
				else
				{
					vx = _carrier.vx;
					vy = _carrier.vy;
					_lastCarrier = null;
					redraw();
				}
			}
			
			_carrier = null;
			
			layer.setChildIndex(content, layer.numChildren-1);
		}

		public function onHouseEnter(house:House):void
		{
			_house = house;
			_lastHouse = house;
			redraw();
		}
		
		public function onHouseExit():void
		{
			if(_house)
			{
				_house.onDropOut(this);
				_house = null;
			}
		}
		
		public function onRespawn():void
		{
			vx = 0.0;
			vy = 0.0;
			
			if(_lastHouse)
			{
				x = _lastHouse.x;
				y = _lastHouse.y;
			}
			else
			{
				x = _startX;
				y = _startY;
			}
			
			updateTransform();
		}

		public function get house():House
		{
			return _house;
		}
		
		public function aiSuccessfulDropPrediction(carrier:Player, side:int):Boolean
		{
			var actors:Vector.<Actor>;
			var actor:Actor;
			
			var dt:Number = 0.1;
			var result:Boolean;
			var vx:Number = side*200.0;
			var vy:Number = -100.0;
			var px:Number = x;
			var py:Number = y;
			var fr:Number = Math.exp(-8.0*dt);
			var iters:int = 100;
			while(iters > 0)
			{
				px += vx*dt;
				
				if(testBox(px, py, width, height))
				{
					px -= vx*dt;
					vx = 0;
				}
				
				py += vy*dt;
				
				if(testBox(px, py, width, height))
				{
					py -= vy*dt;
					vy = 0;
					iters = 0;
				}
				
				actors = scene.grid.queryRect(px, py, width, height, ActorMask.ALL, this);
				for each (actor in actors)
				{
					if(actor is House)
					{
						if(actor == carrier.home)
						{
							result = true;
							iters = 0;
						}
					}
					else if(actor is Spikes)
					{
						result = (_lastHouse && _lastHouse == carrier.home);
						iters = 0;
					}
				}
				
				iters--;
				
				vy += Player.GRAVITY*dt;
				vx *= fr;
				vy *= fr;
			}
			
			return result;
		}

		public function isPickableFor(player:Player):Boolean
		{
			if(ModeManager.instance.settings.type == ModeType.VERSUS_FIGHTING)
			{
				return !carrier && !_lastCarrier;
			}
			
			return !carrier;
		}
	}
}