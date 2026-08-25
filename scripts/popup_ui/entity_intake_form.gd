extends Control

@onready var indicator: TextureRect = $UI/Indicator
@onready var accept_btn: TextureButton = $UI/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/TextureButton
@onready var reject_btn: TextureButton = $UI/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/TextureButton2
@onready var number_selector: NumberSelector = $UI/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NumberSelector

var entity_count: int = 0

var conc: int = -1

func _ready() -> void:
	entity_count = GameManager.round_manager.form_data.entity_count
	conc = GameManager.round_manager.form_data.conc
	
	number_selector.number = entity_count
	number_selector.update_display()
	
	(func():
		match conc:
			-1:
				indicator.visible = false
			GameManager.round_manager.Conc.ACCEPT:
				accept_indicator()
			GameManager.round_manager.Conc.REJECT:
				reject_indicator()
	).call_deferred()
	

func _on_accept_pressed() -> void:
	accept_indicator() 
	conc = GameManager.round_manager.Conc.ACCEPT
	GameManager.round_manager.concluded.emit(true)

func _on_reject_pressed() -> void:
	reject_indicator()
	conc = GameManager.round_manager.Conc.REJECT
	GameManager.round_manager.concluded.emit(true)

func accept_indicator() -> void:
	indicator.visible = true
	indicator.global_position = accept_btn.global_position + accept_btn.size / 2 - indicator.size / 2

func reject_indicator() -> void:
	indicator.visible = true
	indicator.global_position = reject_btn.global_position + reject_btn.size / 2 - indicator.size / 2

func _on_number_update(num: int) -> void:
	entity_count = num

func _on_close_button_pressed() -> void:
	GameManager.round_manager.form_data.entity_count = entity_count
	GameManager.round_manager.form_data.conc = conc
