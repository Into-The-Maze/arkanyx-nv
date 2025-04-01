extends Control

@onready var selectedItemImage: Sprite2D = $SelectedItemImage

var selectedItem: Inventory_Item

func _ready():
	SignalBus.connect("INVENTORY_ITEM_SELECTED", select_item)

func _process(_delta):
	if selectedItemImage.texture != null:
		selectedItemImage.position = get_global_mouse_position()

func select_item(_id, item_display):
	selectedItemImage.texture = item_display
	
