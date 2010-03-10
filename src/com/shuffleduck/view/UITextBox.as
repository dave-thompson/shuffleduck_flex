package com.shuffleduck.view
{
		
    import com.shuffleduck.data.Component;
    import com.shuffleduck.data.TextBox;
    
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    
    
    public class UITextBox extends UIUserComponent
    {
    	private var _textBox:TextBox; // reference to the textbox that this UITextBox represents on screen
    	
    	// internal representation variables
		private var _innerTextField:TextField;
		private var _outerTextField:TextField;
    	
    	private var _sizeMultiplier:Number;
    	
    	/**********************
  	    *   Constructor
  	    ***********************/
		
		/**
  	    * 	Purpose:	Draw a UI representation of the supplied textbox
  	    */
        public function UITextBox(textBox:TextBox, sizeMultiplier:Number)
        {
        	// retain reference to object model
        	_textBox = textBox;
        	_sizeMultiplier = sizeMultiplier;
        	
        	// add event listeners so we know when the component is selected and deselected
        	_textBox.addEventListener(Component.COMPONENT_SELECTED, handleComponentSelection);
        	_textBox.addEventListener(Component.COMPONENT_DESELECTED, handleComponentDeselection);
        	
        	// instantiate sub-components
        	_innerTextField = new TextField();
        	_innerTextField.name = "innerTextField";
	        _outerTextField = new TextField();
        	
        	 // _innerTextField and _outerTextField should not receive mouse events
            _innerTextField.mouseEnabled = false;
            _outerTextField.mouseEnabled = false;
        	
        	// call super so that it also has reference
        	super(textBox);

			// draw the sub-components
			this.redraw();
        }
        
        public override function redraw():void
        {
        	// remove all currently drawn sub-components
        	while (this.numChildren > 0)
        	{
        		this.removeChildAt(0);
        	}

			// Create an outerTextField to represent the TextBox's background
	            if (_textBox.backgroundTransparent)
		            _outerTextField.background = false;
	            else
		            _outerTextField.background = true;
			
	            _outerTextField.alpha = _textBox.alpha;	            
	            _outerTextField.backgroundColor = _textBox.backgroundColor;
	            _outerTextField.x = 0;
	            _outerTextField.y = 0;
	            _outerTextField.width = _textBox.width * _sizeMultiplier;
	            _outerTextField.height = _textBox.height * _sizeMultiplier;
			this.addChild(_outerTextField);

            // create an innerTextField to hold the text
	            _innerTextField.x = 0;
	            _innerTextField.width = _textBox.width * _sizeMultiplier;
	            _innerTextField.text = _textBox.text;
	            _innerTextField.alpha = _textBox.alpha;
	            // format the text
		        var textFormat:TextFormat = new TextFormat();
	            textFormat.color = _textBox.foregroundColor;
	            textFormat.size = _textBox.fontSize * _sizeMultiplier;
	            textFormat.align = _textBox.alignment;
	            textFormat.font = _textBox.font;
	            textFormat.bold = false;
	            _innerTextField.setTextFormat(textFormat);

				// Determine height and y placement of the inner textField based on the text in the field
	            // height should be just height of text, plus a little extra to cover low hanging letters, eg. "g"
				var requiredHeightForText:Number = _innerTextField.getLineMetrics(0).ascent + _innerTextField.getLineMetrics(0).descent + (4 * _sizeMultiplier);
				_innerTextField.height = requiredHeightForText;
	            _innerTextField.y = (((_textBox.height * _sizeMultiplier) - _innerTextField.height)/2); // textField should be offset to be vertically in middle of the UITextBox
			this.addChild(_innerTextField);
            
            // position the UITextBox on the UISide
            this.x = _textBox.x * _sizeMultiplier;
            this.y = _textBox.y * _sizeMultiplier;
            this.height = _textBox.height * _sizeMultiplier;
            this.width = _textBox.width * _sizeMultiplier;
            
            //textField should have no padding around text
            //_textField.border = true;
            // WORK REQUIRED HERE
            
            // draw a selection box around the UITextBox if it is selected
            super.implementSelectedIfTrue();
                        
            // force a redraw by Flash Player
            this.invalidateDisplayList();
        }
        
		private function handleUserTextUpdate(event:Event):void
		{
			// update the data model
			_textBox.text = _innerTextField.text;
		}
		
		private function handleComponentSelection(event:Event):void
		{			 
			 // allow the user to select and edit text
        	_innerTextField.type = TextFieldType.INPUT;
        	_innerTextField.mouseEnabled = true;
        	// add an event listener for any changes made to the text by the user - these will be propogated to the model
        	_innerTextField.addEventListener(Event.CHANGE, handleUserTextUpdate);
        	// prevent any keys pressed by the user while they're editing text from reaching anywhere else
        	_innerTextField.addEventListener(KeyboardEvent.KEY_DOWN, consumeInnerTextKeyEvent);
		}
		
		private function handleComponentDeselection(event:Event):void
		{
			// undo the component selection
        	_innerTextField.mouseEnabled = false;
			_innerTextField.removeEventListener(Event.CHANGE, handleUserTextUpdate);
        	_innerTextField.removeEventListener(KeyboardEvent.KEY_DOWN, consumeInnerTextKeyEvent);
        	
        	// clear any selection from the text field and remove the caret
        	_innerTextField.setSelection(0,0);
        	_innerTextField.type = TextFieldType.DYNAMIC;
		}
		
		private function consumeInnerTextKeyEvent(event:KeyboardEvent):void
		{
			// only allow keystrokes that are accompanied with the Ctrl key to propogate outside of the user's text editing
			if (event.ctrlKey != true)
				event.stopPropagation();
		}
		
    }
}