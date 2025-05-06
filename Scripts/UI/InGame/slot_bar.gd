extends HBoxContainer
class_name SlotBar

@onready var current_slot_scene = preload("res://Scenes/UI/CurrentSlot.tscn")

func _ready():
	SIGNAL_BUS.connect("WEAPON_SLOTS_UPDATED", update_slots)

func update_slots(slots: Array):

	for child in get_children():
		child.queue_free()

	for i in range(slots.size()):
		var slot = slots[i]
		var current_slot = current_slot_scene.instantiate()
		current_slot.set_slot(slot)
		current_slot.set_index(i)
		add_child(current_slot)
