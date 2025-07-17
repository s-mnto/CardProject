class_name Main extends Control

@export var game_manager: GameManager = null

func _ready() -> void:
	if not game_manager:
		push_error("Game manager not found.")
		return 

func _draw() -> void:
	draw_circle(Vector2(100, 100), 350, Color.LIME_GREEN)
