extends VBoxContainer
@onready var sfx_h_slider: HSlider = $sfx/sfxHSlider
@onready var ost_h_slider: HSlider = $ost/ostHSlider

func _ready() -> void:
	#sfx_h_slider.value = AudioManager.get_volume_from_bus("sfx")
	#ost_h_slider.value = AudioManager.get_volume_from_bus("ost")
	sfx_h_slider.value = AudioManager.volume_sfx
	ost_h_slider.value = AudioManager.volume_ost

#ost
func _on_ost_h_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("volume_changed",value,"ost")
#sfx
func _on_sfx_h_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("volume_changed",value,"sfx")
	AudioManager.emit_signal("play_sound","hit","sfx")
