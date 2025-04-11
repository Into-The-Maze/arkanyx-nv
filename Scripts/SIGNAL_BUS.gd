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

# ability slots signals
@warning_ignore("unused_signal")
signal GEAR_WEAPON_CHANGED
@warning_ignore("unused_signal")
signal WEAPON_SLOTS_UPDATED

# picking up items
@warning_ignore("unused_signal")
signal NEARBY_ITEM_DETECTED
@warning_ignore("unused_signal")
signal NEARBY_ITEM_EMPTY
@warning_ignore("unused_signal")
signal NEARBY_ITEM_PICKUP

# inspecting items
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_INSPECTED

# menu signals
@warning_ignore("unused_signal")
signal MENU_OPENED
@warning_ignore("unused_signal")
signal MENU_CLOSED
