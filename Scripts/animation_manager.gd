class_name AnimationManager extends Node

var tween: Tween
var animation_timer: float = 0.32

func delete_card_animation(card: CardUI) -> void:
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(card, "modulate", Color.ORANGE_RED, animation_timer)
	tween.tween_property(card, "scale", Vector2(2.0, 2.0), animation_timer)
	tween.tween_property(card, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(card.queue_free)

func redraw_animation(card: CardUI) -> void:
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card, "position", Vector2(300, card.position.y), 1.2)
	tween.tween_callback(card.queue_free)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
