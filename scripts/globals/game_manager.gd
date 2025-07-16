class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://scenes/card_ui.tscn")
const TOTAL_CARDS: int = 5

@onready var player_container: HBoxContainer = $PlayerHand

var player_hand: Array[CardResource] = []
var computer_hand: Array[CardResource] = []
var _play_cards_array: Array[CardResource] = []

func _ready() -> void:
	SignalBus.card_selected.connect(_select_playable_cards)
	
	_deal_cards()
	_add_cards_to_hand()

func _select_playable_cards(card: CardUI) -> void:
	if card.is_selected:
		card.position.y = -8
		_play_cards_array.push_back(card.card_data)
		print(card.card_data.value)
		card.order_label.text = str(_play_cards_array.find(card.card_data) + 1)
	else:
		card.position.y = 0
		_play_cards_array.erase(card.card_data)
		card.order_label.text = str(_play_cards_array.find(card.card_data) + 1)
	
func _on_play_button_pressed() -> void:
	_compare_hands(_play_cards_array)

func _deal_cards() -> void:	
	if player_hand.size() == 0:
		for i: int in range(TOTAL_CARDS):
			var card: CardResource = DeckManager.deck.pop_front()
			player_hand.append(card)
	else:
		print("Player hand is not empty")
		
	if computer_hand.size() == 0:
		for i: int in range(TOTAL_CARDS):
			var card: CardResource = DeckManager.deck.pop_front()
			computer_hand.append(card)
	else:
		print("Computer hand is not empty")
	
func _add_cards_to_hand() -> void:
	for card: CardResource in player_hand:
		var card_node: CardUI = CARD_SCENE.instantiate()
		player_container.add_child(card_node)
		card_node.card_data = card

func _compare_hands(array: Array[CardResource]) -> void:
	for i: int in range(TOTAL_CARDS):
		if array[i].value > computer_hand[i].value:
			print("WIN: ", array[i].value, " is higher than ", computer_hand[i].value)
		elif array[i].value == computer_hand[i].value:
			print("TIE: Both players have the same value ", array[i].value)
		else:
			print("LOSE: ", array[i].value, " is lower than ", computer_hand[i].value)
