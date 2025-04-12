extends Node

# inventory signals
@warning_ignore("unused_signal")
signal INVENTORY_OPENED ()
@warning_ignore("unused_signal")
signal INVENTORY_CLOSED ()
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_SELECTED (slot_id: int, item_icon: Texture2D)
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_PLACED (slot_id: int)
@warning_ignore("unused_signal")
signal INVENTORY_ITEM_SWAPPED (slot_id: int, item_icon: Texture2D)
@warning_ignore("unused_signal")
signal INVENTORY_SELECTED (inventory: Inventory)
@warning_ignore("unused_signal")
signal INVENTORY_UPDATE ()
@warning_ignore("unused_signal")
signal INVENTORY_DESELECTED ()
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
signal INVENTORY_FULL ()

# picking up items
@warning_ignore("unused_signal")
signal NEARBY_ITEM_DETECTED (item: Node3D)
@warning_ignore("unused_signal")
signal NEARBY_ITEM_EMPTY ()
@warning_ignore("unused_signal")
signal NEARBY_ITEM_PICKUP (guid: int)

# menu signals
@warning_ignore("unused_signal")
signal MENU_OPENED ()
@warning_ignore("unused_signal")
signal MENU_CLOSED ()

# debug signals
@warning_ignore("unused_signal")
signal DEBUG_INSERT_NEW_ITEM (item: Inventory_Item)
