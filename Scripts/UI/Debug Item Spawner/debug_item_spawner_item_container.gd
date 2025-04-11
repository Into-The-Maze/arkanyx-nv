extends CenterContainer

@onready var item_texture: Sprite2D = $ItemTexture

var item: Inventory_Item

func _ready():
	item_texture.texture = item.icon

func _on_spawn_button_down() -> void:
	print_debug("spawning: ", item.name)
	SIGNAL_BUS.emit_signal("DEBUG_INSERT_NEW_ITEM", item)
