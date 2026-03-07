extends Control
@onready var life_label: Label = $lifebar/lifeLabel
@onready var game_over_screen: Control = $gameOverScreen
@onready var score_label: Label = $score/scoreLabel
@onready var pause_menu: Control = $pauseMenu
@onready var back_to_menu_btn: Button = $pauseMenu/HBoxContainer/pause_main/backToMenuBtn
@onready var new_highscore_end: Label = $gameOverScreen/newHighscoreEnd

#tabs
@onready var options_tab: Control = $pauseMenu/HBoxContainer/optionsTab

var gamePaused = false
var main_tab = true

func _ready() -> void:
	AppInfo.playerNode.connect("TakeDamage",_on_player_take_damage)
	update_display_life_values()
	AppInfo.new_highscore=false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("game_start_btn"):
		if gamePaused == true:
			#print("unpause")
			pause_menu.visible = false
			get_tree().paused = false 
		else:
			#print("pause")
			pause_menu.visible=true
			get_tree().paused=true

func update_display_life_values():
	if AppInfo.playerNode!=null:
		life_label.text = str(AppInfo.playerNode.currentHealth,"/",AppInfo.playerNode.healthTotal)
	else:
		game_over()
		life_label.text="Lost"

func _on_player_take_damage() -> void:
	update_display_life_values()

func game_over():
	AppInfo.clear_app_info()
	game_over_screen.visible=true
	if AppInfo.new_highscore == true:
		new_highscore_end.visible=true
		

func restart_scene() -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		get_tree().reload_current_scene()
	

func tab_hopping(new_tab:String):
	if new_tab != "main":
		back_to_menu_btn.visible = true
		options_tab.visible = true
		for tab in options_tab.get_children():
			if tab.name == new_tab:
				tab.visible = true
			else:
				tab.visible = false
	else:
		back_to_menu_btn.visible = false
		options_tab.visible = false

func _on_button_button_up() -> void:
	restart_scene()

func _on_exit_game_btn_button_up() -> void:
		get_tree().quit()

func _on_continue_btn_button_up() -> void:
	#print("resume game")
	pause_menu.visible=false
	get_tree().paused = false	

func _on_back_to_menu_btn_button_up() -> void:
	tab_hopping("main")
	$pauseMenu/HBoxContainer/pause_main/continueBtn.grab_focus()

func _on_change_keybinds_btn_button_up() -> void:
	tab_hopping("keybindUpdate")

func _on_volume_btn_button_up() -> void:
	tab_hopping("soundSliders")

func _on_back_to_main_menu_btn_button_up() -> void:
	gamePaused = false
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/UI/main menu/Main_menu.tscn")

func _on_pause_menu_visibility_changed() -> void:
	if pause_menu.visible:
		$pauseMenu/HBoxContainer/pause_main/continueBtn.grab_focus()

func _on_game_over_screen_visibility_changed() -> void:
	if game_over_screen.visible:
		$gameOverScreen/button_container/playAgainBtn.grab_focus()
