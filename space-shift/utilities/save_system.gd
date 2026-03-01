extends Node
class_name SaveManager

const SAVE_PATH := "user://save_data.json"
#const SAVE_PATH := "res://save_data.json"

signal keybind_changed(action: String, keybind: String)

func _ready() -> void:
	await get_tree().process_frame
	load_game()
	keybind_changed.connect(save_keybind)
	print(ProjectSettings.globalize_path(SAVE_PATH))

#func _write_save(new_data: Dictionary) -> void:
	##print("new data ",new_data)
	#var data := {}
	## Read existing save if it exists
	#if FileAccess.file_exists(SAVE_PATH):
		#var file_ = FileAccess.open(SAVE_PATH, FileAccess.READ)
		#var parsed = JSON.parse_string(file_.get_as_text())
		#file_.close()
		#if parsed is Dictionary:
			#data = parsed
	## Merge new data (overwrites matching keys, keeps others)
	#for key in new_data.keys():
		#data[key] = new_data[key]
	## Write final data
	#var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#file.store_string(JSON.stringify(data, "\t"))
	#file.close()

func _write_save(new_data: Dictionary) -> void:
	var data := _read_save()

	for key in new_data.keys():
		data[key] = new_data[key]

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func get_highscore() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data is Dictionary and data.has("highscore"):
		return int(data["highscore"])
	return 0

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	var result = JSON.parse_string(content)
	if result is Dictionary:
		_apply_keybinds(result.get("keybinds", {}))
		if "highscore" in result:
			AppInfo.highscore = result.get("highscore")
		if "volume_ost" in result:
			AudioManager.volume_ost = result.get("volume_ost")
		if "volume_sfx" in result:
			AudioManager.volume_sfx = result.get("volume_sfx")
		return result
	return {}

#func _read_save() -> Dictionary:
	#if not FileAccess.file_exists(SAVE_PATH):
		#return {}
#
	#var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	#var content := file.get_as_text()
	#file.close()
#
	#var json := JSON.new()
	#var result := json.parse(content)
#
	#if result != OK:
		#push_error("Failed to parse save file")
		#return {}
#
	#return json.data if json.data is Dictionary else {}
func _read_save() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}

	var content := file.get_as_text()
	file.close()

	if content.strip_edges() == "":
		return {}

	var parsed = JSON.parse_string(content)
	return parsed if parsed is Dictionary else {}

func save_keybind(changed_action: String, changed_keybind) -> void:
	# Read existing save
	var data = _read_save()

	# Ensure keybinds dictionary exists
	if not data.has("keybinds") or not (data["keybinds"] is Dictionary):
		data["keybinds"] = {}

	# Update / add the keybind
	data["keybinds"][changed_action] = changed_keybind

	# Write everything back
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func _apply_keybinds(binds: Dictionary) -> void:
	for action in binds.keys():
		if not InputMap.has_action(action):
			continue
		InputMap.action_erase_events(action)
		var key_string = binds[action]
		var ev := InputEventKey.new()
		ev.keycode = OS.find_keycode_from_string(key_string)
		InputMap.action_add_event(action, ev)
