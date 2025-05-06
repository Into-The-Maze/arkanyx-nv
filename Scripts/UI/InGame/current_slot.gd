extends Control

@export var index: int
@export var slot: AbilitySlot

@export var label: Label
@export var icon: Sprite2D
@export var slotIcon: Sprite2D

func set_slot(s: AbilitySlot) -> void:
	slot = s
	if s.assigned_ability:
		icon.texture = s.assigned_ability.icon
	else:
		icon.texture = null
	slotIcon.texture = s.slot_icon

func set_index(i: int) -> void:
	index = i
	var events = InputMap.action_get_events("cast_slot_%d" % (i+1))
	for event in events:
		if event is InputEventKey:
			label.text = event.as_text_physical_keycode()
			return
	label.text = "error"
