extends Panel

@onready var v_box = $VBox
@onready var icon = $VBox/Icon_and_Name/Icon
@onready var name_label = $VBox/Icon_and_Name/Name
@onready var description_label = $VBox/Description

func show_item(item: Inventory_Item, pos: Vector2):
	icon.texture = item.icon
	scale_texture_to_64px(icon.texture)
	name_label.text = item.name
	description_label.text = item.description
	size = v_box.get_minimum_size()
	global_position = pos

func scale_texture_to_64px(texture: Texture):
	if texture:
		var original_width = texture.get_width()
		var original_height = texture.get_height()
		var scale_factor = 64.0 / min(original_width, original_height)
		var new_width = original_width * scale_factor
		var new_height = original_height * scale_factor
		icon.custom_minimum_size = Vector2(new_width, new_height)
		icon.expand = true

func _on_close_pressed():
	queue_free()
