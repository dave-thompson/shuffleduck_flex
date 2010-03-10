package com.shuffleduck.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	
	public class DisplayListUtils
	{
		public function DisplayListUtils()
		{
		}
	
		// returns true iff the child is the potentialAncestor, or if the child is a descendant of the potentialAncestor
		public static function hasAncestor(child:DisplayObject, potentialAncestor:DisplayObjectContainer):Boolean
		{
			if (child.parent == potentialAncestor)
			{
				return true;
			}
			else if (child.parent == null)
			{
				return false;
			}
			else
			{
				return hasAncestor(child.parent, potentialAncestor);
			}
		}
		
		// returns the displayObject's closest ancestor (including itself) that is of type className
		public static function getFirstAncestorOfType(displayObject:DisplayObject, className:String):DisplayObject
		{
			var classType:Class = getDefinitionByName(className) as Class;
			if (displayObject is classType)
			{
				return displayObject;
			}
			else if (displayObject.parent == null)
			{
				return null;
			}
			else
			{
				return getFirstAncestorOfType(displayObject.parent, className);
			}
		}
		
		
	}
}