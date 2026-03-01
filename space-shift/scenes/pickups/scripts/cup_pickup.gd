extends Node2D
@export var score_on_pickup : int

func _on_area_2d_area_entered(area: Area2D) -> void:
	#print(area.get_parent().name)
	if area.get_parent() == AppInfo.playerNode:
		AudioManager.emit_signal("play_sound","cup_pickup","sfx")
		AppInfo.update_score(score_on_pickup)
		queue_free()
