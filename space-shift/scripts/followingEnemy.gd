extends CharacterBody2D
@export var scoreOnDeath = 10
@export var speedX: float = 150.0
@export var speedY: float = 150.0
@export var atkDamage: int = -1
@export var healthTotal:int=10
@export var drop_item : PackedScene
@export var drop_chance_percentage : int
var currentHealth
var player: Node2D

#var dmgDealt
func _ready() -> void:
	currentHealth=healthTotal
	AppInfo.add_enemy_to_list(self)
	if AppInfo.playerNode != null:
		player = AppInfo.playerNode

func _physics_process(delta: float) -> void:
	if player!=null:
		GeneralToolsStatic.home_into_target(self,player,speedX,speedY,delta)
	move_and_slide()

func change_health(changeValue):
	if changeValue < 0:
		AudioManager.emit_signal("play_sound","enemy_hit","sfx")
	GeneralToolsStatic.change_health_values(self,changeValue,healthTotal)
	
func die():
	drop_item_on_death()
	AppInfo.update_score(scoreOnDeath)
	GeneralToolsStatic.instantiate_scene("res://scenes/particles/enemyDeathExplostion.tscn",self.get_parent(),self.position)
	AppInfo.clear_enemy_from_list(self)

func drop_item_on_death():
	#drop_chance_percentage = clamp(drop_chance_percentage, 0, 100)
	var roll := randi_range(1, 100)
	if roll >= drop_chance_percentage:
		GeneralToolsStatic.instantiate_scene(drop_item.resource_path,self.get_parent(),self.position)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent()==player:
		area.get_parent().change_health(atkDamage)
		#print("deal damage")
		#queue_free()#delete the laser on contact
