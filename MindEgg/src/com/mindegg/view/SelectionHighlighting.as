package com.mindegg.view
{
	import com.mindegg.data.Component;
	
	import mx.core.UIComponent;
		
	public class SelectionHighlighting extends UIComponent
	{

		public function SelectionHighlighting(component:Component)
		{
				// draw line around the component
				this.graphics.lineStyle(1,0x25e9eb,1);
				//this.graphics.drawRect(component.x-1, component.y-1, component.width+1, component.height+1);
				this.graphics.drawRect(-1, -1, component.width+1, component.height+1);				
				
				// draw circles on each corner
				var cornerCircle:CornerCircle;
				
					// top left
					cornerCircle = new CornerCircle();
					cornerCircle.x = 0;
					cornerCircle.y = 0;
					this.addChild(cornerCircle);
					cornerCircle.name = "topLeftCornerCircle";
					cornerCircle.mouseEnabled = true;
					
					// top right
					cornerCircle = new CornerCircle();
					cornerCircle.x = component.width;
					cornerCircle.y = 0;
					this.addChild(cornerCircle);
					cornerCircle.name = "topRightCornerCircle";
					cornerCircle.mouseEnabled = true;

					// bottom left
					cornerCircle = new CornerCircle();
					cornerCircle.x = 0;
					cornerCircle.y = component.height;
					this.addChild(cornerCircle);
					cornerCircle.name = "bottomLeftCornerCircle";
					cornerCircle.mouseEnabled = true;

					// bottom right
					cornerCircle = new CornerCircle();
					cornerCircle.x = component.width;
					cornerCircle.y = component.height;
					this.addChild(cornerCircle);
					cornerCircle.name = "bottomRightCornerCircle";
					cornerCircle.mouseEnabled = true;
		}
	}
}
