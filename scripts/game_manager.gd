class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://scenes/card_ui.tscn")
const TOTAL_CARDS: int = 5

@onready var player_container: HBoxContainer = $Player
@onready var board: GridContainer = $Board

var player_hand: Array[CardResource] = []

func _ready() -> void:
	SignalBus.card_selected.connect(_select_cards)
	_deal_cards()
	
func _select_cards(card: CardUI) -> void:
	if card.is_selected:
		player_container.remove_child(card)
		board.add_child(card)
	else:
		board.remove_child(card)
		player_container.add_child(card)
		
func _deal_cards() -> void:
	if player_hand.size() == 0:
		for i: int in range(TOTAL_CARDS):
			var card: CardResource = DeckManager.deck.pop_front()
			player_hand.append(card)
			_add_cards_to_hand(card)

func _add_cards_to_hand(card: CardResource) -> void:
	var card_node: CardUI = CARD_SCENE.instantiate()
	player_container.add_child(card_node)
	card_node.card_data = card
	card_node._apply_texture()

func _on_play_button_pressed() -> void:
	pass

#func _compare_hands() -> void:
	#for i: int in range(TOTAL_CARDS):
		#var player: int = selected_cards[i].card_data.value
		#var computer: int = computer_hand[i].value
		#if player > computer:
			#print("WIN")
		#elif player == computer:
			#print("TIE!")
		#else:
			#print("LOSE")
