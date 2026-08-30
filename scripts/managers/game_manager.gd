extends Node

var round_manager: RoundManager
var settings: Dictionary = {
	"music": 0.4,
	"sfx": 1
}

var pending_load_round: bool = false
var round_to_load: int = -1

func _ready() -> void:
	change_sound_settings("music", settings.music)
	change_sound_settings("sfx", settings.sfx)

func change_sound_settings(channel: String, amount: float) -> void:
	match channel:
		"music":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(amount))
		"sfx":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(amount))
	settings[channel] = amount

func load_round(idx: int) -> void:
	pending_load_round = true
	round_to_load = idx
