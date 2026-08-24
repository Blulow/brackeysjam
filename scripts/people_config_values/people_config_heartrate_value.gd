extends Resource
class_name PeopleConfigHeartrateValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: Heartrate

@export_group("Random Range")
@export var heartrates: Array[Heartrate]

func get_value() -> Heartrate:
	if type == ValueType.RANDOM:
		return heartrates.pick_random()
	return value
