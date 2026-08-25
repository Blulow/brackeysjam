extends HBoxContainer
class_name NumberSelector

@export var number: int = 0
@export var min: int = -10000
@export var max: int = 10000

signal number_update(num: int)

func _ready() -> void:
	update_display()

func _on_texture_button_pressed() -> void:
	if number <= min: return
	number -= 1
	update_display()

func _on_texture_button_2_pressed() -> void:
	if number >= max: return
	number += 1
	update_display()

func update_display() -> void:
	$Label.text = str(number)
	number_update.emit(number)
