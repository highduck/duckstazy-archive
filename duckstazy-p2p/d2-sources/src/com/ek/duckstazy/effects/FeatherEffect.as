package com.ek.duckstazy.effects
{
	import com.ek.library.gocs.GameObject;

	import flash.geom.Matrix;
	

	public class FeatherEffect extends GameObject
	{
		private const _parts:Vector.<FeatherParticle> = new Vector.<FeatherParticle>();
		
		// разброс - scattering
		private const SCAT:Number = 0.5;
		
		private const FLY_MAX:Number = 40;
		private const FLY_MIN:Number = 10;
		private const VEL_MAX:Number = 500;
		private const VEL_MIN:Number = 200;
		private const ANGLE_AMP:Number = 0.5;
		private const ANGLE_SPEED:Number = 5;
		private const TIME_EXPLODE:Number = 0.3;
		private const SCALE_MIN:Number = 0.35;
		private const SCALE_MAX:Number = 0.7;
		private const LIFE_MIN:Number = 1.0;
		private const LIFE_MAX:Number = 2.0;
		private const GRAVITY:Number = -100;
		
		private const MATRIX:Matrix = new Matrix(); 
		
		//private const COLOR:ColorTransform = new ColorTransform(1.0, 1.0, 0.2);
		
		private var _explode:Number;
		
		public function FeatherEffect(x:Number, y:Number)
		{
			super();
			
			this.x = x;
			this.y = y;
		}
		
		public function hitHero(dx:Number, dy:Number):void
		{		
			var i:int = 10;
			var p:FeatherParticle;
			const a:Number = Math.atan2(dy, dx);
			var expl_a:Number;
			var fly_a:Number;
			var expl_v:Number;
			var fly_v:Number;
			
			MATRIX.identity();
			MATRIX.scale(0, 0);

			while(i>0)
			{
				p = new FeatherParticle();

				expl_a = a+(1-Math.random()*2)*SCAT;
				fly_a = Math.PI*0.5+(1-Math.random()*2)*0.2;
				expl_v = VEL_MIN+Math.random()*(VEL_MAX-VEL_MIN);
				fly_v = FLY_MIN+Math.random()*(FLY_MAX-FLY_MIN);

				p.vx = expl_v*Math.cos(expl_a);
				p.vy = expl_v*Math.sin(expl_a);
				p.fx = fly_v*Math.cos(fly_a);
				p.fy = fly_v*Math.sin(fly_a);

				p.life = LIFE_MIN+(LIFE_MAX-LIFE_MIN)*Math.random();
				p.scale = SCALE_MIN+(SCALE_MAX-SCALE_MIN)*Math.random();

				p.sprite.transform.matrix = MATRIX;
				
				addChild(p.sprite);
				_parts.push(p);

				--i;
			}
			
			_explode = 1.0;
		}
		
		
		public function splatHero(count:int = 32, color:uint = 0xffffff):void
		{		
			var i:int = count;
			var p:FeatherParticle;
			var expl_a:Number;
			var fly_a:Number;
			var expl_v:Number;
			var fly_v:Number;
			
			MATRIX.identity();
			MATRIX.scale(0, 0);

			while(i>0)
			{
				p = new FeatherParticle(color);

				expl_a = Math.random()*6.28;
				fly_a = Math.PI*0.5+(1-Math.random()*2)*0.2;
				expl_v = VEL_MIN+Math.random()*(VEL_MAX-VEL_MIN);
				fly_v = FLY_MIN+Math.random()*(FLY_MAX-FLY_MIN);

				p.vx = expl_v*Math.cos(expl_a);
				p.vy = expl_v*Math.sin(expl_a);
				p.fx = fly_v*Math.cos(fly_a);
				p.fy = fly_v*Math.sin(fly_a);

				p.life = LIFE_MIN+(LIFE_MAX-LIFE_MIN)*Math.random();
				p.scale = SCALE_MIN+(SCALE_MAX-SCALE_MIN)*Math.random();

				p.sprite.transform.matrix = MATRIX;
				
				addChild(p.sprite);
				_parts.push(p);
		
				--i;
			}
			
			_explode = 1.0;
		}
		
		public override function tick(dt:Number):void
		{
			var s:Number;
			var i:int;
			var p:FeatherParticle;
			
			if(_explode > 0.0)
			{
				_explode-=dt*(1.0/TIME_EXPLODE);
				if(_explode<0)
					_explode = 0;
			}
			
			
			while(i < _parts.length)
			{
				p = _parts[i];
				p.t += dt;
					
				if(p.t >= p.life)
				{
					removeChild(p.sprite);
					_parts.splice(i, 1);
					continue;
				}
				
				p.vy += GRAVITY*dt;
				p.x += (_explode*_explode*p.vx+p.fx)*dt;
				p.y += (_explode*_explode*p.vy+p.fy)*dt;					
				
				s = p.scale;
				
				MATRIX.identity();
				MATRIX.tx = -16;
				MATRIX.ty = 5;
				MATRIX.scale(s, s);
				MATRIX.rotate(ANGLE_AMP*Math.sin(ANGLE_SPEED*p.t+p.oa));
				MATRIX.translate(p.x, p.y);
				p.sprite.transform.matrix = MATRIX;
				
				if(p.t>TIME_EXPLODE)
				{
					//COLOR.alphaMultiplier = (p.life-p.t)/(p.life-TIME_EXPLODE);
					//p.sprite.transform.colorTransform = COLOR;
					p.sprite.alpha = (p.life-p.t)/(p.life-TIME_EXPLODE);
				}
				
				++i;		
			}
			
			if(parent && _parts.length == 0)
			{
				parent.removeChild(this);
			}
		}
	}
}