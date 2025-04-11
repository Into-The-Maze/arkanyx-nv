extends Panel

@export var desc_set: LabelSettings
@export var name_set: LabelSettings
@export var weapon_desc_set: LabelSettings
@export var weapon_name_set: LabelSettings

@onready var v_box = $VBox
@onready var icon = $VBox/Icon_and_Name/Icon
@onready var name_label = $VBox/Icon_and_Name/Name
@onready var description_label = $VBox/Description

func show_item(item: Inventory_Item, pos: Vector2):
	
	if item is Inventory_Item_Weapon:
		construct_weapon_popup(item)
	else:
		construct_item_popup(item)
	
	size = v_box.get_minimum_size()
	global_position = pos + Vector2(128, -64)

func scale_texture_to_px(texture: Texture, size: int):
	if texture:
		var original_width = texture.get_width()
		var original_height = texture.get_height()
		var scale_factor = size / min(original_width, original_height)
		var new_width = original_width * scale_factor
		var new_height = original_height * scale_factor
		icon.custom_minimum_size = Vector2(new_width, new_height)
		icon.expand = true

func _on_close_pressed():
	queue_free()

func construct_weapon_popup(item: Inventory_Item):
	icon.texture = item.icon
	scale_texture_to_px(icon.texture, 96)
	name_label.text = item.name
	name_label.label_settings = weapon_name_set
	description_label.text = item.description
	description_label.label_settings = weapon_desc_set

func construct_item_popup(item: Inventory_Item):
	icon.texture = item.icon
	scale_texture_to_px(icon.texture, 64)
	name_label.text = item.name
	name_label.label_settings = name_set
	description_label.text = item.description
	description_label.label_settings = desc_set
