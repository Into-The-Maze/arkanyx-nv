extends HSlider

@onready var valueText = $Value
	
func _ready() -> void:
	valueText.text = str(self.value).pad_decimals(1)
	
func _value_changed(new_value: float) -> void:
	valueText.text = str(self.value).pad_decimals(1)
