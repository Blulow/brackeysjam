extends Node2D
class_name People

@onready var container: HBoxContainer = $HBoxContainer
var people_sprite_scene: PackedScene = preload("res://scenes/people/people_sprite.tscn")

var shadows: Array[bool]
var heart_rates: Array[float]
var feet_views: Array[bool]
var speech_texts: Array[String]
var singular: bool

func set_people(config: PeopleConfig) -> void:
	for i: int in range(config.get_count()):
		var people_sprite: TextureRect = people_sprite_scene.instantiate()
		
		if i >= min(
			config.get_sprites().size(),
			config.get_views().size(),
			config.get_shadows().size(),
			config.get_heart_rates().size(),
			config.get_feet_views().size(),
			config.get_speech_texts().size()): return
		
		people_sprite.texture = config.get_sprites()[i]
		people_sprite.visible = config.get_views()[i]
		container.add_child(people_sprite)
	
	shadows = config.get_shadows()
	heart_rates = config.get_heart_rates()
	feet_views = config.get_feet_views()
	speech_texts = config.get_speech_texts()
	singular = config.check_singular()
