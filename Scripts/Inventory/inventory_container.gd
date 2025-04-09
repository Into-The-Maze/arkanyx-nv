extends CanvasLayer

@export var player_inventory: Inventory

@onready var drop_point = $".."/ItemDropPoint

var is_open: bool
var selected_item: Inventory_Item
var selected_inventory: Inventory

func _ready():
	SIGNAL_BUS.connect("INVENTORY_SELECTED", select_inventory.bind())
	SIGNAL_BUS.connect("INVENTORY_DESELECTED", deselect_inventory.bind())
	SIGNAL_BUS.connect("INVENTORY_ITEM_SELECTED", select_item.bind())
	SIGNAL_BUS.connect("INVENTORY_ITEM_PLACED", place_item.bind())
	SIGNAL_BUS.connect("INVENTORY_ITEM_SWAPPED", swap_item.bind())
	SIGNAL_BUS.connect("INVENTORY_ITEM_DROPPED", drop_item.bind())
	SIGNAL_BUS.connect("NEARBY_ITEM_PICKUP", pickup_item.bind())

	close()

	# debug code
	var item = preload("res://Items/test_orb/test_orb.tres")
	ITEM_REGISTRY.register_item(item)
	insert_item(0, item)

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func select_inventory(inventory):
	selected_inventory = inventory

func deselect_inventory():
	selected_inventory = null

func open():
	is_open = true
	visible = true
	SIGNAL_BUS.emit_signal("INVENTORY_OPENED")

func close():
	is_open = false
	visible = false
	SIGNAL_BUS.emit_signal("INVENTORY_CLOSED")

func select_item(id, _texture):
	if selected_inventory == null: return
	selected_item = selected_inventory.inventory[id]
	selected_inventory.inventory[id] = null
	SIGNAL_BUS.emit_signal("INVENTORY_UPDATE")

func place_item(id):
	if selected_inventory == null: return
	selected_inventory.inventory[id] = selected_item
	selected_item = null
	SIGNAL_BUS.emit_signal("INVENTORY_UPDATE")

func swap_item(id, _texture):
	if selected_inventory == null: return
	var temp = selected_inventory.inventory[id]
	selected_inventory.inventory[id] = selected_item
	selected_item = temp
	SIGNAL_BUS.emit_signal("INVENTORY_UPDATE")

func insert_item(id, item, inventory=player_inventory):
	if inventory == null: return
	inventory.inventory[id] = item
	SIGNAL_BUS.emit_signal("INVENTORY_UPDATE")

func drop_item():
	if selected_item == null: return
	ITEM_REGISTRY.register_item(selected_item) # ensure registration
	var world_item = selected_item.world_item.instantiate()
	world_item.set_meta("guid", selected_item.guid)
	get_tree().current_scene.add_child(world_item)
	world_item.global_position = drop_point.global_position
	world_item.rotation_degrees = Vector3(-20, 0, 0)
	selected_item = null
	SIGNAL_BUS.emit_signal("INVENTORY_UPDATE")

func pickup_item(item_guid):
	var inventory_item = ITEM_REGISTRY.get_item(item_guid)
	insert_item(get_avaiable_slot(), inventory_item)

func get_avaiable_slot(inventory=player_inventory) -> int:
	for i in range(0, inventory.inventory.size()):
		if inventory.inventory[i] == null:
			return i
	
	return -1 #todo! implement full inventory
