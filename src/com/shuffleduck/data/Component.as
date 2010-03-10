package com.shuffleduck.data
{
	import ascb.util.ArrayUtilities;
	import com.shuffleduck.utils.AttributeConstants;
	import com.shuffleduck.utils.CustomEvent;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	public class Component extends DataModelItem // abstract class
	{
		public static const COMPONENT_SELECTED:String = "com.mindegg.data.Component::COMPONENT_SELECTED";
		public static const COMPONENT_DESELECTED:String = "com.mindegg.data.Component::COMPONENT_DESELECTED";
		
		protected var _name:String = null;
		
		private var _x:Object = new Object();
		private var _y:Object = new Object();
		private var _width:Object = new Object();
		private var _height:Object = new Object();
		
		// templateComponentID is a unique integer, referencing each component in the template, as well as
		// the corresponding component (if it exists) on each card. Components on (non-template) cards that
		// do not also exist on the template have a templateComponentID of -1;	
		protected var _templateComponentID:int = -1;
		private static var _nextTemplateComponentID:int = 1;
		
		private var _selected:Boolean;
		private static var _selectedComponents:Array = new Array();
				
		public function Component(x:uint, y:uint, width:uint, height:uint, isTemplateComponent:Boolean)
		{
			// check that it is a subclass being instantiated & if not, throw error
			if(getQualifiedClassName(this) == "com.mindegg.data::Component")
			{
				throw new Error("Component is an abstract class&gt and can not be instantiated.");
			}

			// set attribute values
			this._x.value = x;
			this._y.value = y;
			this._width.value = width;
			this._height.value = height;
			
			// set attribute variabilities (variability reflects whether the attribute is shown in grid view)
			// default is that nothing is variable; variability must be set explicitly using the setVariable function
			this._x.variable = false;
			this._y.variable = false;
			this._width.variable = false;
			this._height.variable = false;
			
			if (isTemplateComponent) // is a component on the template
			{
				assignNewTemplateComponentID();
			}
			else
			{
				detachFromTemplate();
			}
			
		}
		
		public function clone():Component // abstract
		{
			throw new Error("clone() called on Component. clone() must be overriden by Component subclasses and can not be called on Component itself.");				
		}
		
		public function assignNewTemplateComponentID():void
		{
			// set the component's templateComponentID
			_templateComponentID = _nextTemplateComponentID;
			_nextTemplateComponentID ++;
			
			// set the component's default name
			_name = getQualifiedClassName(this).substring(18) + " " + _templateComponentID;
			
			raiseChangeEvent();
		}
		
		public function detachFromTemplate():void
		{
			// set templateComponent ID to -1 to indicate that this component is not found on the template
			_templateComponentID = -1;
			
			// remove name from the component
			_name = "Card Specific " + getQualifiedClassName(this).substring(18);
			
			raiseChangeEvent();
		}
		
		public function toXMLString():String // abstract
		{
			throw new Error("toXMLString() called on Component. toXMLString() must be overriden by Component subclasses and can not be called on Component itself.");				
			return "ERROR: toXMLString() called on Component";
		}
		
		public function setSelected():void
		{
			// update state of this component
			_selected = true;
			
			// record this component in the global list of selected components
			_selectedComponents.push(this);
			
			// announce the selection via an event
			var params:Object = new Object();
		    var event:CustomEvent = new CustomEvent(COMPONENT_SELECTED, params, false);
		    dispatchEvent(event);
		}
		
		public static function clearSelection():void
		{	
			for each (var selectedComponent:Component in _selectedComponents)
			{
				// update state of this component
				selectedComponent._selected = false;
				
				// announce the deselection via an event
				var params:Object = new Object();
		   		var event:CustomEvent = new CustomEvent(COMPONENT_DESELECTED, params, false);
		    	selectedComponent.dispatchEvent(event);
			}
			
			// clear the global list of selected components
			_selectedComponents = new Array();
		}
		
		public static function selectionExists():Boolean
		{
			if (_selectedComponents.length > 0)
				{return true;}
			else
				{return false;}
		}
		
		public function isSelected():Boolean
		{
			if (ArrayUtilities.findMatchIndex(_selectedComponents, this) == -1)
				{return false;}
			else
				{return true;}
		}
		
		public function setVariable(attribute:uint):void
		{
			switch(attribute)
			{
				case AttributeConstants.X:
					_x.variable = true;
					break;
				case AttributeConstants.Y:
					_y.variable = true;
					break;
				case AttributeConstants.WIDTH:
					_width.variable = true;
					break;
				case AttributeConstants.HEIGHT:
					_height.variable = true;
			}
			raiseChangeEvent();
		}
		
		public function setFixed(attribute:uint):void
		{
			switch(attribute)
			{
				case AttributeConstants.X:
					_x.variable = false;
					break;
				case AttributeConstants.Y:
					_y.variable = false;
					break;
				case AttributeConstants.WIDTH:
					_width.variable = false;
					break;
				case AttributeConstants.HEIGHT:
					_height.variable = false;
			}
			raiseChangeEvent();
		}
		
		public function isVariable(attribute:uint):Boolean
		{
			var result:Boolean;
			
			switch(attribute)
			{
				case AttributeConstants.X:
					result = _x.variable;
					break;
				case AttributeConstants.Y:
					result = _y.variable;
					break;
				case AttributeConstants.WIDTH:
					result = _width.variable;
					break;
				case AttributeConstants.HEIGHT:
					result = _height.variable;
			}
			
			return result;
		}
		
		public function getAttributeAsString(attribute:uint):String
		{
			var result:String;
			switch(attribute)
			{
				case AttributeConstants.X:
					result = this.x.toString();
					break;
				case AttributeConstants.Y:
					result = this.y.toString();
					break;
				case AttributeConstants.WIDTH:
					result = this.width.toString();
					break;
				case AttributeConstants.HEIGHT:
					result = this.height.toString();			
			}
			return result;
		}
		
		/**
		 * 	Purpose:	Sets a given attribute to the requested value
		 * 	Takes:		A AttributeConstants constant specifying the attribute; A value that it should be set to
		 * 	Returns:	Error string, or "" if no error.
		 * 
		 */
		public function setAttributeFromString(attribute:uint, value:String):String
		{
			var errorString:String  = "";
			switch(attribute)
			{
				case AttributeConstants.X:
					// TO WRITE
					break;
				case AttributeConstants.Y:
					// TO WRITE
					break;
				case AttributeConstants.WIDTH:
					// TO WRITE
					break;
				case AttributeConstants.HEIGHT:
					// TO WRITE
			}
			raiseChangeEvent();
			return errorString;
		}
		
		public function getVariableAttributes():Array
		{
			var result:Array = new Array();
			for each (var attribute:uint in AttributeConstants.COMPONENT_ATTRIBUTES)
			{
				if (isVariable(attribute))
				{
					result.push(attribute);
				}
			}
			return result;			
		}
		
		/**
		 * Returns the templateComponentID for this template.
		 * 
		 * 	templateComponentID is a unique integer, referencing each component in the template, as well as
		 * the corresponding component (if it exists) on each card. Components on (non-template) cards that
		 * do not also exist on the template have a tempalteComponentID of -1;	
		 */
		public function get templateComponentID():int
		{
			return _templateComponentID;
		}
		
		public function get x():uint
		{return _x.value;}
		
		public function get y():uint
		{return _y.value;}

		public function get height():uint
		{return _height.value;}

		public function get width():uint
		{return _width.value;}
		
		public function get name():String
		{return _name;}
		
		public function set x(value:uint):void
		{
			this._x.value = value;
			raiseChangeEvent();
		}

		public function set y(value:uint):void
		{
			this._y.value = value;
			raiseChangeEvent();
		}

		public function set width(value:uint):void
		{
			this._width.value = value;
			raiseChangeEvent();
		}

		public function set height(value:uint):void
		{
			this._height.value = value;
			raiseChangeEvent();
		}
		
		public function set name(name:String):void
		{
			this._name = name;
			raiseChangeEvent();
		}
		
		public function set templateComponentID(id:int):void
		{
			// set the templateComponentID
			this._templateComponentID = id;
			// make sure that future templateComponentIDs are set to a value higher than the one just set
			if (this._templateComponentID >= _nextTemplateComponentID)
			{
				_nextTemplateComponentID = this.templateComponentID + 1;
			}
			raiseChangeEvent();
		}


	}
}