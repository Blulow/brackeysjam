extends Resource
class_name PeopleConfigIdentityValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: PersonIdentity

@export_group("Random Range")
@export var identities: Array[PersonIdentity]

func get_value() -> PersonIdentity:
	if type == ValueType.RANDOM:
		return identities.pick_random()
	return value
