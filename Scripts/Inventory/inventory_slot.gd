extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/Item
@onready var interact: Button = $Interact

var current_item: Inventory_Item
var current_index: int
var inventory_container

func _ready():
	inventory_container = get_parent().get_parent().get_parent().get_parent()

func update(item: Inventory_Item, index: int):
	current_item = item
	current_index = index
	if !item:
		item_display.visible = false
		item_display.texture = null
	else:
		item_display.visible = true
		item_display.texture = item.icon

func _on_interact_button_down() -> void:
	var slot_id = get_meta("Index")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		# right click = inspect
		if current_item != null:
			SIGNAL_BUS.emit_signal("INVENTORY_ITEM_INSPECTED", current_item, get_global_mouse_position())
	else:
		# left click = pickup/place/swap
		if inventory_container.selected_item == null && item_display.texture != null: # ie if there is an item to pick up in our empty hand,
			SIGNAL_BUS.emit_signal("INVENTORY_ITEM_SELECTED", slot_id, item_display.texture)
		elif inventory_container.selected_item != null && item_display.texture == null: # ie if we can insert into the slot
			SIGNAL_BUS.emit_signal("INVENTORY_ITEM_PLACED", slot_id)
		elif inventory_container.selected_item != null && item_display.texture != null: # ie if there are items we can swap
			SIGNAL_BUS.emit_signal("INVENTORY_ITEM_SWAPPED", slot_id, item_display.texture)
