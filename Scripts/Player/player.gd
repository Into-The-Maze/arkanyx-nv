extends Node3D

# we can have player metadata and stuff here?

@export var inventory: Inventory

func collect(item):
  inventory.insert(item)