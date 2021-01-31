package com.ek.duckstazy.edit
{
	/**
	 * @author eliasku
	 */
	public class EditableType
	{
		public static const INPUT:String = "input";
		public static const SLIDER:String = "slider";
		public static const ENUM:String = "enum";
		public static const COLOR:String = "color";
		public static const STEPPER:String = "stepper";
		public static const CHECKBOX:String = "checkbox";
		public static const WATCH:String = "watch";
		
		public static function isValid(type:String):Boolean
		{
			if(type)
			{
				switch(type)
				{
					case INPUT:
					case SLIDER:
					case ENUM:
					case COLOR:
					case STEPPER:
					case CHECKBOX:
					case WATCH:
						return true;
				}
			}
			
			return false;
		}
		
	}
}
