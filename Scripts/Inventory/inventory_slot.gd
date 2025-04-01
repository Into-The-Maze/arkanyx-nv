extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/Item
@onready var interact: Button = $Interact

var invcontroller

func _ready():
	invcontroller = get_parent().get_parent().get_parent()

func update(item: Inventory_Item):
	if !item:
		item_display.visible = false
		item_display.texture = null
	else:
		item_display.visible = true
		item_display.texture = item.icon

func _on_interact_button_down() -> void:
	if invcontroller.selected_item == null && item_display.texture != null: # ie if there is an item to pick up in our empty hand,
		var selected_item_id = select_item()
		SignalBus.emit_signal("INVENTORY_ITEM_SELECTED", selected_item_id, item_display.texture)
	elif invcontroller.selected_item != null && item_display.texture == null: # ie if we can insert into the slot
		var slot_id = insert_item()
		SignalBus.emit_signal("INVENTORY_ITEM_PLACED", slot_id)
	elif invcontroller.selected_item != null && item_display.texture != null: # ie if there are items we can swap
		pass

func select_item():
	return get_meta("Index")

func insert_item():
	return get_meta("Index")
