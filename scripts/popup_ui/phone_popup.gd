extends Control

@onready var label: RichTextLabel = $UI/TextureRect/RichTextLabel

var dialogue: Array[String]
var idx: int = 0

func _ready() -> void:
	GameManager.round_manager.dialogue_set.connect(_on_dialogue_set)

func _on_dialogue_set(_dialogue: Array[String]) -> void:
	dialogue = _dialogue
	label.clear()
	label.append_text(dialogue[idx])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			advance_dialogue()

func advance_dialogue() -> void:
	idx += 1
	if idx >= dialogue.size():
		get_tree().paused = false
		queue_free()
		return
	
	label.clear()
	label.append_text(dialogue[idx])
