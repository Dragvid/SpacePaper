class_name AppInfo

static var playerNode : Node
static var enemiesOnScreen : Array
static var score : int
static var app_cleared = false
static var highscore : int
static var new_highscore : bool = false

static func set_player_node(nodeToSave):
	playerNode=nodeToSave
	app_cleared = false

static func add_enemy_to_list(newEnemy):
	enemiesOnScreen.append(newEnemy)

static func clear_enemy_from_list(oldEnemy):
	for enemy in enemiesOnScreen:
		if enemy==oldEnemy:
			enemiesOnScreen.erase(oldEnemy)

static func clear_app_info():#At the end the game
	if app_cleared:
		return
	if score > SaveSystem.get_highscore():
		#print("New highscore")
		SaveSystem._write_save(
			{"highscore": score}
		)
		AppInfo.highscore = score
		new_highscore = true
	playerNode=null
	score = 0
	for enemy in enemiesOnScreen:
		clear_enemy_from_list(enemy)
	app_cleared = true
	#enemiesOnScreen.clear()
	
static func clear_player():
	playerNode=null

static func update_score(new_score:int):
	score += new_score
	
