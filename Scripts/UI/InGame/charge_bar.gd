extends ProgressBar

var fill_stylebox

func _ready() -> void:
	fill_stylebox = self.get_theme_stylebox("fill")

func _process(delta: float) -> void:
	modulate.a = max(0.1, value/max_value)
	if fill_stylebox is StyleBoxFlat:
		var style = fill_stylebox as StyleBoxFlat
		var hsv = style.bg_color
		hsv.s = 0.2
		if abs(max_value - value) < 0.001:
			hsv.s = 1
		style.bg_color = Color.from_hsv(hsv.h, hsv.s, hsv.v, hsv.a)
