extends CharacterBody3D

@export var max_speed: float = 10.0
@export var acceleration: float = 30.0
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
	
	if direction != Vector3.ZERO:
		var target_velocity: Vector3 = direction * max_speed
		current_velocity = current_velocity.move_toward(target_velocity, acceleration * delta)
	else:
		current_velocity = current_velocity.move_toward(Vector3.ZERO, acceleration * delta)
		
	velocity = current_velocity
	move_and_slide()
