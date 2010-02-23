package com.mindegg.data
{
	import ascb.util.ArrayUtilities;
	
	import com.mindegg.utils.AttributeConstants;
	import com.mindegg.utils.XMLFormatter;
	
	import flash.text.TextFormatAlign;
	
	public class TextBox extends Component
	{
		// INSTANCE VARIABLES
		private var _text:Object = new Object();
		private var _font:Object = new Object();
		private var _fontSize:Object = new Object();
		private var _foregroundColor:Object = new Object();
		private var _backgroundColor:Object = new Object();
		private var _backgroundTransparent:Object = new Object();
		private var _alpha:Object = new Object(); // not used
		private var _alignment:Object = new Object();
				
		
		// CONSTRUCTOR
		
		public function TextBox(x:uint, y:uint, width:uint, height:uint, fontSize:Number, alignment:String, isTemplateComponent:Boolean)
		{
			super(x, y, width, height, isTemplateComponent);
			
			// set defaults
			this._foregroundColor.value = 0x000000;
			this._backgroundColor.value = 0xFFFFFF;
			this._backgroundTransparent.value = true;
			this._alpha.value = 1.0;
			this._text.value = "Text";
			this._font.value = "Arial";
			
			// pass remaining attributes from signature
			this._fontSize.value = fontSize;
			
			if ((alignment == TextFormatAlign.CENTER) || (alignment == TextFormatAlign.RIGHT) || (alignment == TextFormatAlign.LEFT))
			{
				this._alignment.value = alignment;
			}
			else
			{
				throw new Error("Alignment must be TextFormatAlign.CENTER, TextFormatAlign.RIGHT or TextFormatAlign.LEFT.");
			}
			
			// set variabilities to false by default
			_text.variable = false;
			_font.variable = false;
			_fontSize.variable = false;
			_foregroundColor.variable = false;
			_backgroundColor.variable = false;
			_backgroundTransparent.variable = false;
			_alpha.variable = false;
			_alignment.variable = false;
				// except for _text, which should be true iff this is a template side
				if (isTemplateComponent)
					{_text.variable = true;}
		}
		
		public override function clone():Component
		{
			// assume that this clone is from a template to a card - we duplicate its _templateComponentID 
			var clonedTextBox:TextBox = new TextBox(this.x, this.y, this.width, this.height, _fontSize.value, _alignment.value, false);
			clonedTextBox.text = _text.value;
			clonedTextBox.font = _font.value;
			clonedTextBox.foregroundColor = _foregroundColor.value;
			clonedTextBox.backgroundColor = _backgroundColor.value;
			clonedTextBox.backgroundTransparent = _backgroundTransparent.value;
			clonedTextBox.alpha = _alpha.value;
			clonedTextBox._templateComponentID = _templateComponentID;
			clonedTextBox._name = _name;
			
			// copy the variabilities
			for each (var attribute:uint in AttributeConstants.COMPONENT_ATTRIBUTES.concat(AttributeConstants.TEXTBOX_ATTRIBUTES))
			{
				if (isVariable(attribute))
				{
					clonedTextBox.setVariable(attribute);
				}
				else
				{
					clonedTextBox.setFixed(attribute);
				}
			}
						
			return clonedTextBox;
		}
		
		public override function toXMLString():String
		{
			// construct XML string with TextBox's values
			var xmlString:String = "<Component template_component_id=\"" + this.templateComponentID + "\" name=\"" + this.name + "\" x=\"" + this.x + "\" y=\"" + this.y + "\" width=\"" + this.width + "\" height=\"" + this.height + "\">";
				xmlString = xmlString + "<TextBox>"
					xmlString = xmlString + "<text variable=\"" + _text.variable + "\">" + XMLFormatter.makeStringXMLReady(_text.value) + "</text>";
					xmlString = xmlString + "<font variable=\"" + _font.variable + "\">" + _font.value + "</font>";
					xmlString = xmlString + "<fontSize variable=\"" + _fontSize.variable + "\">" + _fontSize.value + "</fontSize>";
					xmlString = xmlString + "<foregroundColor variable=\"" + _foregroundColor.variable + "\">" + _foregroundColor.value + "</foregroundColor>";
					xmlString = xmlString + "<backgroundColor variable=\"" + _backgroundColor.variable + "\">" + _backgroundColor.value + "</backgroundColor>";
					xmlString = xmlString + "<backgroundTransparent variable=\"" + _backgroundTransparent.variable + "\">" + _backgroundTransparent.value + "</backgroundTransparent>";
					xmlString = xmlString + "<alpha variable=\"" + _alpha.variable + "\">" + _alpha.value + "</alpha>";
					xmlString = xmlString + "<alignment variable=\"" + _alignment.variable + "\">" + _alignment.value + "</alignment>";
				xmlString = xmlString + "</TextBox>";
			xmlString = xmlString + "</Component>";
			return xmlString;
		}
		
		
		public override function setVariable(attribute:uint):void
		{
			if (ArrayUtilities.findMatchIndex(AttributeConstants.COMPONENT_ATTRIBUTES, attribute) >= 0) // if attribute is on the component superclass
				{super.setVariable(attribute);}
			else
			{
				switch(attribute)
				{
					case AttributeConstants.TEXT:
						_text.variable = true;
						break;
					case AttributeConstants.FONT:
						_font.variable = true;
						break;
					case AttributeConstants.FONT_SIZE:
						_fontSize.variable = true;
						break;
					case AttributeConstants.FOREGROUND_COLOR:
						_foregroundColor.variable = true;
						break;
					case AttributeConstants.BACKGROUND_COLOR:
						_backgroundColor.variable = true;
						break;
					case AttributeConstants.BACKGROUND_TRANSPARENT:
						_backgroundTransparent.variable = true;
						break;						
					case AttributeConstants.ALPHA:
						_alpha.variable = true;
						break;
					case AttributeConstants.ALIGNMENT:
						_alignment.variable = true;
				}
				raiseChangeEvent();
			}
		}
		
		public override function setFixed(attribute:uint):void
		{
			if (ArrayUtilities.findMatchIndex(AttributeConstants.COMPONENT_ATTRIBUTES, attribute) >= 0)
				{super.setFixed(attribute);}
			else
			{
				switch(attribute)
				{
					case AttributeConstants.TEXT:
						_text.variable = false;
						break;
					case AttributeConstants.FONT:
						_font.variable = false;
						break;
					case AttributeConstants.FONT_SIZE:
						_fontSize.variable = false;
						break;
					case AttributeConstants.FOREGROUND_COLOR:
						_foregroundColor.variable = false;
						break;
					case AttributeConstants.BACKGROUND_COLOR:
						_backgroundColor.variable = false;
						break;
					case AttributeConstants.BACKGROUND_TRANSPARENT:
						_backgroundTransparent.variable = false;
						break;						
					case AttributeConstants.ALPHA:
						_alpha.variable = false;
						break;
					case AttributeConstants.ALIGNMENT:
						_alignment.variable = false;
				}
				raiseChangeEvent();
			}
		}
		
		public override function isVariable(attribute:uint):Boolean
		{
			var result:Boolean;
			if (ArrayUtilities.findMatchIndex(AttributeConstants.COMPONENT_ATTRIBUTES, attribute) >= 0)
				{result = super.isVariable(attribute);}
			else
			{
				switch(attribute)
				{
					case AttributeConstants.TEXT:
						result = _text.variable;
						break;
					case AttributeConstants.FONT:
						result = _font.variable;
						break;
					case AttributeConstants.FONT_SIZE:
						result = _fontSize.variable;
						break;
					case AttributeConstants.FOREGROUND_COLOR:
						result = _foregroundColor.variable;
						break;
					case AttributeConstants.BACKGROUND_COLOR:
						result = _backgroundColor.variable;
						break;
					case AttributeConstants.BACKGROUND_TRANSPARENT:
						result = _backgroundTransparent.variable;
						break;						
					case AttributeConstants.ALPHA:
						result = _alpha.variable;
						break;
					case AttributeConstants.ALIGNMENT:
						result = _alignment.variable;				
				}
			}
			return result;
		}

		public override function getAttributeAsString(attribute:uint):String
		{
			var result:String;
			if (ArrayUtilities.findMatchIndex(AttributeConstants.COMPONENT_ATTRIBUTES, attribute) >= 0)
				{result = super.getAttributeAsString(attribute);}
			else
			{
				switch(attribute)
				{
					case AttributeConstants.TEXT:
						result = this.text;
						break;
					case AttributeConstants.FONT:
						result = this.font;
						break;
					case AttributeConstants.FONT_SIZE:
						result = this.fontSize.toString();
						break;
					case AttributeConstants.FOREGROUND_COLOR:
						result = this.foregroundColor.toString(16);
						break;
					case AttributeConstants.BACKGROUND_COLOR:
						result = this.backgroundColor.toString(16);
						break;
					case AttributeConstants.BACKGROUND_TRANSPARENT:
						result = this.backgroundTransparent.toString();
						break;						
					case AttributeConstants.ALPHA:
						result = this.alpha.toString();
						break;
					case AttributeConstants.ALIGNMENT:
						result = this.alignment.toString();				
				}
			}
			return result;
		}
		
		/**
		 * 	Purpose:	Sets a given attribute to the requested value
		 * 	Takes:		A AttributeConstants constant specifying the attribute; A value that it should be set to
		 * 	Returns:	Error string, or "" if no error.
		 * 
		 */
		public override function setAttributeFromString(attribute:uint, value:String):String
		{
			var errorString:String  = "";
			if (ArrayUtilities.findMatchIndex(AttributeConstants.COMPONENT_ATTRIBUTES, attribute) >= 0)
			{
				errorString = super.getAttributeAsString(attribute);
			}
			else
			{
				switch(attribute)
				{
					case AttributeConstants.TEXT:
						this.text = value;
					case AttributeConstants.FONT:
						// TO WRITE
						break;
					case AttributeConstants.FONT_SIZE:
						// TO WRITE
						break;
					case AttributeConstants.FOREGROUND_COLOR:
						// TO WRITE
						break;
					case AttributeConstants.BACKGROUND_COLOR:
						// TO WRITE
						break;
					case AttributeConstants.BACKGROUND_TRANSPARENT:
						// TO WRITE
						break;
					case AttributeConstants.ALPHA:
						// TO WRITE
						break;
					case AttributeConstants.ALIGNMENT:
						// TO WRITE
				}
				raiseChangeEvent();
			}
			return errorString;
		}

		public override function getVariableAttributes():Array
		{
			var textBoxResult:Array = new Array();
			
			// create an array of each variable attribute's identifier for the textbox
			for each (var attribute:uint in AttributeConstants.TEXTBOX_ATTRIBUTES)
			{
				if (isVariable(attribute))
				{
					textBoxResult.push(attribute);
				}
			}
			
			// append any variable attributes from component
			return super.getVariableAttributes().concat(textBoxResult);
		}

		
		
		// GETTERS & SETTERS
		
		public function set text(text:String):void
		{
			this._text.value = text;
			raiseChangeEvent();
		}
		
		public function set fontSize(fontSize:Number):void
		{
			this._fontSize.value = fontSize;
			raiseChangeEvent();
		}
		
		public function set backgroundColor(backgroundColor:uint):void
		{
			this._backgroundColor.value = backgroundColor;
			raiseChangeEvent();
		}

		public function set backgroundTransparent(backgroundTransparency:Boolean):void
		{
			this._backgroundTransparent.value = backgroundTransparency;
			raiseChangeEvent();
		}
		
		public function set foregroundColor(foregroundColor:uint):void
		{
			this._foregroundColor.value = foregroundColor;
			raiseChangeEvent();
		}
		
		public function set alpha(alpha:Number):void
		{
			if (0.0 <= alpha <= 1.0)
				{
					this._alpha.value = alpha;
					raiseChangeEvent();
				}
			else
				{throw Error("Alpha can not be set to a value outside the range 0-1.");}

		}
		
		public function set alignment(alignment:String):void
		{
			if ((alignment == TextFormatAlign.CENTER) || (alignment == TextFormatAlign.RIGHT) || (alignment == TextFormatAlign.LEFT))
			{
				this._alignment.value = alignment;
				raiseChangeEvent();
			}
			else
			{
				throw new Error("Alignment must be TextFormatAlign.CENTER, TextFormatAlign.RIGHT or TextFormatAlign.LEFT.");
			}	
		}
		
		public function set font(font:String):void
		{
			if (font == "Arial")
			{
				this._font.value = font;
				raiseChangeEvent();
			}
			else
				{throw Error("Font must be set to one of the following: \"Arial\".");}
		}
		
		public function get text():String
		{return _text.value;}
		
		public function get fontSize():Number
		{return _fontSize.value;}
		
		public function get backgroundColor():uint
		{return _backgroundColor.value;}

		public function get foregroundColor():uint
		{return _foregroundColor.value;}
		
		public function get backgroundTransparent():Boolean
		{return _backgroundTransparent.value;}

		public function get alpha():Number
		{return _alpha.value;}
		
		public function get alignment():String
		{return _alignment.value;}
		
		public function get font():String
		{return _font.value;}
		
	}
}