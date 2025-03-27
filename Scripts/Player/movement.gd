extends CharacterBody3D

@export var max_speed: float = 6.0
@export var acceleration: float = 30.0
@export var gravity: float = 20
@export var max_jump_height: float = 3.0
@export var jump_charge_max_time: float = 0.5
@export var jump_deadzone: float = 0.15
@export var air_strafe_reduction_multiplier: float = 3

@onready var camera: Camera3D = $Pivot/Camera
@onready var jump_charge_bar: ProgressBar = $CanvasLayer/ProgressBar

var jump_charge_timer: float = 0.0
var is_jumping: bool = false

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if jump_charge_bar:
		jump_charge_bar.value = max(0, ((jump_charge_timer - jump_deadzone) / (jump_charge_max_time - jump_deadzone) * 100))

func _physics_process(delta: float) -> void:
	
	# MOVING
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
	var adjusted_acceleration = acceleration
	if not is_on_floor():
		adjusted_acceleration /= air_strafe_reduction_multiplier
	horizontal_velocity = horizontal_velocity.move_toward(target_horizontal_velocity, adjusted_acceleration * delta)
	current_velocity.x = horizontal_velocity.x
	current_velocity.z = horizontal_velocity.z
	
	# GRAVITY
	if not is_on_floor():
		current_velocity.y -= gravity * delta
		if is_jumping && current_velocity.y < 0:
			current_velocity.y -= gravity * delta
	else:
		current_velocity.y = 0
	
	# JUMPING
	if is_on_floor():
		is_jumping = false
		if Input.is_action_pressed("jump"):
			jump_charge_timer = min(jump_charge_timer + delta, jump_charge_max_time + jump_deadzone)
		elif Input.is_action_just_released("jump"):
			var multiplier = 0.5
			var adjusted_jump_timer = jump_charge_timer - jump_deadzone
			if adjusted_jump_timer > 0:
				multiplier += pow((adjusted_jump_timer / jump_charge_max_time - jump_deadzone), 2) * 0.5
			var jump_speed = sqrt(2 * gravity * (max_jump_height * multiplier))
			current_velocity.y = jump_speed
			is_jumping = true
			jump_charge_timer = 0.0
		else:
			jump_charge_timer = 0.0
	
	# APPLYING MOVEMENT
	print_debug(velocity)
	velocity = current_velocity
	move_and_slide()
