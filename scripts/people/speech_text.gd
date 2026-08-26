extends Control

@onready var speaker_label: RichTextLabel = $MarginContainer/HBoxContainer/RichTextLabel
@onready var text_animator: AnimatedTextComponent = $MarginContainer/HBoxContainer/RichTextLabel2/AnimatedTextComponent

func set_speaker(speaker: String) -> void:
	speaker_label.push_bold()
	speaker_label.append_text(speaker + ":")
	speaker_label.pop()

func set_text(text: String) -> void:
	text_animator.animate(text)
