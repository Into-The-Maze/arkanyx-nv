extends Node3D

@export var equipment: Inventory
@export var inventory: Inventory 
@export var learned_abilities: LearnedAbilities

func collect(item):
  inventory.insert(item)
