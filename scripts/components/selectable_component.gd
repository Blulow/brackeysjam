@tool
extends Node2D
class_name SelectableComponent

@onready var body: Node2D = get_parent()
@export var sprite: Sprite2D

signal selected
signal deselected
signal clicked

func _on_mouse_entered() -> void:
	if sprite.material: sprite.material.set_shader_parameter("show", true)
	selected.emit()

func _on_mouse_exited() -> void:
	if sprite.material: sprite.material.set_shader_parameter("show", false)
	deselected.emit()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				clicked.emit()
