package com.mindegg.data
{
	import flash.utils.ByteArray; 
	
	public class Card
	{
		private var _sides:Array;
		
		// Constructor to create empty card with a given number of sides
		public function Card(numberSides:int = 0)
		{
			_sides = new Array();
			for (var sidesCreated:int = 0; sidesCreated < numberSides; sidesCreated++)
			{
				this.newSide();
			}
		}
		
		// Constructor to create a new card from an XML representation
		public function loadWithXML(cardXML:XML):Card
		{
			// instantiate the Sides
			_sides = new Array();
			
			// for each Side, load the components
			var xmlSides:XMLList = cardXML.Side;
			for each (var xmlSide:XML in xmlSides)
			{
				var side:Side = new Side();
				this.addSide(side.loadWithXML(xmlSide));
			}
			return this;
		}

		
		/*
		public function Card(numberSides:int)
		{
			_sides = new Array();
			for (var sidesCreated:int = 0; sidesCreated < numberSides; sidesCreated++)
			{
				this.newSide();
			}
		}
		*/

		public function clone():Card
		{
			var clonedCard:Card = new Card(_sides.length);
			for (var i:uint = 0; i <_sides.length; i++)
			{
				clonedCard._sides[i] = this._sides[i].clone();
			}
			return clonedCard;
		}
		
		public function toXMLString():String
		{
			var xmlString:String = "<Card>";
			
				for (var i:uint = 0; i < _sides.length; i++)
				{
					xmlString = xmlString + _sides[i].toXMLString();
				}			

			xmlString = xmlString + "</Card>";
			return xmlString;
		}

 		public function newSide():Side
		// Creates a new side at the end of the current card
		// Returns the side created
		{
			var side:Side = new Side();
			_sides.push(side);
			return side;
		}
		
		public function addSide(side:Side):void
		{
			_sides.push(side);
		}
		
		public function numSides():uint
		{
			return _sides.length;
		}
		
		public function getSideAtIndex(index:uint):Side
		{
			return _sides[index];
		}
		
		/*
		public function getSideNumber(side:Side):uint
		{
			// concerned that this does a value match rather than an object match; it needs to be the latter
			return _sides.indexOf(side) + 1;
		}
		*/
		
		/**
		 *		Parameters:	id = the templateComponentID from which to identify a component within this card
		 * 		Returns:	the component requested
		 * 					null if the component doesn't exist on the card
		 */
		public function getComponentWithTemplateComponentID(id:uint):Component
		{
			var sidesReturnedComponent:Component;
			var result:Component = null;
			
			for each (var side:Side in _sides)
			{
				sidesReturnedComponent = side.getComponentWithTemplateComponentID(id);
				if (sidesReturnedComponent != null)
				{
					result = sidesReturnedComponent;
				}
			}
			
			return result;
		}
		
		/**
		 *		Parameters:	N / A
		 * 		Returns:	a 2-dimensional array of [templateComponentID, AttributeConstants.CONSTANT],
		 * 						representing the attributes on this side that are 'variable'
		 * 		Note: 		only called on template to find the exhaustive set of variable components, but possible to call it on any card to find an array of the variable components which exist on that card
		 */
		public function getVariableAttributes():Array
		{
			var fullResult:Array = new Array();
			var sideResult:Array;
			
			for each (var side:Side in _sides)
			{
				sideResult = side.getVariableAttributes();
				//concatenate results from each side
				fullResult = fullResult.concat(sideResult);	
			}	
			return fullResult;
		}

	}
}