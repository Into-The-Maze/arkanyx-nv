extends Control

@export var max_one_line_grid_size: int = 10
@export var background_margin_size = 12
@export var inventory_data: Inventory

@onready var background = $Inventory_Background
@onready var grid = $Inventory_Background/Grid

var slots: Array[Node]

func _ready():
	SignalBus.connect("INVENTORY_UPDATE", update)
	SignalBus.connect("INVENTORY_OPENED", open)
	SignalBus.connect("INVENTORY_CLOSED", close)

	create()
	update()

func _on_mouse_entered() -> void:
	SignalBus.emit_signal("INVENTORY_SELECTED", inventory_data)

func open():
	visible = true

func close():
	visible = false

func update():
	for i in min(inventory_data.inventory.size(), slots.size()):
		slots[i].update(inventory_data.inventory[i])

func create():
	var inv_size = inventory_data.inventory.size()
	if inv_size <= max_one_line_grid_size:
		grid.columns = inv_size
	else:
		# compute factor pairs
		var factor_pairs = []
		var lim = sqrt(inv_size)
		for i in range(1, lim + 1):
			var div = float(inv_size) / i # hate this language sometimes
			var div_i: int = floor(div)
			if div == div_i:
				factor_pairs.append([div,i])
		# find pair with lowest difference
		var best_pair = factor_pairs[0]
		var min_diff = abs(best_pair[0] - best_pair[1])
		for pair in factor_pairs:
			var diff = abs(pair[0] - pair[1])
			if diff < min_diff:
				min_diff = diff
				best_pair = pair
		grid.columns = int(best_pair[0])

	for i in inv_size:
		var slot = preload("res://Scenes/Inventory/inventory_slot.tscn").instantiate()
		slot.set_meta("Index", i)
		grid.add_child(slot)
	
	slots = grid.get_children()
	
	background.size.x = background_margin_size + grid.size.x # updates grid size 

	background.size.y = background_margin_size + grid.size.y
	background.size.x = background_margin_size + grid.size.x
	background.position.x -= background.size.x / 2
	background.position.y -= background.size.y / 2
