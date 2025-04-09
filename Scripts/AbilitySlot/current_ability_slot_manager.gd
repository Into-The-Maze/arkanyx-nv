extends Node
class_name CurrentAbilitySlotManager

var current_slots: Array[AbilitySlot] = []

func _ready():
	SIGNAL_BUS.connect("GEAR_WEAPON_CHANGED", update_slots)

func update_slots(weapon):
	print_debug("update_slots")
	if weapon is Inventory_Item_Weapon:
		current_slots = weapon.instance_slots
	else:
		current_slots = []
	SIGNAL_BUS.emit_signal("WEAPON_SLOTS_UPDATED", current_slots)
