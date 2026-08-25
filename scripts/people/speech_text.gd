extends Control

@onready var speaker_label: RichTextLabel = $MarginContainer/HBoxContainer/RichTextLabel
@onready var text_label: RichTextLabel = $MarginContainer/HBoxContainer/RichTextLabel2

func set_speaker(speaker: String) -> void:
	speaker_label.push_bold()
	speaker_label.append_text(speaker + ":")
	speaker_label.pop()

func set_text(text: String) -> void:
	text_label.append_text(text)
