extends Control
	
func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_button_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()

func _on_button_2_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()
