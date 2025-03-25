extends Node3D

@export var mouse_sensitivity: float = 0.005
@export_range(-90., 0., 0.1, "radians_as_degrees") var min_v_axis: float = -PI/2
@export_range(0., 90., 0.1, "radians_as_degrees") var max_v_axis: float = PI/4

@onready var spring_target: Node3D = $SpringTarget

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, min_v_axis, max_v_axis)
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = wrapf(rotation.y, 0, TAU)