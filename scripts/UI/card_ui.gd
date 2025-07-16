class_name CardUI extends Control

@onready var order_label: Label = $Texture/OrderLabel

var card_data: CardResource = null
var is_selected: bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_selected = not is_selected
			SignalBus.card_selected.emit(self)
