// see http://blog.preinvent.com/node/6

package com.mindegg.view.preloaders
{
	import flash.display.Shape;

	public class PreloaderProgressBarFill extends Shape
	{
		// The width and height of this screen - usually the max size of the background image
		private var _preloaderWidth:Number;
		private var _preloaderHeight:Number;

		// The space to leave between the edge of the background image and the start/end of the progress bar		
		private static var _progressBarHorizOffset:Number;
		
		// The space to leave from the bottom of the background image to the bottom of the progress bar  
		private static var _progressBarBottomOffset:Number;
		
		// The height of the progress bar
		private static var _progressBarHeight:Number;

		
		public function PreloaderProgressBarFill(width:Number, height:Number, horizOffset:Number, bottomOffset:Number, barHeight:Number, progress:Number = 0)
		{
			// set dimensions
			_preloaderWidth = width;
			_preloaderHeight = height;
			_progressBarHorizOffset = horizOffset;
			_progressBarBottomOffset = bottomOffset;
			_progressBarHeight = barHeight;
			
			// draw with requested progress value
			draw(progress);
		}
		
		private function draw(progress:Number):void
		{
			// Draw our progress bar onto the sprite's graphics
			graphics.beginFill(0xFCBC4F);
			graphics.drawRoundRect(	_progressBarHorizOffset, 
									height-_progressBarBottomOffset-_progressBarHeight,
									(width-_progressBarHorizOffset-_progressBarHorizOffset)*progress, 
									_progressBarHeight,
									10
								);
			graphics.endFill();
		}
		
		// Override the width and height properties
		public override function set width(value:Number):void { _preloaderWidth = value; }
		public override function get width():Number { return _preloaderWidth; }
		
		public override function set height(value:Number):void { _preloaderHeight = value; }
		public override function get height():Number { return _preloaderHeight; }		
	}
}