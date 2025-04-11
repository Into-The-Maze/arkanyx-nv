extends Panel
class_name ItemDetailsPopup

@onready var mainVBox = $VBox
@onready var icon = $VBox/Icon_and_Name/Icon
@onready var name_label = $VBox/Icon_and_Name/Name
@onready var description_label = $VBox/Description
@onready var close_button = $Close

func _ready():
	close_button.connect("pressed", _on_close_button_pressed)

func show_item(item: Inventory_Item, position: Vector2):
	icon.texture = item.icon
	scale_texture_to_64px(icon.texture)
	
	name_label.text = item.name
	description_label.text = item.description
	description_label.minimum_size_changed
	
	mainVBox.queue_sort
	mainVBox.minimum_size_changed
	update_panel_size()

	position += Vector2(128, -64)
	global_position = position
	visible = true
	set_process_input(true)

func scale_texture_to_64px(texture: Texture):
	if texture:
		var original_width = texture.get_width()
		var original_height = texture.get_height()
		var scale_factor = 64.0 / min(original_width, original_height)
		var new_width = original_width * scale_factor
		var new_height = original_height * scale_factor
		icon.custom_minimum_size = Vector2(new_width, new_height)
		icon.expand = true

func update_panel_size():
	var size = mainVBox.get_minimum_size()
	custom_minimum_size = size
	position = global_position - custom_minimum_size / 2

func _on_close_button_pressed():
	visible = false
	set_process_input(false)
