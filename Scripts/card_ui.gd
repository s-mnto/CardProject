class_name CardUI extends Control

@onready var texture: TextureRect = $Texture

var card_data: CardResource = null
var is_selected: bool = false
var tween: Tween

var _new_scale: Vector2 = Vector2(1.3, 1.3)
var _ease_time: float = 0.05
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_selected = not is_selected
		SignalBus.card_selected.emit(self)

func apply_backside_texture() -> void:
	texture.texture = load("res://Assets/Cards/card_back.png")

func apply_texture() -> void:
	var suit: String = CardResource.Suits.keys()[card_data.suit_type].to_lower()
	var rank: String = card_data._get_rank_values(card_data.value)
	texture.texture = load("res://Assets/Cards/card_%s_%s.png" % [suit, rank])

func disable_clickable() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", _new_scale, _ease_time)
	
func _on_mouse_exited() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ONE, _ease_time)
	
func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
