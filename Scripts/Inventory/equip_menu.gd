extends CanvasLayer

@export var equipment: Inventory

### SLOT_ID ###
# 0 - HEAD    #
# 1 - CHEST   #
# 2 - WEAPON  #
# 3 - RING 1  #
# 4 - RING 2  #
###############

func _ready():
  SIGNALBUS.connect("INVENTORY_OPENED", open.bind())
  SIGNALBUS.connect("INVENTORY_CLOSED", close.bind())
  
  close()

func open():
  visible = true

func close():
  visible = false