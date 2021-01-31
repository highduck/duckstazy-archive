package com.ek.duckstazy.game
{


	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * @author eliasku
	 */
	public class Camera
	{
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		private var _scale:Number = 1.0;
		
		private var _sizeX:Number = 1.0;
		private var _sizeY:Number = 1.0;

		public function Camera(sizeX:Number, sizeY:Number) 
		{
			_sizeX = sizeX;
			_sizeY = sizeY;
		}

		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}
		
		public function applyTransform(viewport:Sprite):void
		{
			var hw:Number = _sizeX*0.5;
			var hh:Number = _sizeY*0.5;
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -_x-hw, -_y-hh);
			
			//mat.translate(-_x-hw, -_y-hh);
			mat.scale(_scale, _scale);
			mat.translate(hw, hh);

			viewport.transform.matrix = mat;
		}

		public function get sizeX():Number
		{
			return _sizeX;
		}

		public function get sizeY():Number
		{
			return _sizeY;
		}
		
		public function setSize(width:int, height:int):void
		{
			_sizeX = width;
			_sizeY = height;
		}
		
		public function get centerX():Number
		{
			return _x + _sizeX*0.5;
		}
		
		public function get centerY():Number
		{
			return _y + _sizeY*0.5;
		}

	}
}
