extends Node

@export var should_menu_pause: bool = true
@onready var in_game_ui: CanvasLayer = $".."/InGameUI

func _ready() -> void:
	self.visible = false 

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		_toggle_menu()

func _toggle_menu():
	var menu_open = not self.visible
	self.visible = menu_open
	
	if menu_open:
		SIGNALBUS.emit_signal("MENU_OPENED")
	else:
		SIGNALBUS.emit_signal("MENU_CLOSED")

	if should_menu_pause && menu_open:
		get_tree().paused = true
	else:
		get_tree().paused = false
