extends Node

func _ready():
	SIGNALBUS.connect("INVENTORY_OPENED", free_mouse)
	SIGNALBUS.connect("INVENTORY_CLOSED", capture_mouse)
	SIGNALBUS.connect("MENU_OPENED", free_mouse)
	SIGNALBUS.connect("MENU_CLOSED", capture_mouse)

	capture_mouse()

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func free_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
