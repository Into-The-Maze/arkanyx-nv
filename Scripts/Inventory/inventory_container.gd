extends Control

var is_open: bool
var selected_item: Inventory_Item
var selected_inventory: Inventory

func _ready():
	SignalBus.connect("INVENTORY_SELECTED", select_inventory.bind())
	SignalBus.connect("INVENTORY_ITEM_SELECTED", select_item.bind())
	SignalBus.connect("INVENTORY_ITEM_PLACED", insert_item.bind())

	close()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func select_inventory(inventory):
	selected_inventory = inventory

func open():
	is_open = true
	visible = true
	mouse_filter = MouseFilter.MOUSE_FILTER_STOP
	SignalBus.emit_signal("INVENTORY_OPENED")

func close():
	is_open = false
	visible = false
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	SignalBus.emit_signal("INVENTORY_CLOSED")

func select_item(id, _texture):
	if selected_inventory == null: return
	selected_item = selected_inventory.inventory[id]
	selected_inventory.inventory[id] = null
	SignalBus.emit_signal("INVENTORY_UPDATE")

func insert_item(id):
	if selected_inventory == null: return
	selected_inventory.inventory[id] = selected_item
	selected_item = null
	SignalBus.emit_signal("INVENTORY_UPDATE")
