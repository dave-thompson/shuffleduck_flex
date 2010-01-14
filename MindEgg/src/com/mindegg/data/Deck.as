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
		 *  Creates a new deck with the default settings
		 */
		public function Deck()
		{
			// create template as a new card with 2 sides
			_template = new Card(2);
			// create deck as an empty array, ready for cards to be pushed onto
			_cards = new Array();
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

		// load the given xmlString		
		public function loadDeck(xmlString:String):void
		{
				// create XML object from supplied string
				var deck:XML = new XML(xmlString);
				
				// read XML version number - will be required in future to determine correct parser for reading (variable currently unused)
				var version_no:String = deck.attribute("version_no");
				
				// Process Template
					// get an array of all the XML sides in the template
					var templateCard:XML = deck.Template[0].Card[0];
					// create the template card
					_template = newCardFromXML(templateCard);					
					
				// Process Cards
					var cards:XML = deck.Cards[0];
					for each (var card:XML in cards.Card)
					{
						_cards.push(newCardFromXML(card));
					}				
		}
		
		private function newCardFromXML(cardXML:XML):Card
		{
			// instantiate the card to be returned with the appropriate number of sides					
			var sides:XMLList = cardXML.Side;
			var card:Card = new Card(sides.length());
			
			var currentSideIndex:uint = 0;
			// for each side, load the components
			for each (var side:XML in sides)
			{
				// for each component, read the attributes and daughter nodes
				for each (var component:XML in side.Component)
				{
					// the attributes
					var x:uint = component.attribute("x");
					var y:uint = component.attribute("y");
					var width:uint = component.attribute("width");
					var height:uint = component.attribute("height");
					var templateComponentID:int = int(component.attribute("template_component_id"));
					var name:String = component.attribute("name").toString();
					
					// there should only be one daughter node, but we don't know what it is
					if (component.TextBox.length() > 0) // if a textbox exists, process it
					{
						// retrieve XML data
						var textBox:XML = component.TextBox[0]
						
						var text:String = textBox.text.toString();
						var font:String = textBox.font.toString();
						var fontSize:Number = Number(textBox.fontSize);
						var alpha:Number = Number(textBox.alpha);
						var alignment:String = textBox.alignment.toString();
						
						var fgRed:Number = Number(textBox.foregroundColor[0].attribute("red"));
						var fgGreen:Number = Number(textBox.foregroundColor[0].attribute("green"));
						var fgBlue:Number = Number(textBox.foregroundColor[0].attribute("blue"));
						
						var bgRed:Number = Number(textBox.backgroundColor[0].attribute("red"));
						var bgGreen:Number = Number(textBox.backgroundColor[0].attribute("green"));
						var bgBlue:Number = Number(textBox.backgroundColor[0].attribute("blue"));
						
						var textVariable:Boolean = (textBox.text[0].attribute("variable").toLowerCase() == "true");
						var fontVariable:Boolean = (textBox.font[0].attribute("variable").toLowerCase() == "true");
						var fontSizeVariable:Boolean = (textBox.fontSize[0].attribute("variable").toLowerCase() == "true");
						var alphaVariable:Boolean = (textBox.alpha[0].attribute("variable").toLowerCase() == "true");
						var alignmentVariable:Boolean = (textBox.alignment[0].attribute("variable").toLowerCase() == "true");
						var fgVariable:Boolean = (textBox.foregroundColor[0].attribute("variable").toLowerCase() == "true");
						var bgVariable:Boolean = (textBox.backgroundColor[0].attribute("variable").toLowerCase() == "true");
						
						// convert XML values into Actionscript data model values
						var backgroundColor:uint = (((bgRed * 255)*256*256) + ((bgGreen * 255)*256) + (bgBlue*255));
						var foregroundColor:uint = (((fgRed * 255)*256*256) + ((fgGreen * 255)*256) + (fgBlue*255));
						var alignmentConstant:String;
						switch (alignment)
						{
							case "left":
								alignmentConstant = TextFormatAlign.LEFT;
								break;
							case "center":
								alignmentConstant = TextFormatAlign.CENTER;
								break;
							case "right":
								alignmentConstant = TextFormatAlign.RIGHT;
								break;
						}
						
						// create new TextBox data object and set its values
						var tb:TextBox = new TextBox(x, y, width, height, fontSize, alignmentConstant, false) // setting templateComponentID to false has no effect on the textbox's templateComponentID as we set the name and templateComponentID ourselves below (effect is to not increment the template component counter)
						tb.alpha = alpha;
						tb.text = text;
						tb.font = font;
						tb.foregroundColor = foregroundColor;
						tb.backgroundColor = backgroundColor;
						tb.name = name;
						tb.templateComponentID = templateComponentID;
												
						if (textVariable) 		{tb.setVariable(AttributeConstants.TEXT);}
						else					{tb.setFixed(AttributeConstants.TEXT);}
						if (fontVariable) 		{tb.setVariable(AttributeConstants.FONT);}
						else					{tb.setFixed(AttributeConstants.FONT);}
						if (fontSizeVariable) 	{tb.setVariable(AttributeConstants.FONT_SIZE);}
						else					{tb.setFixed(AttributeConstants.FONT_SIZE);}
						if (fgVariable) 		{tb.setVariable(AttributeConstants.FOREGROUND_COLOR);}
						else					{tb.setFixed(AttributeConstants.FOREGROUND_COLOR);}
						if (bgVariable) 		{tb.setVariable(AttributeConstants.BACKGROUND_COLOR);}
						else					{tb.setFixed(AttributeConstants.BACKGROUND_COLOR);}
						if (alphaVariable) 		{tb.setVariable(AttributeConstants.ALPHA);}
						else					{tb.setFixed(AttributeConstants.ALPHA);}
						if (alignmentVariable) 	{tb.setVariable(AttributeConstants.ALIGNMENT);}
						else					{tb.setFixed(AttributeConstants.ALIGNMENT);}
						
						// add the TextBox to the current side
						card.getSideAtIndex(currentSideIndex).addComponent(tb);						
					}
					
					else if (component.Image.length > 0)
					{
						// PROCESS IMAGE
					}
					
				}
				currentSideIndex++;
			}
			return card;
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