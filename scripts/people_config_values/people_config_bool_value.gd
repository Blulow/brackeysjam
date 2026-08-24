extends Resource
class_name PeopleConfigBoolValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: bool = false

func get_value() -> bool:
	if type == ValueType.RANDOM:
		return randf() > 0.5
	return value
