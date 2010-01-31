package com.mindegg.view
{
	import com.mindegg.data.Component;
	import com.mindegg.data.Side;
	import com.mindegg.data.TextBox;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextFormatAlign;
	import flash.utils.*;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class UISide extends Canvas
	{			
		private var _side:Side; // the Side that this UISide represents on screen
		private var _sizeMultiplier:Number; // the size of the on screen representation as a factor of 260 wide, 160 high
		
		/**********************
  	    *   Constructor
  	    ***********************/
		/**
  	    * 	Purpose:	Creates a UI version of the supplied side. Also draws all components on side, with event listeners.
  	    */
		public function UISide(side:Side, widthInPixels:int = 260)
		{
			// call super
			super();
			
			// calculate size multiplier
			_sizeMultiplier = widthInPixels  / 260.0;

			// retain Side that this UISide will represent
			_side = side;
			
			// set standard properties	
			this.width = 260 * _sizeMultiplier;
			this.height = 160 * _sizeMultiplier;
			this.setStyle("backgroundColor", 0xFFFFFF);
			
			// draw components
			drawComponents();
			
			this.clipContent = true;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
		}
		
		/**
  	    * 	Purpose:	Redraws all components on the side. Does not add any new components to the side; this must be done separately.
  	    */
		public function redrawExistingComponents():void
		{
			var componentToUpdate:UIUserComponent;
			
			for (var i:uint = 0; i < this.numChildren; i ++)
			{
				componentToUpdate = this.getChildAt(i) as UIUserComponent;
				componentToUpdate.redraw();
			}
		}

		/**
  	    * 	Purpose:	Deletes all components on the side and redraws new UIUserComponents based on the contents of the existing object model
  	    */		
		private function redraw():void
		{
			this.removeAllChildren();
			drawComponents();
		}
				
		/**********************
  	    *   External Functions
  	    ***********************/

  	    /**
  	    *	Purpose:	Given a uiUserComponent (which must be drawn on the side), returns the Component data object corresponding to it
  	    */		
		public function getComponentRepresentedBy(uiUserComponent:UIUserComponent):Component
		{
			var componentIndex:int = getChildIndex(uiUserComponent);
			var component:Component = _side.getComponentAtIndex(componentIndex);
			return component;
		}
		
		/**
  	    *	Purpose:	Adds a textbox at the cursor's location
  	    * 	Takes:		Boolean true if this UISide is part of a template; false if it is part of a real card
  	    */		
		public function addTextBoxAtCursorLocation(isSideInTemplate:Boolean):UITextBox
		{
			var width:uint = 100;
			var height:uint = 50;
			var fontSize:uint = 18;
			var alignment:String = TextFormatAlign.CENTER;
			
			// check that the default width and height don't put the textbox off the edge of the side; if they do then adjust them
			if ((mouseX + width) > this.width)
			{
				width = this.width - mouseX;
			}
			if ((mouseY + height) > this.height)
			{
				height = this.height - mouseY;
			}
			
			// add the text box to the object model
			var textBox:TextBox = new TextBox(mouseX, mouseY, width, height, fontSize, alignment, isSideInTemplate);
			_side.addComponent(textBox);
					
			// add it to the UISide
			var uiTextBox:UITextBox = drawComponentOnSide(textBox) as UITextBox;
			return uiTextBox;
		}
		
		public function addCopiedComponent(pastedComponent:Component):UIUserComponent
		{
			// add the pasted component to the object model
			_side.addComponent(pastedComponent);
					
			// add it to the UISide
			var uiTextBox:UITextBox = drawComponentOnSide(pastedComponent as TextBox) as UITextBox;
			return uiTextBox;
		}
		
		public function deleteComponent(uiUserComponent:UIUserComponent):void
		{
			_side.deleteComponentWithIndex(this.getChildIndex(uiUserComponent));
			redraw();
		}
		
  	    /**
  	    * 	Purpose:	Returns a BitmapData representation of the side
  	    */		
		public function getBitmapDataRepresentation():BitmapData
		{
			return getUIComponentBitmapData(this);
		}
		
		
        /**********************
  	    *   Internal Functions
  	    ***********************/

		/**
  	    * 	Purpose:	Loops through each component on the corresponding Side and draws it
  	    */
		private function drawComponents():void
		{
			// loop through components on the side, adding them one at a time
			for (var componentIndex:int = 0; componentIndex < _side.numComponents(); componentIndex++)
			{
				// get the next component
				var component:Component = _side.getComponentAtIndex(componentIndex);
				drawComponentOnSide(component);
			}
		}

  	    /**
  	    * 	Purpose:	Creates a UI version of the supplied component, draws it on the UISide and adds an event listener for clicks
  	    */
		private function drawComponentOnSide(component:Component):UIUserComponent
		{
			var drawnComponent:UIUserComponent;
			
			// Get UIComponent representation of the component
			if(getQualifiedClassName(component) == "com.mindegg.data::TextBox")
			{
				drawnComponent = new UITextBox(component as TextBox, _sizeMultiplier);
			}
			else
			{
				throw new Error("SideCanvas does not know how to draw this type of component!");
			}
			
			this.addChild(drawnComponent);
			return drawnComponent;
		}
		
		/**
  	    * 	Purpose:	Returns the passed UIComponent encoded as a BitmapData
  	    */		
		private function getUIComponentBitmapData( target : UIComponent ) : BitmapData
		{ 
		    var bd : BitmapData = new BitmapData( target.width, target.height );
		    var m : Matrix = new Matrix();
		    bd.draw( target, m );
		    return bd;  
		}


		
	}
}