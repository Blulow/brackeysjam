extends Control

@onready var menu_world = $MenuWorld

func _ready() -> void:
	menu_world.switch_to_camera(4)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_button_2_pressed() -> void:
	$PopupUiComponent.show_ui()

func _on_button_3_pressed() -> void:
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	menu_world.switch_to_camera(1)

func _on_button_2_mouse_entered() -> void:
	menu_world.switch_to_camera(2)

func _on_button_3_mouse_entered() -> void:
	menu_world.switch_to_camera(3)

func _on_texture_rect_mouse_entered() -> void:
	menu_world.switch_to_camera(4)

func _on_button_4_pressed() -> void:
	GameManager.load_round($NumberSelector.number)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
