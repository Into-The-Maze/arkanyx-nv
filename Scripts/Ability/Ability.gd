extends Resource
class_name Ability

@export var ability_name: String
@export var description: String
@export var icon: Texture2D
@export var type: G.AbilityType = G.AbilityType.NONE
@export var cooldown: float

func activate(user, target = null):
	print("Activating: ", ability_name)
