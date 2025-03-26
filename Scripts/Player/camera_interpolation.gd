extends Camera3D

@export var spring_target: Node3D
@export var camera_velocity: float = 1.

func _process(delta: float) -> void:
	position = lerp(position, spring_target.position, delta * camera_velocity)
