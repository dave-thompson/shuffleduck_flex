package com.shuffleduck.data
{
	import com.shuffleduck.utils.AttributeConstants;
	
	import flash.text.TextFormatAlign;

	public class Side extends DataModelItem
	{		
		private var _components:Array;
		private var _backgroundColor:uint;
		
		public function Side()
		{
			_backgroundColor = 0xFFFFFF;
			_components = new Array();
		}
		
		public function loadWithXML(xmlSide:XML):Side
		{
			// get side data
			_backgroundColor = xmlSide.attribute("backgroundColor");
			
			// delete any existing content
			_components = new Array();	
			
			// for each component, read the attributes and daughter nodes
			for each (var xmlComponent:XML in xmlSide.Component)
			{
				// the attributes
				var x:uint = xmlComponent.attribute("x");
				var y:uint = xmlComponent.attribute("y");
				var width:uint = xmlComponent.attribute("width");
				var height:uint = xmlComponent.attribute("height");
				var templateComponentID:int = int(xmlComponent.attribute("template_component_id"));
				var name:String = xmlComponent.attribute("name").toString();
				
				// there should only be one daughter node, but we don't know what it is
				if (xmlComponent.TextBox.length() > 0) // if a textbox exists, process it
				{
					// retrieve XML data
					var textBox:XML = xmlComponent.TextBox[0]
					
					var text:String = textBox.text.toString();
					var font:String = textBox.font.toString();
					var fontSize:Number = Number(textBox.fontSize);
					var alpha:Number = Number(textBox.alpha);
					var alignment:String = textBox.alignment.toString();
					var backgroundTransparent:Boolean = (textBox.backgroundTransparent.toLowerCase() == "true");
					var foregroundColor:uint = textBox.foregroundColor;
					var backgroundColor:uint = textBox.backgroundColor;
										
					var textVariable:Boolean = (textBox.text[0].attribute("variable").toLowerCase() == "true");
					var fontVariable:Boolean = (textBox.font[0].attribute("variable").toLowerCase() == "true");
					var fontSizeVariable:Boolean = (textBox.fontSize[0].attribute("variable").toLowerCase() == "true");
					var alphaVariable:Boolean = (textBox.alpha[0].attribute("variable").toLowerCase() == "true");
					var alignmentVariable:Boolean = (textBox.alignment[0].attribute("variable").toLowerCase() == "true");
					var fgVariable:Boolean = (textBox.foregroundColor[0].attribute("variable").toLowerCase() == "true");
					var bgVariable:Boolean = (textBox.backgroundColor[0].attribute("variable").toLowerCase() == "true");
					var bgTranspVariable:Boolean = (textBox.backgroundTransparent[0].attribute("variable").toLowerCase() == "true");
					
					// convert XML values into Actionscript data model values
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
					tb.backgroundTransparent = backgroundTransparent;
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
					if (bgTranspVariable) 	{tb.setVariable(AttributeConstants.BACKGROUND_TRANSPARENT);}
					else					{tb.setFixed(AttributeConstants.BACKGROUND_TRANSPARENT);}
					if (alphaVariable) 		{tb.setVariable(AttributeConstants.ALPHA);}
					else					{tb.setFixed(AttributeConstants.ALPHA);}
					if (alignmentVariable) 	{tb.setVariable(AttributeConstants.ALIGNMENT);}
					else					{tb.setFixed(AttributeConstants.ALIGNMENT);}
					
					// add the component to the side
					this.addComponent(tb);					
				}
				else if (xmlComponent.Image.length > 0)
				{
					// PROCESS IMAGE
				}
			}
			return this;
		}
		
		public function clone():Side
		{
			var clonedSide:Side = new Side();
			clonedSide._backgroundColor = this._backgroundColor;
			for (var i:uint = 0; i <_components.length; i++)
			{
				clonedSide.addComponent(this._components[i].clone());	
			}
			return clonedSide;

		}
		
		public function deleteComponentWithIndex(index:uint):void
		{
			_components.splice(index, 1);
			raiseChangeEvent();
		}
		
		public function toXMLString():String
		{
			var xmlString:String = "<Side backgroundColor=\"" + _backgroundColor + "\">";
			
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
			startPropogatingChangeEventsFrom(component);
			raiseChangeEvent();
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
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(color:uint):void
		{
			_backgroundColor = color;
			raiseChangeEvent();
		}
		 		
	}
}