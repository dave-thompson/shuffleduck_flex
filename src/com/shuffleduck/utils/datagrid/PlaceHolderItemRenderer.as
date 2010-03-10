// modified; originally from http://blogs.adobe.com/aharui/2008/03/custom_arraycollections_adding.html

package com.shuffleduck.utils.datagrid
{

import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.controls.dataGridClasses.DataGridListData;

/** 
 *  DataGrid that uses checkboxes for multiple selection
 */
public class PlaceHolderItemRenderer extends DataGridItemRenderer
{
    public function PlaceHolderItemRenderer()
	{
		super();
	}

    override public function validateProperties():void
	{
		// if there is no data in this cell, then copy the header text and set the style to appear as a placeholder
		if (listData.label == "")
		{
			var dgListData:DataGridListData = DataGridListData(listData);
			listData.label = ""; //DataGrid(parent.parent).columns[dgListData.columnIndex].headerText;
			setStyle("color", 0x808080);
			setStyle("fontStyle", "italic");
		}
		// if there is data in the cell, then clear the style to appear normal
		else
		{
			clearStyle("color");
			clearStyle("fontStyle");
		}
		super.validateProperties();
	}
}

}