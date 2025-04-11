extends Panel

@onready var parent: HBoxContainer = $".."
@export var ability_icon: Sprite2D
@export var slot_icon: Sprite2D
@export var abilities_grid: GridContainer

@export var learned_abilities: LearnedAbilities

var slot: AbilitySlot

func set_slot(newSlot: AbilitySlot):
	slot = newSlot
	slot_icon.texture = slot.slot_icon
	if slot.assigned_ability:
		ability_icon.texture = slot.assigned_ability.icon

func _on_button_pressed() -> void:
	var option: PackedScene = preload("res://Scenes/Inventory/Inspect/ability_option.tscn")
	for ability_slot_selectable in parent.get_children():
		if ability_slot_selectable.has_method("clear_options"):
			ability_slot_selectable.clear_options()
	
	for ability in learned_abilities.abilities:
		var new_option = option.instantiate()
		new_option.set_ability(ability)
		abilities_grid.add_child(new_option)
	abilities_grid.visible = true

func clear_options():
	for child in abilities_grid.get_children():
		child.queue_free()
