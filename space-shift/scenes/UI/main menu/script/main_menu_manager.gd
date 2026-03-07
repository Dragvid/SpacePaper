extends Control

static var game_scene = "res://scenes/game_scene.tscn"

@onready var main_options: HBoxContainer = $main_options

#@onready var rules_label: Label = $game_rules_display/ScrollContainer/VBoxContainer/rules_label
@onready var game_rules_display: Control = $game_rules_display
@onready var game_options: Control = $options

#@export var rules_text : String 

func _ready() -> void:
	grab_main_focus()
	#AudioManager.emit_signal("play_sound","test_ost","ost",true)
	#pass
	#rules_label.text = str(rules_text %)

func grab_main_focus():
	main_options.get_child(0).grab_focus()

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file(game_scene)

func _on_quit_button_button_up() -> void:
	get_tree().quit()

func _on_rules_button_button_up() -> void:
	game_rules_display.visible = true
	main_options.visible = false

#Back to main menu
func back_to_menu(current_tab:Control):
	current_tab.visible = false
	#game_rules_display.visible = false
	main_options.visible = true

func _on_button_button_down() -> void:
	back_to_menu(game_rules_display)

func _on_back_button_button_up() -> void:
	back_to_menu(game_options)


func _on_options_button_button_up() -> void:
	game_options.visible = true
	main_options.visible = false
