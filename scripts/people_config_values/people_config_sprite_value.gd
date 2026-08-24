extends Resource
class_name PeopleConfigSpriteValue

enum ValueType { FIXED, RANDOM }

@export var type: ValueType = ValueType.FIXED
@export var value: Texture2D

@export_group("Random Range")
@export var textures: Array[Texture2D]

func get_value() -> Texture2D:
	if type == ValueType.RANDOM:
		return textures.pick_random()
	return value
