extends CharacterBody2D
#mobility
@export var speed = 400
#health
@export var healthTotal : int
@export var regenerateAmmount : int
@export var regenerateInterval : float
@onready var heal_timer: Timer = $healTimer
var currentHealth
signal  TakeDamage
#combat
enum weapons{lazer,field,rocket}
var weapon_current=0
@onready var shoot_timer: Timer = $shootTimer
@export var laserScene:PackedScene
@export var rocketScene:PackedScene
@export var forceFieldScene:PackedScene

func _ready() -> void:
	currentHealth=healthTotal
	AppInfo.set_player_node(self)

func get_input():
	var input_direction=Vector2.ZERO
	input_direction.x=Input.get_action_strength("game_dir_right") - Input.get_action_strength("game_dir_left")
	input_direction.y=Input.get_action_strength("game_dir_down") - Input.get_action_strength("game_dir_up")
	input_direction.normalized()
	velocity = input_direction * speed
	if velocity.length() > 0:
		rotation = velocity.angle()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
	#weapon switching
	if Input.is_action_just_pressed("game_weapon_1"):
		change_weapon(weapons.lazer)
	if Input.is_action_just_pressed("game_weapon_2"):
		change_weapon(weapons.field)
		if count_instances_of_scene(forceFieldScene,"PlayerForceField")<1:
				shoot(forceFieldScene.resource_path,get_parent(),position)
	if Input.is_action_just_pressed("game_weapon_3"):
		change_weapon(weapons.rocket)

func change_weapon(new_weapon):
	if new_weapon!=weapon_current:
		weapon_current=new_weapon

func count_instances_of_scene(scene: PackedScene, groupName:String) -> int:
	var count = 0
	for node in get_tree().get_nodes_in_group(groupName):
		if node.scene_file_path == scene.resource_path:
			count += 1
	return count

func shoot(scene_path: String, parent: Node = null, position_par: Vector2 = Vector2.ZERO) -> Node:
	var scene_resource = load(scene_path)
	if scene_resource is PackedScene:
		var instance = scene_resource.instantiate()
		# Optional: Set position if it's a Node2D or CharacterBody2D
		if instance is Node2D:
			instance.position = position
		elif instance.has_method("set_global_position"):
			instance.set_global_position(position_par)
		# Set parent or add to current node
		if parent != null:
			parent.add_child(instance)
		else:
			add_child(instance)
		return instance
	else:
		push_error("Could not load scene at: " + scene_path)
		return null

func change_health(changeValue):
	if changeValue<0:#damage
		start_heal()
		AudioManager.emit_signal("play_sound","hit","sfx")
	GeneralToolsStatic.change_health_values(self,changeValue,healthTotal)
	emit_signal("TakeDamage")
	

func start_heal():
	heal_timer.wait_time=regenerateInterval
	heal_timer.start()

func die():
	#lose game
	AppInfo.clear_app_info()
	#print("Game over")
	AudioManager.emit_signal("play_sound","player_death","sfx")

func _on_shoot_timer_timeout() -> void:
	#if AppInfo.enemiesOnScreen.size()<=0:
	if get_tree().get_nodes_in_group("Enemy").size()<=0:
		return
	match  weapon_current:
		weapons.lazer:
			shoot(laserScene.resource_path,get_parent(),position)
			shoot_timer.wait_time=2
		weapons.rocket:
			shoot(rocketScene.resource_path,get_parent(),position)
			
		#weapons.field:
			#if count_instances_of_scene(forceFieldScene,"PlayerForceField")<1:
				#shoot(forceFieldScene.resource_path,get_parent(),position)
			#shoot_timer.wait_time=0

func _on_heal_timer_timeout() -> void:
	change_health(regenerateAmmount)
	if healthTotal <= currentHealth:
		heal_timer.stop()	
