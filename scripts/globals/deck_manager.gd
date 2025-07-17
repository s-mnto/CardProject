extends Node

const RANKS: int = 15

var deck: Array[CardResource] = []

func _ready() -> void:
	_build_deck()
	
func _build_deck() -> void:
	deck.clear()
	for suit: CardResource.Suits in CardResource.Suits.values():
		for value: int in range(2, RANKS):
			var new_card: CardResource = CardResource.new()
			new_card.suit_type = suit
			new_card.value = value
			deck.append(new_card)
	deck.shuffle()
