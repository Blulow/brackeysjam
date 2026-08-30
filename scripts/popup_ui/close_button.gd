extends TextureButton

func _on_clicked() -> void:
	var parent: Control = get_parent()
	while not parent.is_in_group("popup"):
		if parent == get_tree().get_root():
			parent = get_parent()
			break
		parent = parent.get_parent()
	
	parent.get_node("PopupComponent").close_ui()
