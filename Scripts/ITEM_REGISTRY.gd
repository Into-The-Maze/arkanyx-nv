extends Node

var items = {}

func register_item(item: Inventory_Item):
	if not item.guid:
		item.guid = generate_guid()
	items[item.guid] = item
	
	if item is Inventory_Item_Weapon:
		if item.instance_slots.is_empty():
			item.generate_instance_slots()
			print_debug("Generated default slots for weapon: %s" % item.name)
	
	print_debug("Registered item {0} with GUID: {1}".format([item.name, item.guid]))

func get_item(guid: String) -> Inventory_Item:
	return items.get(guid)

func generate_guid() -> String:
	var uuid = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0, 9):
		uuid += "%02x" % rng.randi_range(0, 255)
	uuid += "-"
	for i in range(0, 5):
		uuid += "%02x" % rng.randi_range(0, 255)
	uuid += "-"
	for i in range(0, 5):
		uuid += "%02x" % rng.randi_range(0, 255)
	uuid += "-"
	for i in range(0, 5):
		uuid += "%02x" % rng.randi_range(0, 255)
	uuid += "-"
	for i in range(0, 13):
		uuid += "%02x" % rng.randi_range(0, 255)
	return uuid
