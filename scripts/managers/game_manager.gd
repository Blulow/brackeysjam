extends Node

var round_manager: RoundManager
var settings: Dictionary = {
	"music": 0.5,
	"sfx": 0.5
}

func change_sound_settings(channel: String, amount: float) -> void:
	match channel:
		"music":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(amount))
		"sfx":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(amount))
	settings[channel] = amount
