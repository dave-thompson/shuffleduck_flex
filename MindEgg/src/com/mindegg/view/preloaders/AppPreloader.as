// see http://blog.preinvent.com/node/6

package com.mindegg.view.preloaders
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class AppPreloader extends DownloadProgressBar
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

		// the components that will be drawn on the screen		
		private var preloaderScreen:PreloaderScreen = new PreloaderScreen(_preloaderWidth, _preloaderHeight, _progressBarHorizOffset, _progressBarBottomOffset, _progressBarHeight);
		private var preloaderProgressBarFill:PreloaderProgressBarFill = new PreloaderProgressBarFill(_preloaderWidth, _preloaderHeight, _progressBarHorizOffset, _progressBarBottomOffset, _progressBarHeight);
		
		public function AppPreloader()
		{
			super();
			
			// Add an event listener so that we can start drawing once we know we're on the stage
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			
			// Add the loader screen to the stage and center it
			addAndCenter(preloaderScreen);
			// Force an initial draw of the loader screen		
			preloaderScreen.refreshDisplay();

			// Add the progress bar to the stage and center it
			addAndCenter(preloaderProgressBarFill);
		}
		
		// Called by the framework so we can add our event listeners to the various events we're interested in
		override public function set preloader(value:Sprite):void {
            value.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
            value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteEventHandler);            
		}
		
		// We've made progress... create a new fill with the new progress value
		private function progressEventHandler(event:ProgressEvent):void {
			var progress:Number = event.bytesLoaded/event.bytesTotal;
			removeChild(preloaderProgressBarFill);			
			preloaderProgressBarFill = new PreloaderProgressBarFill(_preloaderWidth, _preloaderHeight, _progressBarHorizOffset, _progressBarBottomOffset, _progressBarHeight, progress);
			addAndCenter(preloaderProgressBarFill);						
		}
		
		// Load complete, fire the Event.COMPLETE event and the framework will carry on from there
		private function initCompleteEventHandler(event:FlexEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// helper function to center a displayObject on the screen
		private function addAndCenter(displayObject:DisplayObject):void
		{
			addChild(displayObject);
			displayObject.x = (stage.stageWidth-displayObject.width)/2;
			displayObject.y = (stage.stageHeight-displayObject.height)/2;
		}
		
	}
}