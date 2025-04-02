extends CanvasLayer

@export var target_stats: StatBlock
@onready var player: CharacterBody3D = $".."
@onready var container_l: VBoxContainer = $LeftContainer
@onready var container_r: VBoxContainer = $RightContainer

var stat_labels: Dictionary = {}
var local_debug_labels: Dictionary = {}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	if !self.visible:
		return
	if not player:
		return
	if player.stats:
		target_stats = player.stats
	else:
		return
	
	for stat_name in target_stats.base.keys():
		var base_val = target_stats.base.get(stat_name, 0.0)
		
		var flat_total: float = 0.0
		for source in target_stats.modifiers.keys():
			flat_total += target_stats.modifiers[source].flat.get(stat_name, 0.0)
		
		var mult_total: float = 0.0
		for source in target_stats.modifiers.keys():
			mult_total += target_stats.modifiers[source].mult.get(stat_name, 0.0)
		var effective_multiplier = 1.0 + mult_total
	
		if stat_labels.has(stat_name):
			stat_labels[stat_name].text = "%s = ( B %.2f + A %.2f ) * M %.2f" % [stat_name, base_val, flat_total, effective_multiplier]
		else:
			var new_label = Label.new()
			new_label.name = stat_name
			new_label.text = "%s = ( B %.2f + F ADD %.2f ) * M %.2f" % [stat_name, base_val, flat_total, effective_multiplier]
			new_label.add_theme_color_override("font_color", Color.GREEN)
			container_l.add_child(new_label)
			stat_labels[stat_name] = new_label
		
		var debug_info = {
		"jump_charge_timer": player.jump_charge_timer,
		"dodge_cooldown_timer": player.dodge_cooldown_timer,
		"dodge_penalty_timer": player.dodge_penalty_timer,
		"wall_hold_timer": player.wall_hold_timer,
		"is_jumping": player.is_jumping,
		"is_sprinting": player.is_sprinting,
		"is_dodging": player.is_dodging,
		"is_air_dodging": player.is_air_dodging,
		"is_wall_holding": player.is_wall_holding,
		"is_wall_dodging": player.is_wall_dodging,
		"velocity": player.velocity 
		}
		
		for key in debug_info.keys():
			var value = debug_info[key]
			if typeof(value) == TYPE_VECTOR3:
				value = "x%.2f, y%.2f, z%.2f" % [value.x, value.y, value.z]
			elif typeof(value) == TYPE_BOOL:
				value = str(value)
			elif typeof(value) in [TYPE_FLOAT, TYPE_INT]:
				value = "%.2f" % value
			
			var debug_string = "%s: %s" % [key, value]
			if local_debug_labels.has(key):
				local_debug_labels[key].text = debug_string
			else:
				var new_label = Label.new()
				new_label.name = key
				new_label.text = debug_string
				new_label.add_theme_color_override("font_color", Color.RED)
				new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
				container_r.add_child(new_label)
				local_debug_labels[key] = new_label
