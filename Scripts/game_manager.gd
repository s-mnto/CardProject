class_name GameManager extends Control

const WAIT_TIME: float = 0.8
const ANIM_TIMER: float = 0.9
const TOTAL_CARDS: int = 3
const CARD_SCENE: PackedScene = preload("res://Scenes/card_ui.tscn")

@export var anim: AnimationManager

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
var tween: Tween

func _ready() -> void:
	SignalBus.card_selected.connect(_select_cards)
	_deal_cards(TOTAL_CARDS)
	_deal_cards_to_computer(TOTAL_CARDS)
	
	if anim == null:
		push_error("Missing animation manager")
	
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
	card_node.apply_backside_texture()
	card_node.disable_clickable()
	card_node.name = str(CardResource.Suits.keys()[card.suit_type], " of ", card._get_rank_values(card.value))

func _add_cards_to_player(card: CardResource) -> void:
	var card_node: CardUI = CARD_SCENE.instantiate()
	player_container.add_child(card_node)
	card_node.card_data = card
	card_node.apply_texture()
	
func _select_cards(card: CardUI) -> void:
	if card.is_selected:
		player_container.remove_child(card)
		check_container.add_child(card)
	else:
		check_container.remove_child(card)
		player_container.add_child(card)
		
func _compare_hands() -> void:
	anim.reset_tween()
	for i: int in range(TOTAL_CARDS):
		var selected_cards: Array[Node] = check_container.get_children()
		var player: CardUI = selected_cards[i]
		var computer: CardUI = played_computer_cards.get_child(i)
		
		if player.card_data.value > computer.card_data.value:
			anim.delete_card_animation(computer)
		elif player.card_data.value == computer.card_data.value:
			if player.card_data.suit_type > computer.card_data.suit_type:
				anim.delete_card_animation(computer)
			else:
				anim.delete_card_animation(player)
		else:
			anim.delete_card_animation(player)

func _on_redraw_button_pressed() -> void:
	if redraw_counter == 0:
		return
	
	for played: CardUI in check_container.get_children():
		anim.reset_tween()
		anim.redraw_animation(played)
		
		await anim.tween.finished 
		_deal_cards(1)
		
		redraw_counter -= 1
		SignalBus.updated_redraw_label.emit(redraw_counter)
		if redraw_counter == 0:
			break
	
	if redraw_counter == 0:
		redraw_button.disabled = true

func _on_play_button_pressed() -> void:
	if check_container.get_child_count() < TOTAL_CARDS:
		return
	buttons.hide()
	
	for card: CardUI in check_container.get_children():
		card.disable_clickable()
	
	for card: CardUI in cpu_container.get_children():
		cpu_container.remove_child(card)
		played_computer_cards.add_child(card)
		card.apply_texture()
		await get_tree().create_timer(WAIT_TIME).timeout
	
	_compare_hands()
	
	await get_tree().create_timer(WAIT_TIME).timeout
	restart_button.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	DeckManager._build_deck()
