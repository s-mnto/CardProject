class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://scenes/card_ui.tscn")
const TOTAL_CARDS: int = 5

@onready var player_container: HBoxContainer = $PlayerHand
@onready var computer_container: HBoxContainer = $ComputerHand
@onready var play_board: GridContainer = $PlayBoard

var player_hand: Array[CardResource] = []
var computer_hand: Array[CardResource] = []
var _played_cards: Array[CardUI] = []

func _ready() -> void:
	SignalBus.card_selected.connect(_select_cards)
	_deal_cards(player_hand)
	_deal_cards(computer_hand)
	_add_cards_to_hand()
	_add_cards_to_computer()

func _select_cards(card: CardUI) -> void:
	if card.is_selected:
		card.position.y = -8
		_played_cards.push_back(card)
	else:
		card.position.y = 0
		_played_cards.erase(card)
	
	_update_card_order_label()
	

func _deal_cards(which_hand: Array[CardResource]) -> void:
	if which_hand.size() == 0:
		for i: int in range(TOTAL_CARDS):
			var card: CardResource = DeckManager.deck.pop_front()
			which_hand.append(card)
	else:
		print("Hand is not empty")
	
func _add_cards_to_hand() -> void:
	for card: CardResource in player_hand:
		var card_node: CardUI = CARD_SCENE.instantiate()
		player_container.add_child(card_node)
		card_node.card_data = card
		card_node._apply_texture()
		card_node.value_label.text = str(card._get_rank_values(card_node.card_data.value))

func _compare_hands() -> void:
	for i: int in range(TOTAL_CARDS):
		if _played_cards[i].card_data.value > computer_hand[i].value:
			print("WIN: ", _played_cards[i].card_data.value, " is higher :than ", computer_hand[i].value)
		elif _played_cards[i].card_data.value == computer_hand[i].value:
			print("TIE: Both players have the same value ", _played_cards[i].card_data.value)
		else:
			print("LOSE: ", _played_cards[i].card_data.value, " is lower than ", computer_hand[i].value)

func _update_card_order_label() -> void:
	for card_ui: CardUI in player_container.get_children():
		card_ui.order_label.text = str(_played_cards.find(card_ui) + 1)

func _add_cards_to_computer() -> void:
	for card: CardResource in computer_hand:
		var card_node: CardUI = CARD_SCENE.instantiate()
		computer_container.add_child(card_node)
		card_node._backside_texture()
		card_node._disable_clickable()
		card_node.card_data = card
		card_node.value_label.text = str(card._get_rank_values(card_node.card_data.value))

func _on_play_button_pressed() -> void:
	if _played_cards.size() < TOTAL_CARDS:
		return
	
	_compare_hands()
	
	for card: CardUI in computer_container.get_children():
		computer_container.remove_child(card)
		play_board.add_child(card)
		card._apply_texture()
		await get_tree().create_timer(1.5).timeout

	for card: CardUI in _played_cards:
		player_container.remove_child(card)
		play_board.add_child(card)
		card._disable_clickable()
		await get_tree().create_timer(1.5).timeout
	
	
		
	player_hand.clear()
	computer_hand.clear()
	_played_cards.clear()
	
	print(player_hand)
	print(computer_hand)
	print(_played_cards)
	print(DeckManager.deck.size())
