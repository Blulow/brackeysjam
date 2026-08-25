extends Resource
class_name PeopleConfigSpeechValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: Speech

@export_group("Random Range")
@export var speeches: Array[Speech]

func get_value() -> Speech:
	if type == ValueType.RANDOM:
		return speeches.pick_random()
	return value
