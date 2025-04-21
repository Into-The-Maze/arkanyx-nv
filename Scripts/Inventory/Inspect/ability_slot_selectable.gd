extends Panel

@export var ability_icon: Sprite2D
@export var slot_icon: Sprite2D
@export var abilities_grid: GridContainer

@export var learned_abilities: LearnedAbilities

var slot: AbilitySlot

func _ready():
	abilities_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_slot(newSlot: AbilitySlot):
	slot = newSlot
	slot_icon.texture = slot.slot_icon
	if slot.assigned_ability:
		ability_icon.texture = slot.assigned_ability.icon
	else:
		ability_icon.texture = null

func _on_button_pressed() -> void:
	var option: PackedScene = preload("res://Scenes/Inventory/Inspect/ability_option.tscn")
	for child in get_parent().get_children():
		if child.has_method("clear_options"):
			child.clear_options()
	
	var empty_option = option.instantiate()
	empty_option.set_ability(null)
	abilities_grid.add_child(empty_option)
	
	for ability in learned_abilities.abilities:
		if ability.type == slot.slot_type or slot.slot_type == G.AbilityType.NONE:
			var new_option = option.instantiate()
			new_option.set_ability(ability)
			abilities_grid.add_child(new_option)
	
	abilities_grid.visible = true
	abilities_grid.mouse_filter = Control.MOUSE_FILTER_PASS

func clear_options():
	for child in abilities_grid.get_children():
		child.queue_free()
	abilities_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE

func selected_ability(selected: Ability):
	if selected:
		slot.assigned_ability = selected
	else:
		slot.assigned_ability = null
	clear_options()
	set_slot(slot)
