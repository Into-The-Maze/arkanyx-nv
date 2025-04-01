extends Resource
class_name StatBlock

var base := {}
var modifiers := {}  # { source: { "flat": { stat_name: value, ... }, "mult": { stat_name: value, ... } } }

func _init() -> void:
	
	# basic movement
	base["max_speed"] = 4.0
	base["sprint_speed_multiplier"] = 1.75
	base["acceleration"] = 40.0
	
	# jumping
	base["gravity"] = 20.0
	base["max_jump_height"] = 3.0
	base["jump_charge_max_time"] = 1.0
	base["jump_deadzone"] = 0.15
	base["air_strafe_reduction_multiplier"] = 3.0
	base["high_jump_multiplier"] = 1.2
	
	# dodging
	base["dodge_speed_multiplier"] = 5.0
	base["dodge_cooldown"] = 2.0
	base["dodge_penalty_slowdown_multiplier"] = 0.3
	base["dodge_penalty_slowdown_duration"] = 0.5
	base["air_dodge_reduction_multiplier"] = 0.7
	
	# wall holding
	base["max_wall_hold_time"] = 1.0
	
	# fov
	base["base_fov"] = 70.0
	base["max_fov"] = 120.0
	base["fov_speed_threshold"] = 5.0
	base["fov_scale_factor"] = 1.75
	base["fov_smoothing"] = 4.0

func get_stat(stat_name: String) -> float:
	var base_val = base.get(stat_name, 0.0)
	var flat_total = 0.0
	var mult_total = 0.0
	for source in modifiers.keys():
		var mod = modifiers[source]
		flat_total += mod.flat.get(stat_name, 0.0)
		mult_total += mod.mult.get(stat_name, 0.0)
	return (base_val + flat_total) * (1.0 + mult_total)

func apply_modifier(source: String, flat: Dictionary, mult: Dictionary) -> void:
	if modifiers.has(source):
		# update the modifier if already exists
		modifiers[source]["flat"] = flat.duplicate(true)
		modifiers[source]["mult"] = mult.duplicate(true)
	else:
		# create a new modifier entry if it doesnt already exist
		modifiers[source] = {
			"flat": flat.duplicate(true),
			"mult": mult.duplicate(true)
		}

func remove_modifier(source: String) -> void:
	modifiers.erase(source)

func set_base(stat_name: String, value: float):
	base[stat_name] = value

func get_all_stats() -> Dictionary:
	var result := {}
	for stat_name in base.keys():
		result[stat_name] = get_stat(stat_name)
	return result
