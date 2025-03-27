extends Resource

class_name Inventory

signal inventory_update

@export var inventory: Array[Inventory_Item]

func insert(item: Inventory_Item):
  for i in range(inventory.size()):
    if inventory[i] == null:
      inventory[i] = item
      inventory_update.emit()
      return
  print_debug("inventory full") # todo! decide what to do here