package com.mindegg.view
{
	///////////////////////////////////
	// UIUserComponent.as
	//
	// Subclass of mx.core.UIComponent. Superclass of displayable components that may be added to sides by users.
	// Handles common UIComponent functionality such as displaying selection, changing size parameters, etc.
	// 
	///////////////////////////////////
	
	import com.mindegg.data.Component;
	import com.mindegg.utils.CustomEvent;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import mx.core.UIComponent;
	
	public class UIUserComponent extends UIComponent
	{
		
		private var _component:Component; // reference to the component data object that this UIUserComponent represents on screen
		
		// Dragging State
			private var _dragXOffset:Number = 0; 					// location of the cursor within the component when first clicked
			private var _dragYOffset:Number = 0;
			
			private var _boundsRectangle:Rectangle;					// the area where dragging is allowed
			private var _startingLocalComponentPosition:Point;		// a point specifying the position of this component before the start of any current drag
			private var _startingLocalCornerPosition:Point;			// a point specifying the position of this corner before the start of any current drag
			
			private var _stage:Stage;								// reference to the stage
			private var _draggedCornerCircle:CornerCircle; 			// reference to any currently dragged CornerCircle
			
			private var _startingX:uint;							// the component's x position when the drag started
			private var _startingY:uint;							// the component's y position when the drag started
			private var _startingWidth:uint;						// the component's width when the drag started
			private var _startingHeight:uint;						// the component's width when the drag started
		
		public static const COMPONENT_CHANGED:String = "componentChanged";		
		
		public function UIUserComponent(component:Component)
		{
			// check that it is a subclass being instantiated & if not, throw error
			if(getQualifiedClassName(this) == "com.mindegg.view::UIUserComponent")
			{
				throw new Error("UIUserComponent is an abstract class&gt and can not be instantiated.");
			}
			
			_component = component;			
		}
		
		public function redraw():void
		{
			// this should never be run - abstract function
			throw new Error("redraw() called on UIUserComponent. redraw() must be called on a subclass.");
		}
		
		public function implementSelectedIfTrue():void
		{
			if (_component.isSelected())
			{
				this.addChild(new SelectionHighlighting(_component));
			}
		}
		
		public function dragCorner(cornerCircle:CornerCircle, stage:Stage):void
		{			
			// retain stage and cornerCircle reference
			_stage = stage;
			_draggedCornerCircle = cornerCircle;
			
			// retain the starting position of the corner
			_startingLocalCornerPosition = new Point(cornerCircle.x, cornerCircle.y);
			_startingX = _component.x;
			_startingY = _component.y;
			_startingWidth = _component.width;
			_startingHeight = _component.height;

			// find the global positions of the: cursor, CornerCircle
			var globalMouseStartPoint:Point = localToGlobal(new Point(mouseX, mouseY));
			var globalCornerPosition:Point = cornerCircle.parent.localToGlobal(_startingLocalCornerPosition);

			// calculate offsets (click distance from centre of CornerCircle)
			_dragXOffset = globalMouseStartPoint.x - globalCornerPosition.x;
			_dragYOffset = globalMouseStartPoint.y - globalCornerPosition.y;
			
			// Set the bounds to be the opposite corner and the parent UISide
			// Rectangle (left_side, top_side, width, height)
			if (cornerCircle.name == "topLeftCornerCircle")
			{
				_boundsRectangle = new Rectangle(0, 0, _startingX + _startingWidth - 1, _startingY + _startingHeight - 1);
			}
			else if (cornerCircle.name == "topRightCornerCircle")
			{
				_boundsRectangle = new Rectangle(_startingX + 1, 0, parent.width - (_startingX + 1), _startingHeight + _startingY - 1);
				
			}
			else if (cornerCircle.name == "bottomLeftCornerCircle")
			{
				_boundsRectangle = new Rectangle(0, _startingY + 1, _startingX + _startingWidth - 1, parent.height - (_startingY + 1));				
			}
			else if (cornerCircle.name == "bottomRightCornerCircle")
			{
				_boundsRectangle = new Rectangle(_startingX + 1, _startingY + 1, parent.width - (_startingX + 1), parent.height - (_startingY + 1));				
			}
			
			// Listen to mouse move & up events
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, cornerMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, cornerDrop);
		}
		
		public function cornerMove(event:MouseEvent):void
		{
			// calculate position of mouse
			var globalMouseCurrentPoint:Point = new Point(event.stageX, event.stageY);
			var localMouseCurrentPoint:Point = parent.globalToLocal(globalMouseCurrentPoint);
			
			// calculate the position the centre of the corner was dragged to....
			var xPositionCornerDraggedTo:int = localMouseCurrentPoint.x - _dragXOffset;
			var yPositionCornerDraggedTo:int = localMouseCurrentPoint.y - _dragYOffset;
						
			// .... but keep it inside the bounds
				if (xPositionCornerDraggedTo < _boundsRectangle.left)
					{xPositionCornerDraggedTo = _boundsRectangle.left;}
				else if (xPositionCornerDraggedTo > _boundsRectangle.right)
					{xPositionCornerDraggedTo = _boundsRectangle.right;}
				
				if (yPositionCornerDraggedTo < _boundsRectangle.top)
					{yPositionCornerDraggedTo = _boundsRectangle.top;}
				else if (yPositionCornerDraggedTo > _boundsRectangle.bottom)
					{yPositionCornerDraggedTo = _boundsRectangle.bottom;}
			
			
			if (_draggedCornerCircle.name == "topLeftCornerCircle")
			{
				// update UIUserComponent dimensions
				this.x = xPositionCornerDraggedTo;
				this.y = yPositionCornerDraggedTo;
				this.width = (_startingX - xPositionCornerDraggedTo) + _startingWidth;
				this.height = (_startingY - yPositionCornerDraggedTo) + _startingHeight;
				// update object model to reflect new dimensions
				_component.x = this.x;
				_component.y = this.y;
				_component.height = this.height;
				_component.width = this.width;
			}
			else if (_draggedCornerCircle.name == "topRightCornerCircle")
			{
				// update UIUserComponent dimensions
				this.y = yPositionCornerDraggedTo;
				this.width = xPositionCornerDraggedTo - _startingX;
				this.height = (_startingY - yPositionCornerDraggedTo) + _startingHeight;
				// update object model to reflect new dimensions
				_component.y = this.y;
				_component.height = this.height;
				_component.width = this.width;
			}
			else if (_draggedCornerCircle.name == "bottomLeftCornerCircle")
			{
				// update UIUserComponent dimensions
				this.x = xPositionCornerDraggedTo;
				this.width = (_startingX - xPositionCornerDraggedTo) + _startingWidth;
				this.height = yPositionCornerDraggedTo - _startingY;
				// update object model to reflect new dimensions
				_component.x = this.x;
				_component.height = this.height;
				_component.width = this.width;
			}
			if (_draggedCornerCircle.name == "bottomRightCornerCircle")
			{
				// update UIUserComponent dimensions
				this.width = xPositionCornerDraggedTo - _startingX;
				this.height = yPositionCornerDraggedTo - _startingY;
				// update object model to reflect new dimensions
				_component.width = this.width;
				_component.height = this.height;
			}
			
			// update properties pane
			var params:Object = new Object();
			params.component = _component;
			params.uiUserComponent = this;
            var componentChangedEvent:CustomEvent = new CustomEvent(COMPONENT_CHANGED, params, true);
            dispatchEvent(componentChangedEvent);
			
			// Force the player to re-draw the UIComponent after the event, creating a smooth movement
			this.redraw();
			event.updateAfterEvent();
		}
		
		public function cornerDrop(event:MouseEvent):void
		{
			// remove the drag event listeners
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, cornerDrop);
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, cornerMove);
			
			_startingLocalCornerPosition = null;
		}
		
		/**
		 * Starts a smooth dragging operation, forcing the player to redraw
		 * the Sprite after every mouse move.  Cancel the drag() operation
		 * by calling the drop() method.
		 */
		public function drag(stage:Stage):void
		{
			// retain stage reference
			_stage = stage;
			
			// remember the position of the UIUserComponent within the UISide for use during moving
			_startingLocalComponentPosition = new Point(_component.x, _component.y);
			
			// find the global positions of the: cursor position, component position, side position
			var globalMouseStartPoint:Point = localToGlobal(new Point(mouseX, mouseY));
			var globalComponentPosition:Point = parent.localToGlobal(_startingLocalComponentPosition);
			
			// translate to UIComponent co-ordinates
			_dragXOffset = globalMouseStartPoint.x - globalComponentPosition.x;
			_dragYOffset = globalMouseStartPoint.y - globalComponentPosition.y;
			
			// Set the bounds to be the parent UISide
			_boundsRectangle = new Rectangle(0, 0, parent.width, parent.height);
			
			// Listen to mouse move & up events
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, componentMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, componentDrop);
		}
		
		/**
		 * Called everytime the mouse moves after the drag() method has
		 * been called.  Updates the position of the UIComponent based on
		 * the location of the mouse cursor.
		 */
		private function componentMove(event:MouseEvent):void
		{
			// calculate position of mouse
			var globalMouseCurrentPoint:Point = new Point(event.stageX, event.stageY);
			var localMouseCurrentPoint:Point = parent.globalToLocal(globalMouseCurrentPoint);
			
			// move UIUserComponent to the position dragged to....
			this.x = localMouseCurrentPoint.x - _dragXOffset;
			this.y = localMouseCurrentPoint.y - _dragYOffset;	
			
			// .... but keep it inside its UISide
				if (x < _boundsRectangle.left)
					{x = _boundsRectangle.left;}
				else if ((x + _component.width) > _boundsRectangle.right)
					{x = (_boundsRectangle.right - _component.width);}
				
				if (y < _boundsRectangle.top)
					{y = _boundsRectangle.top;}
				else if ((y + _component.height) > _boundsRectangle.bottom)
					{y = (_boundsRectangle.bottom - _component.height);}
			
			// update the object model to reflect the new position
			_component.x = this.x;
			_component.y = this.y;
			
			// update properties pane
			var params:Object = new Object();
			params.component = _component;
			params.uiUserComponent = this;
            var componentChangedEvent:CustomEvent = new CustomEvent(COMPONENT_CHANGED, params, true);
            dispatchEvent(componentChangedEvent);
			
			// Force the player to re-draw the UIComponent after the event, creating a smooth movement
			event.updateAfterEvent();
		}
		
	
		/**
		 * Cancels a drag() operation
		 */
		public function componentDrop(event:MouseEvent):void
		{
			// remove the drag event listeners
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, componentDrop);
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, componentMove);
			
			_startingLocalComponentPosition = null;
		}
		
		public function get component():Component
		{
			return _component;
		}

	}
}
