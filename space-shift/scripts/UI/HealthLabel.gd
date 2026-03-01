extends Label

func _ready() -> void:
	text=str(AppInfo.playerNode.healthTotal,"/",AppInfo.playerNode.currentHealth)
