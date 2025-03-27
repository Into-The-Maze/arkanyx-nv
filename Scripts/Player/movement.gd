extends CharacterBody3D

@export var max_speed: float = 8.0
@export var acceleration: float = 40.0
@export var gravity: float = 9.81
@onready var camera: Camera3D = $Pivot/Camera

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	var input_vector: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	input_vector = input_vector.normalized()
	
	var direction: Vector3 = input_vector.rotated(Vector3.UP, camera.global_rotation.y)
	var current_velocity: Vector3 = velocity
	
	var horizontal_velocity = Vector3(current_velocity.x, 0, current_velocity.z)
	var target_horizontal_velocity = direction * max_speed
	horizontal_velocity = horizontal_velocity.move_toward(target_horizontal_velocity, acceleration * delta)
	
	if not is_on_floor():
		current_velocity.y -= gravity * delta
	else:
		current_velocity.y = 0
	
	current_velocity.x = horizontal_velocity.x
	current_velocity.z = horizontal_velocity.z
	
	print_debug(velocity)
	velocity = current_velocity
	
	move_and_slide()
