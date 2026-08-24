extends Node3D

@onready var container: AligningContainer3D = $AligningContainer3D
@onready var feet_tex: TextureRect = $"../../FeetCamLayer/FeetCam/TextureRect"

var person_scene: PackedScene = preload("res://scenes/people/cam_person.tscn")
var people_data: Array[PersonConfig] = []

func _ready() -> void:
	people_data = GameManager.round_manager.people.people
	
	for config: PersonConfig in people_data:
		var person: CamPerson = person_scene.instantiate()
		container.add_child(person)
		person.apply_config(config)
	
	if GameManager.round_manager.people.singular: feet_tex.modulate = Color.RED
