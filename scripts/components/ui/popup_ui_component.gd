extends Node2D
class_name PopupUiComponent

@export var fixed: bool = true
@export var ui: PackedScene

var ui_node: Control

func show_ui() -> void:
	var u: Control = ui.instantiate()
	var popup_layer: CanvasLayer = get_tree().get_root().find_child("PopupUILayer", true, false)
	popup_layer.add_child(u)
	
	u.get_node("PopupOverlay").visible = fixed
	
	ui_node = u
	
func hide_ui() -> void:
	ui_node.queue_free()
