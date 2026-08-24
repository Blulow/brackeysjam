extends Node2D
class_name People

@onready var container: HBoxContainer = $HBoxContainer
var people_sprite_scene: PackedScene = preload("res://scenes/people/people_sprite.tscn")

var people: Array[PersonConfig] = []

var identities: Array[PersonIdentity]
var sprites: Array[Texture2D]
var views: Array[bool]
var shadows: Array[bool]
var heart_rates: Array[float]
var feet_views: Array[bool]
var speech_texts: Array[String]
var singular: bool

func set_people(config: PeopleConfig) -> void:
	identities = config.get_identities()
	sprites = config.get_sprites()
	views = config.get_views()
	shadows = config.get_shadows()
	heart_rates = config.get_heart_rates()
	feet_views = config.get_feet_views()
	speech_texts = config.get_speech_texts()
	
	people.clear()
	for i: int in range(config.get_count()):
		var people_sprite: TextureRect = people_sprite_scene.instantiate()
		
		if i >= min(
			identities.size(),
			sprites.size(),
			views.size(),
			shadows.size(),
			heart_rates.size(),
			feet_views.size(),
			speech_texts.size()): break
		
		var person_config: PersonConfig = PersonConfig.new()
		person_config.identity = identities[i]
		person_config.view = views[i]
		person_config.shadow = shadows[i]
		person_config.heart_rate = heart_rates[i]
		person_config.feet_view = feet_views[i]
		
		match person_config.identity.identity:
			PersonIdentity.Identity.ENTITY:
				people_sprite.texture = sprites[i]
				
				person_config.shadow = true
				
			PersonIdentity.Identity.TWIN:
				if i >= 1:
					people_sprite.texture = sprites[i - 1]
				else:
					person_config.identity.identity = PersonIdentity.Identity.ENTITY
					people_sprite.texture = sprites[i]
				
				person_config.view = true
				person_config.shadow = true
				person_config.feet_view = true
				
			PersonIdentity.Identity.REFLECTION:
				if i >= 1:
					people_sprite.texture = sprites[i - 1]
				else:
					person_config.identity.identity = PersonIdentity.Identity.ENTITY
					people_sprite.texture = sprites[i]
				
				person_config.view = true
				person_config.shadow = false
				person_config.heart_rate = 0
				person_config.feet_view = false
				
			PersonIdentity.Identity.CLONE:
				if i >= 1:
					people_sprite.texture = sprites[i - 1]
					person_config.heart_rate = heart_rates[i - 1]
				else:
					person_config.identity.identity = PersonIdentity.Identity.ENTITY
					people_sprite.texture = sprites[i]
				
				person_config.shadow = true
				
			PersonIdentity.Identity.DOLL:
				people_sprite.texture = sprites[i]
				
				person_config.shadow = true
				person_config.heart_rate = 0
				person_config.feet_view = false
				
		people_sprite.visible = views[i]
		container.add_child(people_sprite)
		
		people.append(person_config)
	
	singular = identities.filter(func(e: PersonIdentity): return e.identity == PersonIdentity.Identity.ENTITY or e.identity == PersonIdentity.Identity.TWIN).size() <= 1
