extends Control

@onready var entity_count_input: LineEdit = $UI/PanelContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var people_count_input: LineEdit = $UI/PanelContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/LineEdit
@onready var indicator: ColorRect = $UI/Indicator
@onready var accept_btn: TextureButton = $UI/PanelContainer/TextureRect/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureButton
@onready var reject_btn: TextureButton = $UI/PanelContainer/TextureRect/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/TextureButton2

enum Conc { ACCEPT, REJECT }
var conc: int = -1

func _ready() -> void:
	indicator.visible = false

func _on_accept_pressed() -> void:
	indicator.visible = true
	indicator.global_position = accept_btn.global_position
	GameManager.round_manager.concluded.emit(true)

func _on_reject_pressed() -> void:
	indicator.visible = true
	indicator.global_position = reject_btn.global_position
	GameManager.round_manager.concluded.emit(true)
