extends Control

@export var inventory_data: Inventory

@onready var background = $Inventory_Background
@onready var grid = $Inventory_Background/Grid

var is_open: bool

func _ready():
	close()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if is_open: close()
		else: open()

func open():
	is_open = true
	visible = true

func close():
	is_open = false
	visible = false

func create():
	var inv_size = len(inventory_data)
	for _i in inv_size:
		#todo!
		pass
		