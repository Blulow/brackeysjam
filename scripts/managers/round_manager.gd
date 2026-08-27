extends Node2D
class_name RoundManager

@export var rounds: Array[Resource]

@onready var people_path: PathFollow2D = $"../World/PeopleArea/PeoplePath/PathFollow2D"
@onready var people: People = $"../World/PeopleArea/PeoplePath/PathFollow2D/People"
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

const PATH_SPEED: float = 0.01

var current_round: int = 5
var round_state: int = -1
enum RoundStates { START, STAY, END }

var form_data: Dictionary = {
	"entity_count": 0,
	"conc": -1
}
enum Conc { ACCEPT, REJECT }
var last_cam: int = 0
var shown_rules: int = 0

var penalties: int = 0
@export var penalty_speeches: Array[String]
@export var ending_dialogue: Array[String]

signal round_start
signal round_stay
signal round_end
signal round_done
signal concluded(conc: bool)

signal dialogue_set(dialogue: Array[String])
signal dialogue_finish
signal rule_shown(count: int)
signal penalized
signal game_over

func _ready() -> void:
	GameManager.round_manager = self
	start_round(current_round)

func _process(delta: float) -> void:
	match round_state:
		RoundStates.START:
			if people_path.progress_ratio < 0.5:
				people_path.progress_ratio += PATH_SPEED
			else:
				stay_current_round()
		RoundStates.STAY:
			pass
		RoundStates.END:
			if people_path.progress_ratio < 1.0:
				people_path.progress_ratio += PATH_SPEED
			else:
				round_done.emit()
				people_path.progress_ratio = 0

func start_round(idx: int) -> void:
	round_state = RoundStates.START
	
	people.set_people(rounds[current_round])
	round_start.emit()

func stay_current_round() -> void:
	round_state = RoundStates.STAY
	round_stay.emit()

func end_current_round() -> void:
	round_state = RoundStates.END
	round_end.emit()
	
	await round_done
	round_state = -1
	current_round += 1
	
	if current_round < rounds.size():
		start_round(current_round)
	else:
		$"../World/Objects/Phone".show_dialogue(ending_dialogue)
		$"../FXLayer/VictoryEnding".visible = true
		$"../FXLayer/GlitchEffect".visible = true
		anim_player.play("victory_ending")
		await anim_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/game_finished_screen.tscn")

func _on_round_end() -> void:
	for e in people.get_child(1).get_children():
		e.queue_free()

func _on_round_done() -> void:
	for e in people.get_child(0).get_children():
		e.queue_free()

func _on_rule_shown(count: int) -> void:
	shown_rules += count

func penalize(_form_data: Dictionary) -> void:
	var result = (_form_data.conc == Conc.REJECT) == people.singular
	
	if result: return
	penalties += 1
	penalized.emit()
	
	if penalties >= 3:
		game_over.emit()
