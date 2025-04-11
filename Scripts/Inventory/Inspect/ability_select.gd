extends HBoxContainer

func _ready() -> void:
	self.visible = false

func display_slots(weapon: Inventory_Item_Weapon):
	
	var slots: Array = weapon.instance_slots
	var selectable_slot = preload("res://Scenes/Inventory/Inspect/ability_slot_selectable.tscn")
	
	for slot in slots:
		var new_slot = selectable_slot.instantiate()
		new_slot.set_slot(slot)
		add_child(new_slot)
	
	self.visible = true
