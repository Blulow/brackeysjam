extends Node2D

func show_dialogue(dialogue: Array[String]) -> void:
	get_tree().paused = true
	$PopupUiComponent.show_ui()
	GameManager.round_manager.dialogue_set.emit(dialogue)

func break_lamp() -> void:
	$Lamps.break_lamp()
