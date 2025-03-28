extends Control

@export var menu_should_pause: bool = true
@export var max_speed: float = 1.0

@onready var menu_should_pause_button := $MenuShouldPauseButton
@onready var speed_slider := $SpeedSlider

func _ready() -> void:
	menu_should_pause_button.toggled.connect(_menu_should_pause_button_toggled)
	speed_slider.value_changed.connect(_speed_slider_changed)
	menu_should_pause_button.button_pressed = menu_should_pause
	speed_slider.value = max_speed

func _menu_should_pause_button_toggled(pressed: bool) -> void:
	menu_should_pause = pressed

func _speed_slider_changed(value: float) -> void:
	max_speed = value
