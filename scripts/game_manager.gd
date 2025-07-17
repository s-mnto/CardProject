class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://scenes/card_ui.tscn")
const TOTAL_CARDS: int = 3

@onready var player_container: HBoxContainer = $Player
@onready var check_container: HBoxContainer = $Check

var player_hand: Array[CardResource] = []
var redraw_counter: int = 0

func _ready() -> void:
	SignalBus.card_selected.connect(_select_cards)
	_deal_cards(TOTAL_CARDS)
	
func _deal_cards(cards: int) -> void:
	for i: int in range(cards):
		var card: CardResource = DeckManager.deck.pop_front()
		player_hand.append(card)
		_add_cards_to_hand(card)

func _add_cards_to_hand(card: CardResource) -> void:
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

func _on_redraw_button_pressed() -> void:
	for played: CardUI in check_container.get_children():
		check_container.remove_child(played)
		player_hand.erase(played.card_data)
		redraw_counter += 1
	
	var current_cards: int = player_container.get_child_count()
	_deal_cards(TOTAL_CARDS - current_cards)
