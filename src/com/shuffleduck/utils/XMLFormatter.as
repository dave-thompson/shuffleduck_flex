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
			
			// replace special characters with the XML representation
			replaced = replaced.split("&").join("&amp;");
			replaced = replaced.split("\"").join("&quot;");
			replaced = replaced.split("<").join("&lt;");
			replaced = replaced.split(">").join("&gt;");			
			
			return replaced;
		}

	}
}