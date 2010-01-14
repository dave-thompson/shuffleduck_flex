
package ascb.display {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A DraggableSprite is a Sprite that has the ability to interact
	 * with the Mouse in drag and drop scenarios.  All Sprites have
	 * the startDrop() and stopDrag() methods, but those methods only
	 * update the display list during enterFrame events, instead of
	 * during mouseMove events, which leads to choppy dragging.  The
	 * DraggableSprite provides a drag() method, similar to startDrag()
	 * and a drop() method, similar to stopDrag(), that enable smooth
	 * drag and drop operations.
	 */
	public class DraggableSprite extends Sprite {
	
		// Store the location of the cursor within the component so we can position correctly when the cursor moves
		private var _dragXOffset:Number = 0;
		private var _dragYOffset:Number = 0;
		
		// Keep track of the area where dragging is allowed so the component can be kept in bounds.
		private var _boundsRectangle:Rectangle;
		
		/**
		 * Starts a smooth dragging operation, forcing the player to redraw
		 * the Sprite after every mouse move.  Cancel the drag() operation
		 * by calling the drop() method.
		 */
		public function drag():void
		{
			// find the global cursor position
			var globalMouseStartPoint:Point = localToGlobal(new Point(mouseX, mouseY));
			
			// translate to UIComponent co-ordinates
			_dragXOffset = globalMouseStartPoint.x - this.x;
			_dragYOffset = globalMouseStartPoint.y - this.y;
			
			// Set the bounds to be the parent UISide
			_boundsRectangle = new Rectangle(parent.x, parent.y, parent.width, parent.height);
			
			// Listen to mouse move & up events
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, drop);
		}
		
		/**
		 * Called everytime the mouse moves after the drag() method has
		 * been called.  Updates the position of the UIComponent based on
		 * the location of the mouse cursor.
		 */
		private function handleDrag(event:MouseEvent):void
		{
			// Move the component
			this.x = event.stageX - _dragXOffset;
			this.y = event.stageY - _dragYOffset;
			
			// Keep sprite in bounds 

				if ( x < bounds.left )
					{x = bounds.left;}
				else if ( x > bounds.right )
					{x = bounds.right;}
				
				if ( y < bounds.top )
					{y = bounds.top;}
				else if ( y > bounds.bottom )
					{y = bounds.bottom;}
			
			// Force the player to re-draw the sprite after the event, creating a smooth movement
			event.updateAfterEvent();
		}
	
		/**
		 * Cancels a drag() operation
		 */
		public function drop():void
		{
			// remove the drag event listeners
			stage.removeEventListener( MouseEvent.MOUSE_UP, drop );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleDrag );
		}
	}
}