extends Node2D

@export var enemy_scenes: Array[PackedScene] = []  # Array of enemy scene references
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 3.0
var current_spawn_interval: float = 0.0
@export var max_enemies: int = 10
@export var spawn_area_radius: float = 100.0

var spawn_timer := 0.0
var enemies_on_screen: Array = []

func _ready():
	randomize()
	_set_next_spawn_time()

func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= current_spawn_interval:
		spawn_timer = 0.0

		if enemies_on_screen.size() < max_enemies:
			spawn_enemy()
		
		_set_next_spawn_time()


		if enemies_on_screen.size() < max_enemies:
			spawn_enemy()

	# Clean up any dead enemies
	enemies_on_screen = enemies_on_screen.filter(func(e): return is_instance_valid(e))

func _set_next_spawn_time() -> void:
	current_spawn_interval = randf_range(min_spawn_interval, max_spawn_interval)

func spawn_enemy() -> void:
	if enemy_scenes.is_empty():
		push_error("Enemy scenes array is empty!")
		return

	# Pick a random scene
	var scene_index = randi() % enemy_scenes.size()
	var enemy_scene = enemy_scenes[scene_index]

	var enemy = enemy_scene.instantiate()
	
	# Random spawn position in circle
	var angle = randf() * TAU
	var offset = Vector2.RIGHT.rotated(angle) * randf_range(0, spawn_area_radius)
	enemy.global_position = global_position + offset

	get_tree().current_scene.add_child(enemy)
	enemies_on_screen.append(enemy)
