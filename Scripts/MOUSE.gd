extends Node

func _ready():
	SignalBus.connect("INVENTORY_OPENED", free_mouse)
	SignalBus.connect("INVENTORY_CLOSED", capture_mouse)
	SignalBus.connect("MENU_OPENED", free_mouse)
	SignalBus.connect("MENU_CLOSED", capture_mouse)

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func free_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE