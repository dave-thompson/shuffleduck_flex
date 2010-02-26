// modified; originally from http://blogs.adobe.com/aharui/2008/03/custom_arraycollections_adding.html

package com.mindegg.utils.datagrid
{
import mx.collections.ArrayCollection;

public class NewEntryArrayCollection extends ArrayCollection
{
	private var newEntry:Object;

	public var factoryFunction:Function; /** Function to create a new entry */
	public var emptyTestFunction:Function; /** Function to test if a given entry is empty */

	/**
	 * Constructor: Instantiate using the contents of the provided array.
	 */
	public function NewEntryArrayCollection(source:Array)
	{
		super(source);
	}

	/**
	 * Return the item at the requested index, or a new entry if the index is one greater than the size of the underlying dataset.
	 */
    override public function getItemAt(index:int, prefetch:int=0):Object
    {
        if (index < 0 || index >= length)
            throw new RangeError("invalid index", index);
		else
		{
			if (index < super.length)
				return super.getItemAt(index, prefetch);
			else
			{
				if (!newEntry)
					newEntry = factoryFunction();
				return newEntry;
			}
		}
    }

	/**
	 * Return the length of the dataset, including the dummy row.
	 */
    override public function get length():int
    {
		return super.length + 1;
    }

	/**
	 * Notify the view that a data item has been updated.
	 * Removes any old items which have had all their data removed.
	 * Adds any new items which have had data entered to them.
	 */
    override public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void
	{
		super.itemUpdated(item, property, oldValue, newValue);			
		// if this is an old row but is now empty, remove it
		if (item != newEntry)
		{
			if (emptyTestFunction != null)
			{
				if (emptyTestFunction(item))
				{
					removeItemAt(getItemIndex(item));
				}
			}
		}
		// if this is a new row and has data,
		//   then add it to the dataset and reset the newEntry object ready for the next new item
		else
		{
			if (emptyTestFunction != null)
			{
				if (!emptyTestFunction(item))
				{
					newEntry = null;
					addItemAt(item, length - 1);
				}
			}
		}
	}

}

}

