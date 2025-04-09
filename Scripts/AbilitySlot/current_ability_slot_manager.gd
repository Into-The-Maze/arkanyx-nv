extends Node
class_name CurrentAbilitySlotManager

var current_slots: Array[AbilitySlot] = []

func _ready():
	SignalBus.connect("GEAR_WEAPON_CHANGED", update_slots)

func update_slots(weapon):
	print_debug("update_slots")
	if weapon is Inventory_Item_Weapon:
		current_slots = weapon.instance_slots
	else:
		current_slots = []
	SignalBus.emit_signal("WEAPON_SLOTS_UPDATED", current_slots)
