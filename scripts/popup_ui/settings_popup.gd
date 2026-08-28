extends Control

@onready var music = $UI/PanelContainer/VBoxContainer/HBoxContainer/HSlider
@onready var sfx = $UI/PanelContainer/VBoxContainer/HBoxContainer2/HSlider

func _ready() -> void:
	music.value = 100 * GameManager.settings.music
	sfx.value = 100 * GameManager.settings.sfx

func _on_music_value_changed(value: float) -> void:
	GameManager.change_sound_settings("music", music.value / 100)

func _on_sfx_drag_ended(value_changed: bool) -> void:
	GameManager.change_sound_settings("sfx", sfx.value / 100)
