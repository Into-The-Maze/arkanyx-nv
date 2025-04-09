extends SpringArm3D

@export var min_zoom = 1. 
@export var max_zoom = 5.
@export var enabled = true

func _process(_delta):
	if !enabled: return
	if Input.is_action_just_pressed("zoom_in"):
		spring_length = clampf(spring_length - .5, min_zoom, max_zoom)
	elif Input.is_action_just_pressed("zoom_out"):
		spring_length = clampf(spring_length + .5, min_zoom, max_zoom)