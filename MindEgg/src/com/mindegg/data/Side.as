package com.mindegg.data
{
	import flash.events.EventDispatcher;
	
	public class Side extends EventDispatcher
	{		
		private var _components:Array;
				
		public function Side()
		{
			 _components = new Array();
		}
		
		public function clone():Side
		{
			var clonedSide:Side = new Side();
			for (var i:uint = 0; i <_components.length; i++)
			{
				clonedSide.addComponent(this._components[i].clone());	
			}
			return clonedSide;

		}
		
		public function deleteComponentWithIndex(index:uint):void
		{
			_components.splice(index, 1);
		}
		
		public function toXMLString():String
		{
			var xmlString:String = "<Side>";
			
				for (var i:uint = 0; i < _components.length; i++)
				{
					xmlString = xmlString + _components[i].toXMLString();
				}			

			xmlString = xmlString + "</Side>";
			return xmlString;
		}
		
		public function numComponents():int
		// returns the number of components on the side
		{
			return _components.length;
		}
		
		public function getComponentAtIndex(index:uint):Component
		// takes a 0-based index at returns the corresponding component
		{
			if (index < _components.length)
				{return _components[index];}
			else
				{throw Error("Component requested at index greater than number of components.");}
		}
		
		public function addComponent(component:Component):void
		{
			_components.push(component);
		}
		
		public function getComponentWithTemplateComponentID(id:uint):Component
		{
			var result:Component = null;
			
			for each (var component:Component in _components)
			{
				if (component.templateComponentID == id)
				{
					result = component;
				}
			}
			
			return result;
		}
		
		/*
		public function sideNumber():uint
		{
			var ownerCard:Card = this.parent as Card;
			return ownerCard.getSideNumber(this);
		}
		*/
		
		/**
		 *		Parameters:	N / A
		 * 		Returns:	a 2-dimensional array of [templateComponentID, AttributeConstants.CONSTANT],
		 * 						representing the attributes on this side that are 'variable'
		 */
		public function getVariableAttributes():Array
		{
			var fullResult:Array = new Array();
			var componentResult:Array;
			
			for each (var component:Component in _components)
			{
				if (component.templateComponentID >= 0) // if component has a template component ID (and therefore may contain variable attributes)
				{
					componentResult = component.getVariableAttributes();	// get all the variable attributes in the component (if any)
					for (var i:uint = 0; i < componentResult.length; i++)	// for each of those attributes
					// combine them with the appropriate global template component identifier and add them to the final variable attributes array
					{
						var arrayElement:Object = new Object();
						arrayElement.templateComponentID = component.templateComponentID;
						arrayElement.attributeConstant = componentResult[i];
						fullResult.push(arrayElement);
					}
				}
			}
			return fullResult;
		}
		 		
	}
}