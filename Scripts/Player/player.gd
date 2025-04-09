extends Node3D

@export var equipment: Inventory
@export var inventory: Inventory
@export var current_ability_slot_manager: CurrentAbilitySlotManager

func collect(item):
  inventory.insert(item)
