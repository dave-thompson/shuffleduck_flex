package com.mindegg.data
{
	import com.mindegg.utils.AttributeConstants;
	import com.mindegg.utils.XMLFormatter;
	import flash.text.TextFormatAlign;
	
	public class Deck
	{
		
		private var _template:Card;
  		private var _cards:Array;
  		private var _deckName:String = "";

		/** CONSTRUCTOR
		 * 
		 *  Creates a new deck based on the given XML String
		 */		
		public function Deck(xmlString:String)
		{
			// create XML object from supplied string
			XML.ignoreWhitespace = false;
			var deck:XML = new XML(xmlString);
			deck.ignoreWhitespace = false; // need to keep spaces at start and end of textboxes
			
			// read XML version number - will be required in future to determine correct parser for reading (variable currently unused)
			var version_no:String = deck.attribute("version_no");
			
			// Process Template
			var templateCardXML:XML = deck.Template[0].Card[0];
			_template = new Card();
			_template.loadWithXML(templateCardXML);
				
			// Process Cards
			var cardsXML:XML = deck.Cards[0];
			_cards = new Array();
			for each (var cardXML:XML in cardsXML.Card)
			{
				var card:Card = new Card();
				_cards.push(card.loadWithXML(cardXML));
			}				
		}

		public function numCards():uint
		{
			return _cards.length;
		}
		
		public function getCardAtIndex(index:uint):Card
		{
			return _cards[index];
		}

		/**
		 * Purpose:	updates the name of the given component across the entire deck and template
		 * 
		 */
   		public function setTemplateComponentName(component:Component, newName:String):void
   		{
   			var id:uint = component.templateComponentID;
   			
   			// set the name on the template
   			_template.getComponentWithTemplateComponentID(id).name = newName;
   			
   			// set the name on each of the cards
   			var components:Array = getComponentsWithTemplateComponentID(id);
   			for (var i:uint = 0; i < components.length; i++)
   			{
   				components[i].name = newName;
   			}
   		}

		/**
		 * Purpose:	Returns an array containing all components (0-1 for each card) that have the given template component ID
		 * 			Does not return the corresponding component on the template itself. For that, call getComponentWithTemplateComponentID on the template Card itself
		 * 
		 */
		public function getComponentsWithTemplateComponentID(id:uint):Array
		{
			// loop through cards in the deck, retrieving the requested component if it exists and pushing it to the result array
			var result:Array = new Array();
			for (var i:uint = 0; i<_cards.length; i++)
			{
				var component:Component = _cards[i].getComponentWithTemplateComponentID(id);
				if (component != null)
				{
					result.push(component);
				}
			}
			return result;
		}

		/**
		 *  LOGIC METHODS
		 */

		public function newCard():void
		{
			// create a new card based on the template
			var card:Card = _template.clone();	
			// add that card to the deck
			_cards.push(card);
		}
		
		public function deleteCard(index:uint):void
		{
			_cards.splice(index,1);
		}
		
		public function insertCardAtIndex(card:Card, index:uint):void
		{
			_cards.splice(index, 0, card);
		}
		
		public function changeCardPosition(oldCardNumber:uint, newCardNumber:uint):void
		{
			// find old and new 0-based indexes; if indexes are less than zero or greater than the number of cards, constrain them to zero or the number of cards respectively
			var oldCardIndex:uint = Math.max(oldCardNumber - 1, 0);
			oldCardIndex = Math.min(oldCardIndex, numCards());
			var newCardIndex:uint = Math.max(newCardNumber - 1, 0);
			newCardIndex = Math.min(newCardIndex, numCards());

			var cardToMove:Card = getCardAtIndex(oldCardIndex);
			deleteCard(oldCardIndex);
			insertCardAtIndex(cardToMove, newCardIndex);
		}

		public function toXMLString():String
		{
			// create XML string of template			
			var xmlString:String = "<Deck version_no = \"" + MindEgg.XML_VERSION_NO + "\" backward_compatible_iphone_version_no = \"" + MindEgg.XML_BACKWARD_COMPATIBLE_IPHONE_VERSION_NO + "\">";

			xmlString = xmlString + "<Template>";
			xmlString = xmlString + _template.toXMLString();
			xmlString = xmlString + "</Template>";

			// create XML string of deck
			xmlString = xmlString + "<Cards>";
			for (var i:uint = 0; i < _cards.length; i++)
			{
				xmlString = xmlString + _cards[i].toXMLString();
			}			
			xmlString = xmlString + "</Cards>";
						
			xmlString = xmlString + "</Deck>";
			
			return xmlString;
		}

		/**
		 * GETTERS & SETTERS
		 * 
		 */

		public function get template():Card
		{
			return _template;
		}
		
		public function set deckName(name:String):void
		{
			_deckName = name;
		}
		
		public function get deckName():String
		{return _deckName;}
		

	}
}