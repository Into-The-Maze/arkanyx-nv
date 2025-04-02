extends Control

@onready var debug_ui_button: Button = $DebugUIButton
@onready var debug_stats_ui: CanvasLayer = $"../.."/DebugStatsUI

func _ready() -> void:
	debug_ui_button.toggled.connect(_debug_ui_button_toggled)
	debug_stats_ui.visible = debug_ui_button.button_pressed

func _debug_ui_button_toggled(pressed: bool) -> void:
	debug_stats_ui.visible = pressed
