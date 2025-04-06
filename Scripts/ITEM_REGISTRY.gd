extends Node

var items = {}

func register_item(item: Inventory_Item):
	if not item.guid:
		item.guid = generate_guid()
	items[item.guid] = item

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

