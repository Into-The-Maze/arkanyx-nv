extends Sprite2D

func _ready():
	SignalBus.connect("INVENTORY_ITEM_SELECTED", select_item.bind())
	SignalBus.connect("INVENTORY_ITEM_PLACED", insert_item.bind())
	SignalBus.connect("INVENTORY_ITEM_SWAPPED", swap_item.bind())

func _process(_delta):
	if texture != null:
		position = get_global_mouse_position()

func select_item(_id, item_display):
	texture = item_display

func insert_item(_id):
	texture = null

func swap_item(_id, item_display):
	texture = item_display