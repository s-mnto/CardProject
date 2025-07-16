extends Node

const RANKS: int = 15

var deck: Array[CardResource]

func _ready() -> void:
	if deck.size() == 0:
		_build_deck()
		deck.shuffle()
	else:
		print("Deck is empty")

func _build_deck() -> void:
	deck.clear()
	for suit: CardResource.Suits in CardResource.Suits.values():
		for value: int in range(2, RANKS):
			var new_card: CardResource = CardResource.new()
			new_card.suit_type = suit
			new_card.value = value
			deck.append(new_card)
	print(deck.size())
