extends RoundManager
 
@export_multiline() var intro_dialogue: Array[String]

const MAX_INPUT_TIME: float = 5.0
var input_timer: float = 0.0
var pending_input: bool = false

func _ready() -> void:
	GameManager.round_manager = self
	$UI/Label.visible = false
	$PhoneLayer/Phone.show_dialogue(intro_dialogue)
	await dialogue_finish
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _process(delta: float) -> void:
	if input_timer >= MAX_INPUT_TIME:
		if !pending_input:
			$UI/Label.visible = true
			pending_input = true
	else:
		input_timer += delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$UI/Label.visible = false
			pending_input = false
			input_timer = 0

func _on_skip_pressed() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/game.tscn")
