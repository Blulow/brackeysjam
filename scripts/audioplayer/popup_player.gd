extends AudioStreamPlayer2D

@onready var popup_ui: PopupUiComponent = $"../PopupUiComponent"

@export var open: AudioStream
@export var close: AudioStream

func _ready() -> void:
	popup_ui.ui_shown.connect(_on_ui_shown)
	popup_ui.ui_hidden.connect(_on_ui_hidden)

func _on_ui_shown() -> void:
	stream = open
	play(0.12)
	
func _on_ui_hidden() -> void:
	stream = close
	play(0.12)
