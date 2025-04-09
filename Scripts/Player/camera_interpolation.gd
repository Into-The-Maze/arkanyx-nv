extends Camera3D

@export var spring_target: Node3D
@export var camera_velocity: float = 1.

@onready var pivot = $".."

func _process(delta: float) -> void:
	if pivot.position.distance_to(position) >= pivot.position.distance_to(spring_target.position):
		position = spring_target.position
		return

	position = lerp(position, spring_target.position, delta * camera_velocity)
