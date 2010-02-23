// see http://blog.preinvent.com/node/6

package com.mindegg.view.preloaders
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class AppPreloader extends DownloadProgressBar
	{
		private var preloaderScreen:PreloaderScreen = new PreloaderScreen();
		
		public function AppPreloader()
		{
			super();
			
			// Add an event listener so that we can start drawing once we know we're on the stage
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			
			// Add the loader screen to the stage and center it
			addChild(preloaderScreen);
			preloaderScreen.x = (stage.stageWidth-preloaderScreen.width)/2;
			preloaderScreen.y = (stage.stageHeight-preloaderScreen.height)/2;

			// Force an initial draw of the screen			
			preloaderScreen.refreshDisplay();
		}
		
		// Called by the framework so we can add our event listeners to the various events we're interested in
		override public function set preloader(value:Sprite):void {
            value.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
            value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteEventHandler);            
		}
		
		// We've made progress... tell the screen the new progress value
		private function progressEventHandler(event:ProgressEvent):void {
			preloaderScreen.progress = event.bytesLoaded/event.bytesTotal;
		}
		
		// Load complete, fire the Event.COMPLETE event and the framework will carry on from there
		private function initCompleteEventHandler(event:FlexEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}