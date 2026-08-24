extends Node2D
class_name RoundManager

@onready var people_path: PathFollow2D = $"../World/PeopleArea/PeoplePath/PathFollow2D"

const PATH_SPEED: float = 0.01

var current_round: int = 0
var round_start: bool = false

func _ready() -> void:
	start_round(0)

func _process(delta: float) -> void:
	if not round_start: return
	
	if people_path.progress_ratio >= 1:
		people_path.progress_ratio = 0
		end_current_round()
	else:
		people_path.progress_ratio += PATH_SPEED

func start_round(idx: int) -> void:
	round_start = true

func end_current_round() -> void:
	round_start = false
	current_round += 1
