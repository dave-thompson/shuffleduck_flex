package com.mindegg.data
{
	import com.mindegg.utils.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;

	/** 
	 *  All ShuffleDuck data model items (e.g. Deck, Card, etc.) must extend this class.
	 *  It handles:
	 * 		-- the raising of change events each time the data model changes
	 */
	public class DataModelItem extends EventDispatcher
	{
		public static const DATA_MODEL_CHANGE:String = "com.shuffleduck.data.DataModelItem::DATA_MODEL_CHANGE";
		
		public function DataModelItem(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/** 
		 *  DataModelItems should call raiseChangeEvent() every time their state changes.
		 *   This includes any change that will eventually require serialisation to the server:
		 *   	-- change of any attribute value (e.g. TextBox background color changes)
 		 *		-- addition of daughter objects (e.g. a Deck adds a new Card to its array of Cards)
 		 * 		-- removal of daughter objects
		 * 		-- change to template component ID
		 * 		-- change to variability
		 *   It does not include:
		 *		-- instantiation
		 *		-- cloning
		 * 		-- selection
		 */
		protected function raiseChangeEvent(event:Event = null):void
		{
			//trace(describeType(this).@name.toString());
			var params:Object = new Object();
		    var dataModelChangeEvent:CustomEvent = new CustomEvent(DATA_MODEL_CHANGE, params, false);
		    dispatchEvent(dataModelChangeEvent);
		}
		
		
		/** 
		 *  DataModelItems should call startPropogatingChangeEventsFrom(source) every time they add a new daughter object.
		 *  This is in addition to calling raiseChangeEvent().
		 */
		protected function startPropogatingChangeEventsFrom(source:DataModelItem):void
		{
			source.addEventListener(DATA_MODEL_CHANGE, raiseChangeEvent);
		}
		
	}
}