class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/card_ui.tscn")
const TOTAL_CARDS: int = 5

@onready var player_container: HBoxContainer = $Player
@onready var cpu_container: HBoxContainer = $Computer
@onready var check_container: HBoxContainer = $Check
@onready var show_computer_cards: HBoxContainer = $ShowComputerCards

var player_hand: Array[CardResource] = []
var cpu_hand: Array[CardResource] = []

var redraw_counter: int = 3

func _ready() -> void:
	SignalBus.card_selected.connect(_select_cards)
	_deal_cards(TOTAL_CARDS)
	_deal_cards_to_computer(TOTAL_CARDS)
	
func _deal_cards(cards: int) -> void:
	for i: int in range(cards):
		var card: CardResource = DeckManager.deck.pop_front()
		player_hand.append(card)
		_add_cards_to_player(card)
		
func _deal_cards_to_computer(cards: int) -> void:
	for i: int in range(cards):
		var card: CardResource = DeckManager.deck.pop_front()
		cpu_hand.append(card)
		_add_cards_to_cpu(card)
		
func _add_cards_to_cpu(card: CardResource) -> void:
	var card_node: CardUI = CARD_SCENE.instantiate()
	cpu_container.add_child(card_node)
	card_node.card_data = card
	card_node._apply_backside_texture()
	card_node._disable_clickable()
	card_node.name = str(CardResource.Suits.keys()[card.suit_type], " of ", card._get_rank_values(card.value))

func _add_cards_to_player(card: CardResource) -> void:
	var card_node: CardUI = CARD_SCENE.instantiate()
	player_container.add_child(card_node)
	card_node.card_data = card
	card_node._apply_texture()
	card_node.name = str(CardResource.Suits.keys()[card.suit_type], " of ", card._get_rank_values(card.value))

func _select_cards(card: CardUI) -> void:
	if card.is_selected:
		player_container.remove_child(card)
		check_container.add_child(card)
	else:
		check_container.remove_child(card)
		player_container.add_child(card)
	
func _compare_hands() -> void:
	for i: int in range(TOTAL_CARDS):
		var selected_cards: Array[Node] = check_container.get_children()
		var player: int = selected_cards[i].card_data.value
		var computer: int = cpu_hand[i].value
		
		if player > computer:
			print("WIN!")
		elif player == computer:
			print("TIE!")
		else:
			print("LOSE!")

func _on_redraw_button_pressed() -> void:
	if redraw_counter <= 0:
		return
	
	for played: CardUI in check_container.get_children():
		check_container.remove_child(played)
		player_hand.erase(played.card_data)
		redraw_counter -= 1
	
	var current_cards: int = player_container.get_child_count()
	_deal_cards(TOTAL_CARDS - current_cards)

func _on_play_button_pressed() -> void:
	if check_container.get_child_count() < TOTAL_CARDS:
		return
	
	for card: CardUI in check_container.get_children():
		card._disable_clickable()
	
	for card: CardUI in cpu_container.get_children():
		cpu_container.remove_child(card)
		show_computer_cards.add_child(card)
		card._apply_texture()
		await get_tree().create_timer(1.2).timeout
	
	_compare_hands()
