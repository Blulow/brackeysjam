extends Node2D
class_name People

@onready var container: HBoxContainer = $HBoxContainer
@onready var speech_container: HBoxContainer = $HBoxContainer2
var people_sprite_scene: PackedScene = preload("res://scenes/people/people_sprite.tscn")
var speech_text_scene: PackedScene = preload("res://scenes/people/speech_text.tscn")

var people: Array[PersonConfig] = []

var identities: Array[PersonIdentity]
var sprites: Array[Texture2D]
var views: Array[bool]
var shadows: Array[bool]
var heart_rates: Array[Heartrate]
var feet_views: Array[bool]
var speech_texts: Array[Speech]
var dialogue: Array[String]
var increment_rules: int
var singular: bool

var pending_penalization: bool = false
var pending_game_over: bool = false

var last_identities: Array[PersonIdentity]
var last_singular: bool

func set_people(config: PeopleConfig) -> void:
	identities = config.get_identities()
	sprites = config.get_sprites()
	views = config.get_views()
	shadows = config.get_shadows()
	heart_rates = config.get_heart_rates()
	feet_views = config.get_feet_views()
	speech_texts = config.get_speech_texts()
	dialogue = config.dialogue
	increment_rules = config.increment_rules
	
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
		person_config.sprite_name = sprites[i].resource_path.get_file().get_basename()
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
				
				person_config.shadow = true
				
			PersonIdentity.Identity.REFLECTION:
				if i >= 1:
					people_sprite.texture = sprites[i - 1]
				else:
					person_config.identity.identity = PersonIdentity.Identity.ENTITY
					people_sprite.texture = sprites[i]
				
				person_config.view = true
				person_config.shadow = false
				person_config.heart_rate = Heartrate.new()
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
				person_config.heart_rate = Heartrate.new()
				person_config.feet_view = false
				
		people_sprite.visible = views[i]
		container.add_child(people_sprite)
		
		people.append(person_config)
	
	singular = identities.filter(func(e: PersonIdentity): return e.identity == PersonIdentity.Identity.ENTITY or e.identity == PersonIdentity.Identity.TWIN).size() <= 1

func _on_round_stay() -> void:
	for i in people.size():
		if speech_texts[i].speaker == "" and speech_texts[i].text == "" or\
		not people[i].view or\
		not (people[i].identity.identity == PersonIdentity.Identity.ENTITY or people[i].identity.identity == PersonIdentity.Identity.TWIN or people[i].identity.identity == PersonIdentity.Identity.DOLL): break
		var speech_text: Control = speech_text_scene.instantiate()
		speech_container.add_child(speech_text)
		speech_text.set_speaker(speech_texts[i].speaker)
		speech_text.set_text(speech_texts[i].text)

func _on_round_start() -> void:
	if pending_penalization:
		dialogue.insert(0, GameManager.round_manager.penalty_speeches[GameManager.round_manager.penalties - 1])
		$"../../../../../PhoneLayer/Phone".break_lamp()
	
	if pending_game_over:
		dialogue.resize(1)
		$"../../../../../FXLayer/PenaltyEnding".visible = true
		$"../../../../../PhoneLayer".layer = 3
		$"../../../../../PopupUILayer".layer = 2
		$"../../../../../AudioStreamPlayer".stop()
		$"../../../../../AudioStreamPlayer".stream = load("res://assets/sounds/music/beforethestation.ogg")
		$"../../../../../AudioStreamPlayer".play()
	
	if increment_rules > 0:
		GameManager.round_manager.rule_shown.emit(increment_rules)
	if dialogue.size() > 0:
		$"../../../../../PhoneLayer/Phone".show_dialogue(dialogue)
		await GameManager.round_manager.dialogue_finish
		if pending_game_over: get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
	pending_penalization = false
	last_identities = identities
	last_singular = singular

func _on_penalized() -> void:
	pending_penalization = true

func _on_game_over() -> void:
	pending_game_over = true
