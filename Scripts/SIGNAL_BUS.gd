extends Node

# inventory signals
@warning_ignore("unused_signal")
signal INVENTORY_OPENED
@warning_ignore("unused_signal")
signal INVENTORY_CLOSED
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_SELECTED
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_PLACED
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_SWAPPED
@warning_ignore("unused_signal")
signal INVENTORY_SELECTED
@warning_ignore("unused_signal")
signal INVENTORY_UPDATE
@warning_ignore("unused_signal")
signal INVENTORY_DESELECTED
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_DROPPED
@warning_ignore("unused_signal")

# picking up items
signal NEARBY_ITEM_DETECTED
@warning_ignore("unused_signal")
signal NEARBY_ITEM_EMPTY
@warning_ignore("unused_signal")
signal NEARBY_ITEM_PICKUP

# menu signals
@warning_ignore("unused_signal")
signal MENU_OPENED
@warning_ignore("unused_signal")
signal MENU_CLOSED

# debug signals
@warning_ignore("unused_signal")
signal DEBUG_INSERT_NEW_ITEM (item: Inventory_Item)