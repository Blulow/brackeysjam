extends Node2D

@onready var buttons: Control = $Buttons
@onready var give_btn: TextureButton = $Buttons/HBoxContainer/Give

var button_show: bool = false

func _ready() -> void:
	GameManager.round_manager.concluded.connect(_on_concluded)
	buttons.scale = Vector2.ZERO
	give_btn.disabled = true

func _on_clicked() -> void:
	if button_show: hide_buttons()
	else: show_buttons()

func show_buttons() -> void:
	buttons.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(buttons, "scale", Vector2.ONE, 0.1)
	button_show = true

func hide_buttons() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(buttons, "scale", Vector2.ZERO, 0.1)
	await tween.finished
	buttons.visible = false
	button_show = false

func _on_edit_pressed() -> void:
	$PopupUiComponent.show_ui()
	hide_buttons()

func _on_give_pressed() -> void:
	await hide_buttons()
	GameManager.round_manager.form_data.entity_count = 0
	GameManager.round_manager.form_data.conc = -1
	GameManager.round_manager.end_current_round()
	queue_free()

func _on_concluded(conc: bool) -> void:
	if conc:
		give_btn.disabled = false
