extends Node

@export var should_menu_pause: bool = true

@onready var in_game_canvas: CanvasLayer = $".."/InGameUI

func _ready() -> void:
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		_toggle_menu()

func _toggle_menu():
	var menu_open = self.visible
	self.visible = not self.visible
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if menu_open else Input.MOUSE_MODE_VISIBLE
	if should_menu_pause:
		get_tree().paused = not menu_open
