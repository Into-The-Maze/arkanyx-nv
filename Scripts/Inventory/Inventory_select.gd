extends GridContainer

var previous_hovering := false

func _process(_delta):
	var local_mouse_pos := get_local_mouse_position()
	var hovering := Rect2(Vector2(), size).has_point(local_mouse_pos)
	
	if hovering != previous_hovering && hovering:
		SIGNAL_BUS.emit_signal("INVENTORY_SELECTED", $".."/"..".inventory_data)
		previous_hovering = hovering
	elif hovering != previous_hovering && !hovering:
		SIGNAL_BUS.emit_signal("INVENTORY_DESELECTED")

	previous_hovering = hovering