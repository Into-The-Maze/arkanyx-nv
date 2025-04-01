extends ProgressBar

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	modulate.a = max(0.1, pow(value/max_value, 0.5))
