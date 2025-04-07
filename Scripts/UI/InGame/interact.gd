extends RichTextLabel

func _ready():
	SignalBus.connect("NEARBY_ITEM_DETECTED", pick_up_item_on.bind())
	SignalBus.connect("NEARBY_ITEM_EMPTY", pick_up_item_off.bind())

func pick_up_item_on(item):
	var guid = item.get_meta("guid")
	if not guid: return
	var item_data = ITEM_REGISTRY.get_item(guid)
	text = "Press [{0}] to pick up {1}".format([get_key("interact"), item_data.name])

func pick_up_item_off():
	text = ""

func get_key(action: StringName):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)
	return "?"