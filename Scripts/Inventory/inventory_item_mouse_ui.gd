extends Control

@onready var selectedItemImage: Sprite2D = $SelectedItemImage

func _ready():
	SignalBus.connect("INVENTORY_ITEM_SELECTED", select_item.bind())
	SignalBus.connect("INVENTORY_ITEM_PLACED", insert_item.bind())

func _process(_delta):
	if selectedItemImage.texture != null:
		selectedItemImage.position = get_global_mouse_position()

func select_item(_id, item_display):
	selectedItemImage.texture = item_display

func insert_item(_id):
	selectedItemImage.texture = null
	