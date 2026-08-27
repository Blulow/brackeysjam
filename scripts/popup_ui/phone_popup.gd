extends Control

@onready var label: RichTextLabel = $UI/AnimatedTextureRect/RichTextLabel
@onready var animator: AnimatedTextComponent = $UI/AnimatedTextureRect/RichTextLabel/AnimatedTextComponent

var dialogue: Array[String]
var idx: int = 0
var animating: bool = false

func _ready() -> void:
	GameManager.round_manager.dialogue_set.connect(_on_dialogue_set)

func _on_dialogue_set(_dialogue: Array[String]) -> void:
	dialogue = _dialogue
	animating = true
	animator.animate(dialogue[idx])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if animating:
				animating = false
				animator.skip_animation()
			else:
				animating = true
				advance_dialogue()

func advance_dialogue() -> void:
	idx += 1
	if idx >= dialogue.size():
		get_tree().paused = false
		GameManager.round_manager.dialogue_finish.emit()
		queue_free()
		return
	
	animator.animate(dialogue[idx])

func _on_animator_animated() -> void:
	animating = false
