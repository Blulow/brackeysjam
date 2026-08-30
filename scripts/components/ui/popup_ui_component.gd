extends Node2D
class_name PopupUiComponent

@export var fixed: bool = true
@export var ui: PackedScene

var ui_node: Control

signal ui_shown
signal ui_hidden

func show_ui() -> void:
	var u: Control = ui.instantiate()
	var popup_layer: CanvasLayer = get_tree().get_root().find_child("PopupUILayer", true, false)
	popup_layer.add_child(u)
	
	u.get_node("PopupComponent").popup_ui = self
	u.get_node("PopupOverlay").visible = fixed
	
	ui_node = u
	ui_shown.emit()
	
func hide_ui() -> void:
	ui_hidden.emit()
	ui_node.queue_free()
