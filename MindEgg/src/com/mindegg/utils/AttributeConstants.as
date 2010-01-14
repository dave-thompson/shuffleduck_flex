package com.mindegg.utils
{
	public class AttributeConstants
	{
		public static const X:uint = 0;
		public static const Y:uint = 1;
		public static const WIDTH:uint = 2;
		public static const HEIGHT:uint = 3;
		public static const TEXT:uint = 4;
		public static const FONT:uint = 5;
		public static const FONT_SIZE:uint = 6;
		public static const FOREGROUND_COLOR:uint = 7;
		public static const BACKGROUND_COLOR:uint = 8;
		public static const ALPHA:uint = 9;
		public static const ALIGNMENT:uint = 10;

		public static const COMPONENT_ATTRIBUTES:Array = [X, Y, WIDTH, HEIGHT];
		public static const TEXTBOX_ATTRIBUTES:Array = [TEXT, FONT, FONT_SIZE, FOREGROUND_COLOR, BACKGROUND_COLOR, ALPHA, ALIGNMENT];

		public function AttributeConstants()
		{		
		}
		
		public static function displayableString(attribute:uint):String
		{
			var result:String;
			
			switch(attribute)
			{
				case AttributeConstants.X:
					result = "x";
					break;
				case AttributeConstants.Y:
					result = "y";
					break;
				case AttributeConstants.WIDTH:
					result = "width";
					break;
				case AttributeConstants.HEIGHT:
					result = "height";
					break;
				case AttributeConstants.TEXT:
					result = "text";
					break;
				case AttributeConstants.FONT:
					result = "font";
					break;
				case AttributeConstants.FONT_SIZE:
					result = "font_size";
					break;
				case AttributeConstants.FOREGROUND_COLOR:
					result = "text_color";
					break;
				case AttributeConstants.BACKGROUND_COLOR:
					result = "background_color";
					break;
				case AttributeConstants.ALPHA:
					result = "alpha";
					break;
				case AttributeConstants.ALIGNMENT:
					result = "alignment";
			}
			return result;
		}

	}
}