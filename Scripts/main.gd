class_name Main extends Control

@export var game_manager: GameManager

@onready var redraw_label: Label = $Buttons/RedrawButton/RedrawLabel

func _ready() -> void:
	SignalBus.updated_redraw_label.connect(_redraw_counter)
	redraw_label.text = str(game_manager.redraw_counter)

func _redraw_counter(counter: int) -> void:
	redraw_label.text = str(counter)
