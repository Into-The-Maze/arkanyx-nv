extends Node3D

@export var mouse_sensitivity: float = 0.005
@export_range(-90., 0., 0.1, "radians_as_degrees") var min_v_axis: float = -PI/2
@export_range(0., 90., 0.1, "radians_as_degrees") var max_v_axis: float = PI/4

var mouse_moves_camera: bool = true

func _ready():
	SIGNAL_BUS.connect("INVENTORY_OPENED", camera_off)
	SIGNAL_BUS.connect("INVENTORY_CLOSED", camera_on)

func _unhandled_input(event: InputEvent) -> void:
	if mouse_moves_camera:
		if event is InputEventMouseMotion:
			rotation.x -= event.relative.y * mouse_sensitivity
			rotation.x = clamp(rotation.x, min_v_axis, max_v_axis)
			rotation.y -= event.relative.x * mouse_sensitivity
			rotation.y = wrapf(rotation.y, 0, TAU)

func camera_off():
	mouse_moves_camera = false

func camera_on():
	mouse_moves_camera = true