package com.mindegg.view
{
	//import flash.utils.*;
	
	import mx.core.UIComponent;
	import com.mindegg.data.Component;
		
	public class CornerCircle extends UIComponent
	{
		public function CornerCircle()
		{
				// draw circle
				var radius:uint = 3;
				this.graphics.lineStyle(1,0xfb9221,1);
				this.graphics.beginFill(0xCC9966);
				this.graphics.drawCircle(0, 0, radius);
				this.graphics.endFill();
		}
	}
}
