extends Area2D

@export var speed: float = 150.0
@export var damage:int = -20
var target: Node2D
var direction

func _ready() -> void:
	AudioManager.emit_signal("play_sound","rocket_thruster","sfx")
	direction=Vector2.RIGHT.rotated(AppInfo.playerNode.rotation)
	#direction = direction.normalized()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	rotation = direction.angle()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent()!=AppInfo.playerNode && area.get_parent().is_in_group("Enemy"):
		area.get_parent().change_health(damage)
		queue_free()#delete the laser on contact

func _on_timer_timeout() -> void:
	queue_free()
