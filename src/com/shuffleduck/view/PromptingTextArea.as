package com.shuffleduck.view
{
	import flash.events.FocusEvent;
	
	import mx.controls.TextArea;

	public class PromptingTextArea extends TextArea
	{
                private var _prompt:String;
                
                public function PromptingTextArea()
                {
                        super();
                        if( text == ""){
                                text = prompt;
                                setStyle("color", "0x999999")
                                setStyle("fontStyle","italic");
                        }
                        addEventListener(FocusEvent.FOCUS_IN, FocusIn);
                        addEventListener(FocusEvent.FOCUS_OUT, focusOut);
                }
                
                public function set prompt(value:String):void{
                        _prompt = value;
                        if( text == ""){
                                text = prompt;
                                setStyle("color", "0x999999")
                                setStyle("fontStyle","italic");
                        }else{
                                setStyle("color", "0x0B333C")
                                setStyle("fontStyle","normal");
                        }
                }
                
                public function get prompt():String{
                        return _prompt;
                }
                
                private function FocusIn(event:FocusEvent):void{
                        if( text == prompt ){
                                text = "";
                        }
                        setStyle("color", "0x0B333C")
                }
                private function focusOut(event:FocusEvent):void{
                        if( text == "" ){
                                text = prompt;
                                setStyle("color", "0x999999");
                                setStyle("fontStyle","italic");
                        }else{
                                setStyle("color", "0x0B333C");
                                setStyle("fontStyle","normal");
                        }
                        
                }		
	}
}