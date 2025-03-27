extends CharacterBody3D

# MOVEMENT PARAMTERS
@export var max_speed: float = 4.0
@export var sprint_speed_multiplier: float = 1.75
@export var acceleration: float = 40.0

# JUMPING PARAMTERS
@export var gravity: float = 20
@export var max_jump_height: float = 3.0
@export var jump_charge_max_time: float = 1.0
@export var jump_deadzone: float = 0.15
@export var air_strafe_reduction_multiplier: float = 3.0
@export var high_jump_multiplier: float = 1.2

# DODGING PARAMTERS
@export var dodge_speed_multiplier: float = 5.0
@export var dodge_cooldown: float = 2.0
@export var dodge_penalty_slowdown_multiplier: float = 0.3
@export var dodge_penalty_slowdown_duration: float = 0.5
@export var air_dodge_reduction_multiplier: float = 0.7

# WALL HOLDING PARAMETERS
@export var max_wall_hold_time: float = 1.0

# REFERENCES
@onready var camera: Camera3D = $Pivot/Camera
@onready var jump_charge_bar: ProgressBar = $CanvasLayer/JumpChargeBar
@onready var dodge_cooldown_bar: ProgressBar = $CanvasLayer/DodgeCooldownBar
@onready var wall_hold_bar: ProgressBar = $CanvasLayer/WallHoldBar

var jump_charge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var dodge_penalty_timer: float = 0.0
var wall_hold_timer: float = 0.0
var is_jumping: bool = false
var is_sprinting: bool = false
var is_dodging: bool = false
var is_air_dodging: bool = false
var is_wall_holding: bool = false
var is_wall_dodging: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if jump_charge_bar:
		jump_charge_bar.value = max(0, ((jump_charge_timer - jump_deadzone) / (jump_charge_max_time - jump_deadzone) * jump_charge_bar.max_value))
	if dodge_cooldown_bar:
		dodge_cooldown_bar.value = max(0, (dodge_cooldown_timer / dodge_cooldown) * dodge_cooldown_bar.max_value)
	if wall_hold_bar:
		if is_wall_holding:
			wall_hold_bar.value = max(0, (1 - (wall_hold_timer / max_wall_hold_time)) * wall_hold_bar.max_value)
		else:
			wall_hold_bar.value = 0

func _physics_process(delta: float) -> void:
	
	# Adjust timers and flags
	if is_dodging:
		is_dodging = !is_on_floor()
	if is_air_dodging:
		is_air_dodging = !is_on_floor()
	if not is_dodging:
		dodge_cooldown_timer = max(dodge_cooldown_timer - delta, 0)
		dodge_penalty_timer = max(dodge_penalty_timer - delta, 0)
	if is_wall_holding:
		wall_hold_timer = min(wall_hold_timer + delta, max_wall_hold_time)
	if wall_hold_timer >= max_wall_hold_time:
		is_wall_holding = false
	if is_on_floor() && not is_wall_holding:
		wall_hold_timer = 0
	if is_wall_dodging:
		is_wall_dodging = !is_on_floor()
		is_wall_holding = false
	
	# MOVING
	var adjusted_max_speed = max_speed
	is_sprinting = false
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		adjusted_max_speed = max_speed * sprint_speed_multiplier
	if dodge_penalty_timer > 0:
		adjusted_max_speed = max_speed * dodge_penalty_slowdown_multiplier
	
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
	var target_horizontal_velocity = direction * adjusted_max_speed
	var adjusted_acceleration = acceleration
	if not is_on_floor():
		adjusted_acceleration /= air_strafe_reduction_multiplier
	horizontal_velocity = horizontal_velocity.move_toward(target_horizontal_velocity, adjusted_acceleration * delta)
	current_velocity.x = horizontal_velocity.x
	current_velocity.z = horizontal_velocity.z
	
	# GRAVITY
	if not is_on_floor() && not is_wall_holding:
		current_velocity.y -= gravity * delta
		if current_velocity.y < 0:
			current_velocity.y -= gravity * delta
	else:
		current_velocity.y = 0
	
	# JUMPING
	if is_on_floor() && not is_wall_holding:
		is_jumping = false
		if Input.is_action_pressed("jump"):
			jump_charge_timer = min(jump_charge_timer + delta, jump_charge_max_time + jump_deadzone)
		elif Input.is_action_just_released("jump"):
			var multiplier = 0.25
			var adjusted_jump_charge_timer: float = jump_charge_timer - jump_deadzone
			if adjusted_jump_charge_timer > 0:
				multiplier += pow((adjusted_jump_charge_timer / jump_charge_max_time - jump_deadzone), 2) * 0.75
			var jump_speed = sqrt(2 * gravity * (max_jump_height * multiplier))
			current_velocity.y = jump_speed
			is_jumping = true
			jump_charge_timer = 0.0
			
			# LONG JUMP
			if is_sprinting && abs(adjusted_jump_charge_timer - jump_charge_max_time) < 0.0001:
				var long_jump_direction: Vector3 = direction
				if long_jump_direction == Vector3.ZERO:
					long_jump_direction = (-camera.global_transform.basis.z).normalized()
				var long_jump_impulse = long_jump_direction * max_speed * dodge_speed_multiplier
				current_velocity.x = long_jump_impulse.x
				current_velocity.z = long_jump_impulse.z
			# HIGH JUMP
			if not is_sprinting:
				current_velocity.y *= high_jump_multiplier
		else:
			jump_charge_timer = 0.0
	
	# WALL HOLDING
	if is_on_wall() && not is_on_floor() && Input.is_action_pressed("jump") && not is_wall_dodging && (wall_hold_timer < max_wall_hold_time):
		is_wall_holding = true
		current_velocity = Vector3.ZERO
	else:
		is_wall_holding = false
	
	# DODGING 
	if Input.is_action_just_pressed("dodge") && dodge_cooldown_timer <= 0 && not is_wall_dodging:
		if direction == Vector3.ZERO:
			var current_horizontal = Vector3(current_velocity.x, 0, current_velocity.z)
			if current_horizontal.length() > 0:
				direction = current_horizontal.normalized()
			else:
				direction = (-camera.global_transform.basis.z).normalized()
		horizontal_velocity = direction * max_speed * dodge_speed_multiplier
		# AIR DODGING
		if not is_on_floor() && not is_wall_holding:
			horizontal_velocity *= air_dodge_reduction_multiplier
			is_air_dodging = true
		# WALL DODGING
		if is_wall_holding:
			is_wall_dodging = true
			var jump_speed = sqrt(2 * gravity * (max_jump_height))
			current_velocity.y = jump_speed
		current_velocity.x = horizontal_velocity.x
		current_velocity.z = horizontal_velocity.z
		is_dodging = true
		dodge_cooldown_timer = dodge_cooldown
		dodge_penalty_timer = dodge_penalty_slowdown_duration
	
	# APPLYING MOVEMENT
	velocity = current_velocity
	move_and_slide()
