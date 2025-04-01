extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/Item
@onready var interact: Button = $Interact

func update(item: Inventory_Item):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.icon

func _on_interact_button_down() -> void:
	var selected_item_id = select_item()
	SignalBus.emit_signal("INVENTORY_ITEM_SELECTED", selected_item_id, item_display)

func select_item():
	return get_meta("Index")
