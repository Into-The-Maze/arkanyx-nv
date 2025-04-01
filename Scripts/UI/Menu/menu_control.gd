extends Control

@export var menu_should_pause: bool = true
@export var max_speed: float = 4.0
@export var acceleration: float = 40.0

@onready var menu_should_pause_button := $MenuShouldPauseButton
@onready var speed_slider := $SpeedSlider
@onready var acceleration_slider := $AccelerationSlider

func _ready() -> void:
	menu_should_pause_button.toggled.connect(_menu_should_pause_button_toggled)
	speed_slider.value_changed.connect(_speed_slider_changed)
	acceleration_slider.value_changed.connect(_acceleration_slider_changed)
	menu_should_pause_button.button_pressed = menu_should_pause
	speed_slider.value = max_speed
	acceleration_slider.value = acceleration

func _menu_should_pause_button_toggled(pressed: bool) -> void:
	menu_should_pause = pressed

func _speed_slider_changed(new_max_speed: float) -> void:
	max_speed = new_max_speed
	SignalBus.emit_signal("MENU_MAX_SPEED_CHANGED", max_speed)

func _acceleration_slider_changed(new_acceleration: float) -> void:
	acceleration = new_acceleration
	SignalBus.emit_signal("MENU_ACCELERATION_CHANGED", acceleration)
