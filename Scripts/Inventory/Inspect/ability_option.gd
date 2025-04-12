extends Panel

@export var icon: Sprite2D
@export var ability: Ability

func set_ability(newAbility: Ability):
	if !newAbility:	
		ability = null
		icon.texture = preload("res://Assets/Temporary/inventory_drop_item.png")
	else:
		ability = newAbility
		icon.texture = ability.icon

func _on_button_pressed() -> void:
	if get_parent().get_parent().has_method("selected_ability"):
		get_parent().get_parent().selected_ability(ability)
