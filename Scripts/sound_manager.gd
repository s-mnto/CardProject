class_name SoundManager extends Node2D

@onready var table_sound: AudioStreamPlayer2D = $PutOnTableSound
@onready var button_sound: AudioStreamPlayer2D = $ButtonSound
@onready var erase_sound: AudioStreamPlayer2D = $EraseSound

func card_place_sound() -> void:
	table_sound.play()
