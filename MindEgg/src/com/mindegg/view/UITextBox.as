package com.mindegg.view
{
		
    import com.mindegg.data.TextBox;
    
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    public class UITextBox extends UIUserComponent
    {
    	private var _textBox:TextBox; // referene to the textbox that this UITextBox represents on screen
    	
    	// internal representation variables
		private var _innerTextField:TextField;
		private var _outerTextField:TextField;
    	
    	/**********************
  	    *   Constructor
  	    ***********************/
		
		/**
  	    * 	Purpose:	Draw a UI representation of the supplied textbox
  	    */
        public function UITextBox(textBox:TextBox)
        {
        	// retain reference to object model
        	_textBox = textBox;
        	
        	// instantiate sub-components
        	_innerTextField = new TextField();
	        _outerTextField = new TextField();
        	
        	// call super so that it also has reference
        	super(textBox);

			// draw the sub-components
			this.redraw();
            
            // sub-components should be invisible as far as mouse interactions are concerned
            //this.mouseChildren = false;
        }
        
        public override function redraw():void
        {
        	// remove all currently drawn sub-components
        	while (this.numChildren > 0)
        	{
        		this.removeChildAt(0);
        	}

			// Create an outerTextField to represent the TextBox's background
	            _outerTextField.alpha = _textBox.alpha;
	            _outerTextField.background = true;
	            _outerTextField.backgroundColor = _textBox.backgroundColor;
	            _outerTextField.x = 0;
	            _outerTextField.y = 0;
	            _outerTextField.width = _textBox.width;
	            _outerTextField.height = _textBox.height;
			this.addChild(_outerTextField);

            // create an innerTextField to hold the text
	            _innerTextField.x = 0;
	            _innerTextField.width = _textBox.width;
	            _innerTextField.text = _textBox.text;
	            _innerTextField.alpha = _textBox.alpha;            
	            // format the text
		        var textFormat:TextFormat = new TextFormat();
	            textFormat.color = _textBox.foregroundColor;
	            textFormat.size = _textBox.fontSize;
	            textFormat.align = _textBox.alignment;
	            textFormat.font = _textBox.font;
	            textFormat.bold = false;
	            _innerTextField.setTextFormat(textFormat);
				// Determine height and y placement of the inner textField based on the text in the field
	            //_textField.height = _textField.textHeight + 4; // height should be just height of text, plus a little extra to cover low hanging letters, eg. "g"
				_innerTextField.height = _innerTextField.getLineMetrics(0).ascent + _innerTextField.getLineMetrics(0).descent + 4;
	            _innerTextField.y = ((_textBox.height - _innerTextField.height)/2); // textField should be offset to be vertically in middle of the UITextBox
			this.addChild(_innerTextField);
            
            // position the UITextBox on the UISide
            this.x = _textBox.x;
            this.y = _textBox.y;
            this.height = _textBox.height;
            this.width = _textBox.width;
            
            //textField should have no padding around text
            //_textField.border = true;
            // WORK REQUIRED HERE
            
            // textField should show selection even when it doesn't have focus
            _innerTextField.alwaysShowSelection = true;
            
            // sub-components should not receive mouse events
            // (can't use mouseChildren as CornerCircle children do need to receive mouse events)
            _innerTextField.mouseEnabled = false;
            _outerTextField.mouseEnabled = false;
            
            // draw a selection box around the UITextBox if it is selected
            super.implementSelectedIfTrue();
            
            // force a redraw by Flash Player
            this.invalidateDisplayList();
        }
        
        public function selectText():void
        {

        	// DOESN'T WORK - NEED NEW IMPLEMENTATION FOR SELECTION
        	/*
        	stage.focus = _textField;
        	_textField.setSelection(0, _textField.length);
        	stage.focus = _textField;	
        	*/
        }
        
            
    }
}