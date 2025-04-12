extends Panel

@export var icon: Sprite2D
@export var ability: Ability
@export var button: Button

func set_ability(newAbility: Ability):
	if !newAbility:	
		ability = null
		icon.texture = preload("res://Abilities/deselect.png")
		button.tooltip_text = "Remove the selected ability."
	else:
		ability = newAbility
		icon.texture = ability.icon
		button.tooltip_text = ability.description

func _on_button_pressed() -> void:
	if get_parent().get_parent().has_method("selected_ability"):
		get_parent().get_parent().selected_ability(ability)
