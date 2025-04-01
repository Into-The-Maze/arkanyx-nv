extends CanvasLayer

@export var target_stats: StatBlock
@onready var player: CharacterBody3D = $".."
@onready var container: VBoxContainer = $Container

var stat_labels: Dictionary = {}

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
			stat_labels[stat_name].text = "%s = ( BASE %.2f + FLAT ADD %.2f ) * MULTIPLIER %.2f" % [stat_name, base_val, flat_total, effective_multiplier]
		else:
			var new_label = Label.new()
			new_label.name = stat_name
			new_label.text = "%s = ( BASE %.2f + FLAT ADD %.2f ) * MULTIPLIER %.2f" % [stat_name, base_val, flat_total, effective_multiplier]
			new_label.add_theme_color_override("font_color", Color.GREEN)
			container.add_child(new_label)
			stat_labels[stat_name] = new_label
