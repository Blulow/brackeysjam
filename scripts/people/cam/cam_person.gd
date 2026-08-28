extends MeshInstance3D
class_name CamPerson

@onready var model_of_sprite: Dictionary[String, Node3D] = {
	"people_sprite_1": $CamPerson/cam_people,
	"people_sprite_2": $CamPerson/cam_people_2,
	"people_sprite_3": $CamPerson/cam_people_3,
	"people_sprite_4": $CamPerson/cam_people_4,
	"people_sprite_5": $CamPerson/cam_people_5,
	"people_sprite_6": $CamPerson/cam_people_6,
	"people_sprite_7": $CamPerson/cam_people_7,
	"people_sprite_8": $CamPerson/cam_people_8,
	"people_sprite_9": $CamPerson/cam_people_9,
	"people_sprite_39": $CamPerson/cam_people_39
}

func _ready() -> void:
	for c in $CamPerson.get_children():
		c.visible = false

func apply_config(config: PersonConfig) -> void:
	if config.sprite_name in model_of_sprite:
		model_of_sprite[config.sprite_name].visible = true
	#get_surface_override_material(0).albedo_color = Color(Color.WHITE, 1.0 if config.shadow else 0.0)
	$CamPerson.visible = config.shadow
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if config.shadow else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	if not config.view:
		reparent(get_parent().get_parent())
		var point: Vector2 = get_random_point_in_arc(Vector2(2.877, 0.0), 10.0, PI/2, 2*PI - PI/2)
		global_position = Vector3(point.x, 1.0, point.y)
		global_rotation.y = randf() * TAU

func get_random_point_in_arc(center: Vector2, max_radius: float, min_angle: float, max_angle: float) -> Vector2:
	var random_angle := randf_range(min_angle, max_angle)
	var random_radius := max_radius * sqrt(randf())
	var direction := Vector2.from_angle(random_angle)
	return center + direction * random_radius
