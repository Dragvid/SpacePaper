extends Node
class_name SoundManager


signal volume_changed(volume: float)
signal play_sound(sound_name : String,sound_type : String, loop_sound : bool)
 
static var volume_sfx:float = 0.5
static var volume_ost:float = 0.5

static var sfx_array = [
	{"name":"explosion","file_path":"res://sound/sfx/Explosion.wav"},
	{"name":"hit","file_path":"res://sound/sfx/Hit_Hurt.wav"},
	{"name":"enemy_hit","file_path":"res://sound/sfx/Hit4.wav"},
	{"name":"player_death","file_path":"res://sound/sfx/death.wav"},
	{"name":"laser_shot","file_path":"res://sound/sfx/laser_shoot.wav"},
	{"name":"rocket_thruster","file_path":"res://sound/sfx/thruster.wav"},
	{"name":"cup_pickup","file_path":"res://sound/sfx/cup pickup.wav"}
	]
static var ost_array =[
	{"name":"ost1","file_path":"res://sound/ost/JessiePinkman-loop120bpm.mp3"}
	]
func _ready() -> void:
	volume_changed.connect(_on_volume_changed)
	play_sound.connect(pick_and_play_right_sound)

func _on_volume_changed(volume: float, vol_type:String) -> void:
	#print(vol_type," new vol: ",volume)
	match vol_type:
		"ost":
			volume_ost = volume
			SaveSystem._write_save(
				{"volume_ost": volume_ost}
			)
		"sfx":
			volume_sfx = volume
			SaveSystem._write_save(
				{"volume_sfx": volume_sfx}
			)
	var db = linear_to_db(volume)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(vol_type),
		db
	)

func get_volume_from_bus(vol_type:String):	
	var volume = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index(vol_type)
	)
	#print(vol_type," :",volume)
	return volume

func pick_and_play_right_sound(sound_name:String,sound_type:String, loop:bool = false):
	#print("pick_and_play_right_sound ",sound_name," ",sound_type)
	var right_sound_array 
	var sound_node_name = str(sound_type,"_",sound_name)
	match sound_type:
		"ost":
			if get_node_or_null(sound_node_name) != null:
				return
			right_sound_array = ost_array
			print("ost play request")
		"sfx":
			right_sound_array = sfx_array
	for sound in right_sound_array:
		if sound.name == sound_name:
			on_play_sound(sound.file_path, sound_type, loop, sound_node_name)
			return
	push_warning("Sound not found: " + name)

func on_play_sound(sound_path: String, bus_name:String, loop:bool, node_name:String) -> void:
	var audio_stream = load(sound_path)
	if audio_stream is AudioStream:
		var player := AudioStreamPlayer.new()
		player.stream = audio_stream
		player.bus = bus_name
		player.name = node_name
		if loop:
			if audio_stream is AudioStreamWAV:
				print("loop sound")
				audio_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
			elif audio_stream is AudioStreamOggVorbis:
				audio_stream.loop = true
		add_child(player)
		player.play()
		# Remove the player when finished
		player.finished.connect(player.queue_free)
	else:
		push_error("Failed to load sound at path: " + sound_path)
