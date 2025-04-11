extends GridContainer

@onready var items: Array[Inventory_Item] = $".."/"..".spawnable_items

func _ready() -> void:
	for item in items:
		var panel = preload("res://Scenes/Debug Item Spawner UI/debug_item_spawner_item_container.tscn")
		var node = panel.instantiate()
		node.item = item
		add_child(node)
		
