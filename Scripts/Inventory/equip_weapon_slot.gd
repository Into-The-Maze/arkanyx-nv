extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/Item
@onready var interact: Button = $Interact

var inventory_container
var equipment

const slot_id = 2

func _ready():
	SIGNAL_BUS.connect("INVENTORY_UPDATE", update.bind())
	inventory_container = get_parent().get_parent().get_parent()
	equipment = get_parent().get_parent().equipment.inventory

func update():
	var item = equipment[slot_id]
	if !item:
		item_display.visible = false
		item_display.texture = null
	else:
		item_display.visible = true
		item_display.texture = item.equip_icon

func _on_interact_button_down() -> void:
	if inventory_container.selected_item && inventory_container.selected_item is not Inventory_Item_Weapon: return

	if inventory_container.selected_item == null && item_display.texture != null: # ie if there is an item to pick up in our empty hand,
		SIGNAL_BUS.emit_signal("INVENTORY_ITEM_SELECTED", slot_id, equipment[slot_id].icon)
	elif inventory_container.selected_item != null && item_display.texture == null: # ie if we can insert into the slot
		SIGNAL_BUS.emit_signal("INVENTORY_ITEM_PLACED", slot_id)
	elif inventory_container.selected_item != null && item_display.texture != null: # ie if there are items we can swap
		SignalBus.emit_signal("INVENTORY_ITEM_SWAPPED", slot_id, equipment[slot_id].icon)
	else:
		return
	SignalBus.emit_signal("GEAR_WEAPON_CHANGED", equipment[slot_id])
	print_debug("GEAR_WEAPON_CHANGED")
