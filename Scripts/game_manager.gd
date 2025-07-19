class_name GameManager extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/card_ui.tscn")
const TOTAL_CARDS: int = 5

#Containers
@onready var player_container: HBoxContainer = $Player
@onready var cpu_container: HBoxContainer = $Computer
@onready var check_container: HBoxContainer = $Check
@onready var played_computer_cards: HBoxContainer = $PlayedComputerCards

#Buttons
@onready var buttons: Control = $"../Buttons"
@onready var restart_button: Button = $"../RestartButton"
@onready var redraw_button: Button = %RedrawButton

#Card in hands
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
	var tween: Tween = get_tree().create_tween()
	
	for i: int in range(TOTAL_CARDS):
		var selected_cards: Array[Node] = check_container.get_children()
		var player: CardUI = selected_cards[i]
		var computer: CardUI = played_computer_cards.get_child(i)
		
		if player.card_data.value > computer.card_data.value:
			tween.tween_property(computer, "modulate", Color.RED, 1)
			tween.tween_callback(computer.queue_free)
		elif player == computer:
			tween.tween_property(player, "modulate", Color.GREEN, 1)
			tween.tween_property(computer, "modulate", Color.GREEN, 1)
		else:
			tween.tween_property(player, "modulate", Color.RED, 1)
			tween.tween_callback(player.queue_free)

func _on_redraw_button_pressed() -> void:
	if redraw_counter <= 0 or check_container.get_child_count() > 3:
		return
	
	for played: CardUI in check_container.get_children():
		check_container.remove_child(played)
		player_hand.erase(played.card_data)
		redraw_counter -= 1
		if redraw_counter <= 0:
			break
	
	var current_cards: int = player_container.get_child_count()
	_deal_cards(TOTAL_CARDS - current_cards)
	SignalBus.updated_redraw_label.emit(redraw_counter)
	
	if redraw_counter <= 0:
		redraw_button.disabled = true
		
func _on_play_button_pressed() -> void:
	if check_container.get_child_count() < TOTAL_CARDS:
		return
	buttons.hide()
	
	for card: CardUI in check_container.get_children():
		card._disable_clickable()
	
	for card: CardUI in cpu_container.get_children():
		cpu_container.remove_child(card)
		played_computer_cards.add_child(card)
		card._apply_texture()
		await get_tree().create_timer(0.25).timeout
	
	_compare_hands()
	
	await get_tree().create_timer(1.8).timeout
	restart_button.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	DeckManager._build_deck()
