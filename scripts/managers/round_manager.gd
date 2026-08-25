extends Node2D
class_name RoundManager

@export var rounds: Array[Resource]

@onready var people_path: PathFollow2D = $"../World/PeopleArea/PeoplePath/PathFollow2D"
@onready var people: People = $"../World/PeopleArea/PeoplePath/PathFollow2D/People"

const PATH_SPEED: float = 0.01

var current_round: int = 0
var round_state: int = -1
enum RoundStates { START, STAY, END }

var form_data: Dictionary = {
	"entity_count": 0,
	"conc": -1
}
enum Conc { ACCEPT, REJECT }

signal round_start
signal round_stay
signal round_end
signal round_done
signal concluded(conc: bool)

signal dialogue_set(dialogue: Array[String])

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
		print("game end")

func _on_round_end() -> void:
	for e in people.get_child(1).get_children():
		e.queue_free()

func _on_round_done() -> void:
	for e in people.get_child(0).get_children():
		e.queue_free()
