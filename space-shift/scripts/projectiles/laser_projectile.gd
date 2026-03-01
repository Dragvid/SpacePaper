extends Area2D

@export var speedX: float = 150.0
@export var speedY: float = 150.0
var target: Node2D

func _ready() -> void:
	AudioManager.emit_signal("play_sound","laser_shot","sfx")

func _physics_process(delta: float) -> void:
	if target!=null:
		GeneralToolsStatic.home_into_target(self,target,speedX,speedY,delta)
		look_at(target.position)
	else:
		#target=GeneralToolsStatic.get_closest_target(self,AppInfo.enemiesOnScreen)
		target=GeneralToolsStatic.get_closest_target(self,get_tree().get_nodes_in_group("Enemy"))
	

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent()!=AppInfo.playerNode && area.get_parent().is_in_group("Enemy"):
		area.get_parent().change_health(-10)
		queue_free()#delete the laser on contact

func _on_timer_timeout() -> void:
	queue_free()
