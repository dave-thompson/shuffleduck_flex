/*
*
*		Courtesy of http://www.blog.dannygagne.com/?p=80
*
*/

package com.mindegg.view
{
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenuItem;
	
	import mx.core.Application;
	import mx.core.UIComponent;
 
	public class ContextualMenu
	{
		public var MenuContents:Array = new Array ();
 
 		private var _uiComponent:UIComponent; // the UIComponent to which this menu applies
 											// (change to an array if you need menus shared between multiple components)
 
		public  function ContextualMenu(){}
 
		public function AddItem (name:String, func:Function):void
		{
			MenuContents.push({Name:name, Func:func});
		}
 
		public function AssignRightClick (uiComponent:UIComponent):void
		{
			_uiComponent = uiComponent;
			uiComponent.addEventListener(MouseEvent.MOUSE_OVER, genEnableMenu (uiComponent));
		}
 
		/* Assignment */
		private function ResetContextMenu (event:MouseEvent):void
		{
			// Only reset the context menu if this event was fired from outside of the uiComponent that the menu belongs to
			if (event.target.toString().indexOf("." + _uiComponent.name) == -1)
			{
				//remove menu
				Application.application.contextMenu.customItems = new Array ();
				//remove this function
				Application.application.removeEventListener(MouseEvent.MOUSE_MOVE, ResetContextMenu);
			}
		}
  
		private function genEnableMenu (uiComponent:UIComponent):Function
		{
			return function (event:MouseEvent):void
			{
				//add event listener to remove the menu on mouse move
				Application.application.addEventListener(MouseEvent.MOUSE_MOVE, ResetContextMenu);

				//hide current menu
				Application.application.contextMenu.hideBuiltInItems();
 
				//remove menu (if you right click and then move, this may not be killed.
				Application.application.contextMenu.customItems = new Array ();				
 
				//create new menu
				for (var i:Number in MenuContents)
				{
					var menuItem:ContextMenuItem = new ContextMenuItem(MenuContents[i].Name);
					menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, MenuContents[i].Func);
					Application.application.contextMenu.customItems.push(menuItem);
				}
			}
		}
 
		private function genClickCall (func:Function):Function
		{
			return function (event:ContextMenuEvent):void
			{
				func()
				ResetContextMenu(null);
			}
 
		}
 
	}
}