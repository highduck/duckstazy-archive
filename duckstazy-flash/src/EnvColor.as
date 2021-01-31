package
{
	public class EnvColor
	{
		public var bg:uint;
		public var text:uint;

		public function EnvColor(sky:uint, floatText:uint)
		{
			bg = sky;
			text = floatText;
		}
		
		public function lerp(x:Number, c1:EnvColor, c2:EnvColor):void
		{
			bg = utils.lerpColor(c1.bg, c2.bg, x);
			text = utils.lerpColor(c1.text, c2.text, x);
		}

	}
}