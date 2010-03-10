package com.shuffleduck.utils
{
	/**
	 * 	Performs utility XML functions
	 * 
	 * 
	 * 
	 */
	
	import flash.utils.*;
	
	public class XMLFormatter // abstract - should never be instantiated; exists for utils only
	{
		public function XMLFormatter()
		{
			// don't allow instantiation of this class
			throw new Error("XMLFormatter is a utility class and can not be instantiated.");
		}

		public static function makeStringXMLReady(string:String):String
		{
			var replaced:String = string;
			// while there are still instances of double quotes in the string
			while (replaced.indexOf("\"") != -1)
			{
				// replace the first instance with the XML representation
				replaced = replaced.replace("\"", "&quot;");
			}
			return replaced;
		}

	}
}