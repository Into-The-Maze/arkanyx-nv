extends CharacterBody3D

# STATS
const STATS_FILE_PATH := "user://player_stats.tres"
var stats: StatBlock

# REFERENCES
@onready var camera: Camera3D = $Pivot/Camera
@onready var in_game_canvas: CanvasLayer = $InGameUI
@onready var jump_charge_bar: ProgressBar = $InGameUI/JumpChargeBar
@onready var dodge_cooldown_bar: ProgressBar = $InGameUI/DodgeCooldownBar
@onready var wall_hold_bar: ProgressBar = $InGameUI/WallHoldBar

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
	stats = load_player_stats()
	in_game_canvas.visible = true
 
func _process(_delta: float) -> void:
	if jump_charge_bar:
		jump_charge_bar.value = max(0, ((jump_charge_timer - stats.get_stat("jump_deadzone")) / (stats.get_stat("jump_charge_max_time") - stats.get_stat("jump_deadzone")) * jump_charge_bar.max_value))
	if dodge_cooldown_bar:
		dodge_cooldown_bar.value = max(0, (dodge_cooldown_timer / stats.get_stat("dodge_cooldown")) * dodge_cooldown_bar.max_value)
	if wall_hold_bar:
		if is_wall_holding:
			wall_hold_bar.value = max(0, (1 - (wall_hold_timer / stats.get_stat("max_wall_hold_time"))) * wall_hold_bar.max_value)
		else:
			wall_hold_bar.value = 0

func _physics_process(delta: float) -> void:
	
	update_timers_and_flags(delta)
	
	var input_vector: Vector3 = get_input_vector()
	var direction: Vector3 = input_vector.rotated(Vector3.UP, camera.global_rotation.y)
	var current_velocity: Vector3 = velocity
	
	current_velocity = process_movement(delta, current_velocity, direction)
	current_velocity = process_gravity(delta, current_velocity)
	current_velocity = process_jumping(delta, current_velocity, direction)
	current_velocity = process_wall_holding(delta, current_velocity)
	current_velocity = process_dodging(delta, current_velocity, direction)
	
	var horizontal_velocity: Vector3 = Vector3(current_velocity.x, 0, current_velocity.z)
	apply_dynamic_fov(delta, horizontal_velocity)
	
	velocity = current_velocity
	move_and_slide()

func update_timers_and_flags(delta: float) -> void:
	if is_dodging:
		is_dodging = !is_on_floor()
	if is_air_dodging:
		is_air_dodging = !is_on_floor()
	if is_wall_dodging:
		is_dodging = false
	if not is_dodging:
		dodge_cooldown_timer = max(dodge_cooldown_timer - delta, 0)
		dodge_penalty_timer = max(dodge_penalty_timer - delta, 0)
	if is_wall_holding:
		wall_hold_timer = min(wall_hold_timer + delta, stats.get_stat("max_wall_hold_time"))
	if wall_hold_timer >= stats.get_stat("max_wall_hold_time"):
		is_wall_holding = false
	if is_on_floor() and not is_wall_holding:
		wall_hold_timer = 0
	if is_wall_dodging:
		is_wall_dodging = !is_on_floor()
		is_wall_holding = false

func get_input_vector() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	return input_vector.normalized()

func process_movement(delta: float, current_velocity: Vector3, direction: Vector3) -> Vector3:
	var adjusted_max_speed = stats.get_stat("max_speed")
	is_sprinting = false
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		adjusted_max_speed = stats.get_stat("max_speed") * stats.get_stat("sprint_speed_multiplier")
	if dodge_penalty_timer > 0:
		adjusted_max_speed = stats.get_stat("max_speed") * stats.get_stat("dodge_penalty_slowdown_multiplier")
	
	var target_horizontal_velocity: Vector3 = direction * adjusted_max_speed
	var horizontal_velocity: Vector3 = Vector3(current_velocity.x, 0, current_velocity.z)
	var adjusted_acceleration = stats.get_stat("acceleration")
	if not is_on_floor():
		adjusted_acceleration /= stats.get_stat("air_strafe_reduction_multiplier")
	horizontal_velocity = horizontal_velocity.move_toward(target_horizontal_velocity, adjusted_acceleration * delta)
	current_velocity.x = horizontal_velocity.x
	current_velocity.z = horizontal_velocity.z
	return current_velocity

func process_gravity(delta: float, current_velocity: Vector3) -> Vector3:
	if not is_on_floor() and not is_wall_holding:
		current_velocity.y -= stats.get_stat("gravity") * delta
		if current_velocity.y < 0:
			current_velocity.y -= stats.get_stat("gravity") * delta
	else:
		current_velocity.y = 0
	return current_velocity

