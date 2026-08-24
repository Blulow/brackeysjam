extends Resource
class_name PeopleConfigSpeechValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: String = ""

@export_group("Random Range")
@export var speeches: Array[String]

func get_value() -> String:
	if type == ValueType.RANDOM:
		return speeches.pick_random()
	return value
