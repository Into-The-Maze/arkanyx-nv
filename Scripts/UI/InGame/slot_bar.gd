extends HBoxContainer
class_name SlotBar

func _ready():
	SignalBus.connect("WEAPON_SLOTS_UPDATED", update_slots)

func update_slots(slots: Array):
	
	print_debug("update_slots 2")
	for child in get_children():
		child.queue_free()

	for slot in slots:
		var slot_icon = TextureRect.new()
		slot_icon.texture = slot.slot_icon
		slot_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		slot_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot_icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot_icon.custom_minimum_size = Vector2(64, 64)
		add_child(slot_icon)