func process_jumping(delta: float, current_velocity: Vector3, direction: Vector3) -> Vector3:
	if is_on_floor() and not is_wall_holding:
		is_jumping = false
		if Input.is_action_pressed("jump"):
			jump_charge_timer = min(jump_charge_timer + delta, stats.get_stat("jump_charge_max_time") + stats.get_stat("jump_deadzone"))
		elif Input.is_action_just_released("jump"):
			var multiplier = 0.25
			var adjusted_jump_charge_timer: float = jump_charge_timer - stats.get_stat("jump_deadzone")
			if adjusted_jump_charge_timer > 0:
				multiplier += pow((adjusted_jump_charge_timer / stats.get_stat("jump_charge_max_time") - stats.get_stat("jump_deadzone")), 2) * 0.75
			var jump_speed = sqrt(2 * stats.get_stat("gravity") * (stats.get_stat("max_jump_height") * multiplier))
			current_velocity.y = jump_speed
			is_jumping = true
			jump_charge_timer = 0.0
			
			# LONG JUMP
			if is_sprinting and abs(adjusted_jump_charge_timer - stats.get_stat("jump_charge_max_time")) < 0.0001:
				var long_jump_direction: Vector3 = direction
				if long_jump_direction == Vector3.ZERO:
					long_jump_direction = (-camera.global_transform.basis.z).normalized()
				var long_jump_impulse = long_jump_direction * stats.get_stat("max_speed") * stats.get_stat("dodge_speed_multiplier")
				current_velocity.x = long_jump_impulse.x
				current_velocity.z = long_jump_impulse.z
			# HIGH JUMP
			if not is_sprinting:
				current_velocity.y *= stats.get_stat("high_jump_multiplier")
		else:
			jump_charge_timer = 0.0
	return current_velocity

func process_wall_holding(_delta: float, current_velocity: Vector3) -> Vector3:
	if is_on_wall() and not is_on_floor() and Input.is_action_pressed("jump") and not is_wall_dodging and (wall_hold_timer < stats.get_stat("max_wall_hold_time")) and not is_air_dodging:
		is_wall_holding = true
		current_velocity = Vector3.ZERO
	else:
		is_wall_holding = false
	return current_velocity

func process_dodging(_delta: float, current_velocity: Vector3, direction: Vector3) -> Vector3:
	if Input.is_action_just_pressed("dodge") and dodge_cooldown_timer <= 0 and not is_wall_dodging:
		if direction == Vector3.ZERO:
			var current_horizontal: Vector3 = Vector3(current_velocity.x, 0, current_velocity.z)
			if current_horizontal.length() > 0:
				direction = current_horizontal.normalized()
			else:
				direction = (-camera.global_transform.basis.z).normalized()
		var horizontal_velocity: Vector3 = direction * stats.get_stat("max_speed") * stats.get_stat("dodge_speed_multiplier")
		# AIR DODGING
		if not is_on_floor() and not is_wall_holding:
			horizontal_velocity *= stats.get_stat("air_dodge_reduction_multiplier")
			is_air_dodging = true
		# WALL DODGING
		if is_wall_holding:
			is_wall_dodging = true
			var jump_speed = sqrt(2 * stats.get_stat("gravity") * (stats.get_stat("max_jump_height")))
			current_velocity.y = jump_speed
		current_velocity.x = horizontal_velocity.x
		current_velocity.z = horizontal_velocity.z
		is_dodging = true
		dodge_cooldown_timer = stats.get_stat("dodge_cooldown")
		dodge_penalty_timer = stats.get_stat("dodge_penalty_slowdown_duration")
	return current_velocity

func apply_dynamic_fov(delta: float, horizontal_velocity: Vector3) -> void:
	var speed = horizontal_velocity.length()
	var target_fov: float = stats.get_stat("base_fov")
	if speed > stats.get_stat("fov_speed_threshold"):
		var excess_speed = speed - stats.get_stat("fov_speed_threshold")
		target_fov = stats.get_stat("base_fov") + (excess_speed * stats.get_stat("fov_scale_factor"))
		target_fov = clamp(target_fov, stats.get_stat("base_fov"), stats.get_stat("max_fov"))
	camera.fov = lerp(camera.fov, target_fov, delta * stats.get_stat("fov_smoothing"))

func load_player_stats() -> StatBlock:
	if ResourceLoader.exists(STATS_FILE_PATH):
		var loaded_stats = ResourceLoader.load(STATS_FILE_PATH)
		if loaded_stats is StatBlock:
			return loaded_stats
		else:
			push_warning("Can't load players StatBlock, creating a new one.")
	var new_stats = StatBlock.new()
	save_player_stats(new_stats)
	return new_stats

func save_player_stats(new_stats) -> void:
	var err = ResourceSaver.save(new_stats, STATS_FILE_PATH)
	if err != OK:
		push_error("Failed to save player stats: %s" % err)