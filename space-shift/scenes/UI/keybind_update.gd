extends Control

@onready var action_list: VBoxContainer = $ScrollContainer/actionList

@export var action_line:PackedScene

func _ready() -> void:
	getActionList()

func getActionList():
	for action in InputMap.get_actions():
		if "game_" in action:
			var events := InputMap.action_get_events(action)
			var key_text := "Unbound"
			if events.size() > 0 and events[0] is InputEventKey:
				key_text = events[0].as_text()
			var instance = action_line.instantiate()
			action_list.add_child(instance)
			instance.set_info(action.get_basename(), key_text)
