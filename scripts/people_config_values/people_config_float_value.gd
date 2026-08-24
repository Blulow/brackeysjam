extends Resource
class_name PeopleConfigFloatValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: float = 0.0

@export_group("Random Range")
@export var min: float = 0.0
@export var max: float = 20.0

func get_value() -> float:
	if type == ValueType.RANDOM:
		return randf_range(min, max)
	return value
