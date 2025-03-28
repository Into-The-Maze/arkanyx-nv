extends Control

@onready var selectedItemImage: Sprite2D = $SelectedItemImage

var selectedItem: Inventory_Item

func _process(_delta):
	if selectedItemImage.texture != null:
		selectedItemImage.position = get_global_mouse_position()
	