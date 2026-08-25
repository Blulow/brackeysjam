extends Resource
class_name PeopleConfig

@export var count: PeopleConfigIntValue
@export var identities: Array[PeopleConfigIdentityValue]
@export var sprites: Array[PeopleConfigSpriteValue]
@export var views: Array[PeopleConfigBoolValue]
@export var shadows: Array[PeopleConfigBoolValue]
@export var heart_rates: Array[PeopleConfigHeartrateValue]
@export var feet_views: Array[PeopleConfigBoolValue]
@export var speech_texts: Array[PeopleConfigSpeechValue]
@export var dialogue: Array[String]

func get_count() -> int:
	return count.get_value()
func get_identities() -> Array[PersonIdentity]:
	var array: Array[PersonIdentity] = []
	array.assign(get_values(identities))
	return array
func get_sprites() -> Array[Texture2D]:
	var array: Array[Texture2D] = []
	array.assign(get_values(sprites))
	return array
func get_views() -> Array[bool]:
	var array: Array[bool] = []
	array.assign(get_values(views))
	return array
func get_shadows() -> Array[bool]:
	var array: Array[bool] = []
	array.assign(get_values(shadows))
	return array
func get_heart_rates() -> Array[Heartrate]:
	var array: Array[Heartrate] = []
	array.assign(get_values(heart_rates))
	return array
func get_feet_views() -> Array[bool]:
	var array: Array[bool] = []
	array.assign(get_values(feet_views))
	return array
func get_speech_texts() -> Array[Speech]:
	var array: Array[Speech] = []
	array.assign(get_values(speech_texts))
	return array

func get_values(values: Array) -> Array:
	var array: Array
	for e in values:
		array.append(e.get_value())
	return array

func check_singular() -> bool:
	return true
