class_name CardUI extends Control

@onready var texture: TextureRect = $Texture

var card_data: CardResource = null
var is_selected: bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_selected = not is_selected
		SignalBus.card_selected.emit(self)

func _apply_texture() -> void:
	var suit: String = CardResource.Suits.keys()[card_data.suit_type].to_lower()
	var rank: String = card_data._get_rank_values(card_data.value)
	texture.texture = load("res://assets/cards/card_%s_%s.png" % [suit, rank])

func _disable_clickable() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
