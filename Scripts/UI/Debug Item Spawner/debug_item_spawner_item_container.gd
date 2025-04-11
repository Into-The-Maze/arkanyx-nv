extends CenterContainer

@onready var item_texture = $ItemTexture

var item: Inventory_Item

func _ready():
	item_texture = item.icon

func _on_spawn_button_down() -> void:
	SIGNAL_BUS.emit_signal("DEBUG_INSERT_NEW_ITEM", item)
