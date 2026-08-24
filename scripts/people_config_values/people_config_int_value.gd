extends Resource
class_name PeopleConfigIntValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: int = 0

@export_group("Random Range")
@export var min: int = 0
@export var max: int = 20

func get_value() -> int:
	if type == ValueType.RANDOM:
		return randi_range(min, max)
	return value
