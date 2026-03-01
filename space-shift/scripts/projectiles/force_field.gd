extends Area2D
#@export var speedX: float = 150.0
#@export var speedY: float = 150.0
@export var damage:int
@export var repel_force:float
var target: Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if AppInfo.playerNode!=null:
		GeneralToolsStatic.home_into_target(self,AppInfo.playerNode,AppInfo.playerNode.speed,AppInfo.playerNode.speed,delta)
		if AppInfo.playerNode.weapon_current!=1:
			queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent()!=AppInfo.playerNode && area.get_parent().is_in_group("Enemy"):
		area.get_parent().change_health(-damage)
		animation_player.play("crash")
		# Repel direction from this node to the target
		#if area.get_parent() is CharacterBody2D:
			#var repel_direction = (area.get_parent().global_position - global_position).normalized()
			#area.get_parent().velocity += repel_direction * repel_force
