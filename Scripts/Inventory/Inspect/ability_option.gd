extends Panel

@export var icon: Sprite2D

func set_ability(ability: Ability):
	icon.texture = ability.icon
