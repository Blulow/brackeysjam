extends Control

@export var downscale: float = 0.8
@export var animation_length: float = 0.05

@onready var button: BaseButton = get_parent()

signal clicked

func _ready() -> void:
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)

func _on_button_down() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2.ONE * downscale, animation_length)

func _on_button_up() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2.ONE, animation_length)
	
	await tween.finished
	clicked.emit()
