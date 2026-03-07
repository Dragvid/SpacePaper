extends Control

@onready var action_name_label: Label = $actionNameLabel
@onready var action_key_button: Button = $actionKeyButton
var target_action 

func _ready() -> void:
	pass

func set_info(action_name, action_keybind):
	target_action = action_name
	action_name_label.text = format_action_name_pretty(action_name)
	action_key_button.text = action_keybind

var waiting_for_input := false
var action_to_rebind := ""

func rebind_action(action_name: String) -> void:
	action_to_rebind = action_name
	await get_tree().create_timer(0.2).timeout
	waiting_for_input = true
	action_key_button.text = "..."
	#print("Press a key to rebind:", action_name)

func _unhandled_input(event: InputEvent) -> void:
	if not waiting_for_input:
		return

	# Ignore mouse motion
	if event is InputEventMouseMotion:
		return

	# Accept keyboard, mouse buttons, and controller buttons
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		InputMap.action_erase_events(action_to_rebind)
		InputMap.action_add_event(action_to_rebind, event)

		waiting_for_input = false
		action_key_button.text = event.as_text()
		print("Rebound", action_to_rebind, "to", event.as_text())
		SaveSystem.emit_signal(
				"keybind_changed",
				action_to_rebind,
				event.as_text()
			)

func format_action_name_pretty(action_name: String) -> String:
	var words = action_name.split("_")
	var final_name:String
	for i in words.size():
		if words[i] != "game":
			final_name = str(final_name," ",words[i].capitalize())
	return final_name

func _on_action_key_button_button_up() -> void:
	rebind_action(target_action)
