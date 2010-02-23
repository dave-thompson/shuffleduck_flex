// see http://blog.preinvent.com/node/6

package com.mindegg.view.preloaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;

	public class PreloaderScreen extends Loader
	{
		// The width and height of this screen - usually the max size of the background image
		private var _preloaderWidth:Number = 450;
		private var _preloaderHeight:Number = 150;

		// The space to leave between the edge of the background image and the start/end of the progress bar		
		private static var _progressBarHorizOffset:Number = 20;
		
		// The space to leave from the bottom of the background image to the bottom of the progress bar  
		private static var _progressBarBottomOffset:Number = 20;
		
		// The height of our progress bar
		private static var _progressBarHeight:Number = 10;
		
		// Graphics
		[Embed(source="../../assets/PreloaderBackground.png")]
		private var backgroundImage:Class;
		
		private var _progress:Number = 0;
		
		// Called to get the screen graphic and display
		public function refreshDisplay():void {
			var bmpData:BitmapData = drawProgress();
			var encoder:PNGEncoder = new PNGEncoder();
			var byteArray:ByteArray = encoder.encode(bmpData);
			this.loadBytes(byteArray);
		}

		public function getBitmap():Bitmap {
			var bmpData:BitmapData = drawProgress();
			var bmp:Bitmap = new Bitmap(bmpData);
			return bmp;
		}

		// Draws the screen graphic to a BitmapData for display		
		private function drawProgress():BitmapData
		{

			// Create a new sprite and graphics context for manual drawing
			var sprite:Sprite = new Sprite();
			var graph:Graphics = sprite.graphics;

			// The BitmapData that gets returned for drawing
			var bmpData:BitmapData = new BitmapData(width, height, true, 0);
			
			// Draw background
			var bmp:Bitmap = new backgroundImage as Bitmap;
			bmpData.draw(bmp.bitmapData);

			// Draw the progress bar background area
			graph.beginFill(0x333333);
			graph.drawRoundRect(_progressBarHorizOffset, 
				height-_progressBarBottomOffset-_progressBarHeight,
				width-_progressBarHorizOffset-_progressBarHorizOffset, 
				_progressBarHeight, 10);
			graph.endFill();

			// Draw our progress bar onto the sprite's graphics
			graph.beginFill(0xFCBC4F);
			graph.drawRoundRect(_progressBarHorizOffset, 
				height-_progressBarBottomOffset-_progressBarHeight,
				(width-_progressBarHorizOffset-_progressBarHorizOffset)*_progress, 
				_progressBarHeight, 10);
			graph.endFill();
			
			// Draw the sprite onto the main BitmapData
			bmpData.draw(sprite);
			return bmpData;
		}
		
		// Override the width and height properties
		public override function set width(value:Number):void { _preloaderWidth = value; }
		public override function get width():Number { return _preloaderWidth; }
		
		public override function set height(value:Number):void { _preloaderHeight = value; }
		public override function get height():Number { return _preloaderHeight; }
        
        // Number between 0 and 1 indicating how far through the loading progress we are
        public function set progress(n:Number):void { _progress = n; refreshDisplay(); }
        public function get progress():Number { return _progress; }
	}
}