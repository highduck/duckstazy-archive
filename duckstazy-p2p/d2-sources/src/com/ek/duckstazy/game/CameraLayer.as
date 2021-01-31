package  
com.ek.duckstazy.game
{
	import com.ek.library.gocs.GameObject;

	/**
	 * @author eliasku
	 */
	public class CameraLayer extends GameObject 
	{
		private var _followX:Number;
		private var _followY:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function CameraLayer(name:String, followX:Number = 1.0, followY:Number = 1.0, offsetX:Number = 0.0, offsetY:Number = 0.0)
		{
			_followX = followX;
			_followY = followY;
			_offsetX = offsetX;
			_offsetY = offsetY;
			
			this.name = name;
			
			mouseChildren = false;
			mouseEnabled = false;
		}
	
		public function get followX():Number
		{
			return _followX;
		}
		
		public function set followX(value:Number):void
		{
			_followX = value;
		}
		
		public function get followY():Number
		{
			return _followY;
		}
		
		public function set followY(value:Number):void
		{
			_followY = value;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetX(offsetX:Number):void
		{
			_offsetX = offsetX;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set offsetY(offsetY:Number):void
		{
			_offsetY = offsetY;
		}

		public function update(camera:Camera):void 
		{
			if(camera)
			{
				//if(_followX != 1.0)
					x = camera.x * (1.0 - _followX) + _offsetX * _followX;
				//else
					//x = _offsetX;
					
				//if(_followY > 0.0)
					y = camera.y * (1.0 - _followY) + _offsetY * _followY;
				//else
					//y = _offsetY;
				//x = _offsetX + camera.x * _followX;
				//y = _offsetY + camera.y * _followY;
				//x = camera.x * _followX + _offsetX * (1.0 - _followX);
				//y = camera.y * _followY + _offsetY * (1.0 - _followY);
			}
		}
		
		
		/*public static function create(name:String, def:String, depth:Number, fx:Number, fy:Number, x:int, y:int, width:int, fillWidth:int):CameraLayer
		{
			var cl:CameraLayer = new CameraLayer(name);
			
			if(def)
			{
				var content:MovieClip;
				var offset:Number = 0.0;
				var fw:Number = fillWidth*fx;
				
				while(offset < fw)
				{
					content = AssetManager.getMovieClip(def);
					content.x = offset;
					cl.addChild(content);
					offset += width;
				}
			}

			cl.offsetY = x;
			cl.offsetY = y;
			cl.followX = fx;
			cl.followY = fy;
			
			return cl;
		}*/

	}
}
