extends Control
@onready var options_tab: Control = $HBoxContainer/optionsTab
@onready var pause_main: VBoxContainer = $HBoxContainer/pause_main

#func _ready() -> void:
	

func tab_hopping(new_tab:String):
	if new_tab != "main":
		#back_to_menu_btn.visible = true
		options_tab.visible = true
		for tab in options_tab.get_children():
			if tab.name == new_tab:
				tab.visible = true
			else:
				tab.visible = false
	else:
		#back_to_menu_btn.visible = false
		options_tab.visible = false

func _on_volume_btn_button_up() -> void:
	tab_hopping("soundSliders")

func _on_change_keybinds_btn_button_up() -> void:
	tab_hopping("keybindUpdate")


func _on_pause_main_visibility_changed() -> void:
	if visible:
		pause_main.get_child(0).grab_focus()
	else: 
		get_parent().grab_main_focus()
