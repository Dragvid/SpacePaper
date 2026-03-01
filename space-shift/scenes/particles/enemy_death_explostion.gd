extends Node2D

func _ready() -> void:
	AudioManager.emit_signal("play_sound","explosion","sfx")
