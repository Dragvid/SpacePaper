extends Node
class_name GeneralToolsStatic

static func home_into_target(currentPos:Node,target:Node,speedX:float,speedY:float,delta):
	#var direction = (target.position - currentPos.position).normalized()
	if currentPos.position.distance_to(target.position)>0: 
		currentPos.position.x=move_toward(currentPos.position.x,target.position.x,delta*speedX)
		currentPos.position.y=move_toward(currentPos.position.y,target.position.y,delta*speedY)

static func get_closest_target(origin: Node, possibleTargets: Array) -> Node2D:
	var closest_enemy: Node = null
	var closest_distance: float = INF
	
	for enemy in possibleTargets:
		var distance = origin.global_position.distance_to(enemy.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

static func change_health_values(subject: Node, change_value: int, total_health: int) -> void:
	var new_health = subject.currentHealth + change_value
	# Taking damage
	if change_value < 0:
		if new_health <= 0:
			subject.currentHealth = 0
			subject.die()
			subject.queue_free()
			return
		else:
			subject.currentHealth = new_health
	# Gaining health
	elif change_value > 0:
		subject.currentHealth = min(new_health, total_health)

static func instantiate_scene(path:String, originNode:Node, spawnPosition:Vector2 = Vector2.ZERO):
	var scene_resource = load(path)
	if scene_resource and scene_resource is PackedScene:
		var instance = scene_resource.instantiate()
		originNode.call_deferred("add_child", instance)
		instance.position=spawnPosition
		return instance
	else:
		print("Failed to load scene at path: ", path)
		return null
