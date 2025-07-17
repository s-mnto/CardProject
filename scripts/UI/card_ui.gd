class_name CardUI extends Control

@onready var order_label: Label = $Texture/OrderLabel
@onready var value_label: Label = $Texture/ValueLabel
@onready var texture: TextureRect = $Texture

var card_data: CardResource = null
var is_selected: bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_selected = not is_selected
			SignalBus.card_selected.emit(self)

func _apply_texture() -> void:
	var suit_string: String = CardResource.Suits.keys()[card_data.suit_type].to_lower()
	var rank_string: String = card_data._get_rank_values(card_data.value)
	var path: String = "res://assets/cards/card_%s_%s.png" % [suit_string, rank_string]
	texture.texture = load(path)

func _backside_texture() -> void:
	texture.texture = load("res://assets/cards/card_back.png")

func _disable_clickable() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
