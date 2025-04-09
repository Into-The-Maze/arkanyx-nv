extends HBoxContainer
class_name SlotBar

func _ready():
	SignalBus.connect("WEAPON_SLOTS_UPDATED", update_slots)

func update_slots(slots: Array):

	# clear existing icons
	for child in get_children():
		child.queue_free()

	for slot in slots:
		# wrapper to hold both textures
		var container = Control.new()
		container.custom_minimum_size = Vector2(64, 64)
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# ability icon
		if slot.assigned_ability != null and slot.assigned_ability.icon != null:
			var ability_icon = TextureRect.new()
			ability_icon.texture = slot.assigned_ability.icon
			ability_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			ability_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			ability_icon.custom_minimum_size = Vector2(64, 64)
			ability_icon.z_index = 0
			container.add_child(ability_icon)

		# slot icon (in front)
		var slot_icon = TextureRect.new()
		slot_icon.texture = slot.slot_icon
		slot_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		slot_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot_icon.custom_minimum_size = Vector2(64, 64)
		slot_icon.z_index = 1
		container.add_child(slot_icon)

		add_child(container)
