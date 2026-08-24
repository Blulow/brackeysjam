extends Node2D
class_name RoundManager

@onready var people_path: PathFollow2D = $"../World/PeopleArea/PeoplePath/PathFollow2D"

const PATH_SPEED: float = 0.01

var current_round: int = 0
var round_state: int = -1
# 0 - start, 1 - stay, 2 - end

signal round_start
signal round_stay
signal round_end

func _ready() -> void:
	GameManager.round_manager = self
	
	start_round(0)

func _process(delta: float) -> void:
	match round_state:
		0:
			if people_path.progress_ratio < 0.5:
				people_path.progress_ratio += PATH_SPEED
			else:
				stay_current_round()
		1:
			pass
		2:
			if people_path.progress_ratio < 1.0:
				people_path.progress_ratio += PATH_SPEED
			else:
				round_end.emit()
				people_path.progress_ratio = 0

func start_round(idx: int) -> void:
	round_state = 0
	round_start.emit()

func stay_current_round() -> void:
	round_state = 1
	round_stay.emit()

func end_current_round() -> void:
	round_state = 2
	
	await round_end
	round_state = -1
	current_round += 1
	
	start_round(current_round)
