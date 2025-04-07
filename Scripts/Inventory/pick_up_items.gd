extends Area3D

var items := []
var closest_item

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if closest_item != null:
			if not closest_item.get_meta("guid"):
				print_debug("Item without guid detected!")
				return
			SignalBus.emit_signal("NEARBY_ITEM_PICKUP", closest_item.get_meta("guid"))
			closest_item.queue_free()
		
func _on_body_entered(body: Node3D) -> void:
	items.append(body)
	update()

func _on_body_exited(body: Node3D) -> void:
	items.erase(body)
	update()

func update():
	if items.is_empty():
		closest_item = null
		SignalBus.emit_signal("NEARBY_ITEM_EMPTY")
		return
	SignalBus.emit_signal("NEARBY_ITEM_DETECTED", get_closest_item())

func get_closest_item() -> Node3D:
	if items.is_empty():
		closest_item = null
		return null
	var closest = null
	var closest_dist = INF
	for item in items:
		var dist = global_position.distance_to(item.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = item
	
	closest_item = closest
	return closest