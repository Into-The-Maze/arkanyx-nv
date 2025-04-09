extends Inventory_Item

class_name Inventory_Item_Weapon

@export var equip_icon: Texture2D
@export var default_slots: Array[AbilitySlot] = []

var instance_slots: Array[AbilitySlot] = []

func generate_instance_slots():
	instance_slots.clear()
	for slot in default_slots:
		instance_slots.append(slot.duplicate(true))
