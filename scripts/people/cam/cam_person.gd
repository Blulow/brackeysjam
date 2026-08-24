extends MeshInstance3D
class_name CamPerson

func apply_config(config: PersonConfig) -> void:
	get_surface_override_material(0).albedo_color = Color(Color.WHITE, 1.0 if config.shadow else 0.0)
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if config.shadow else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	if not config.view:
		reparent(get_parent().get_parent())
		var point: Vector2 = get_random_point_in_arc(Vector2(2.877, 0.0), 10.0, PI/2, 2*PI - PI/2)
		global_position = Vector3(point.x, 1.0, point.y)

func get_random_point_in_arc(center: Vector2, max_radius: float, min_angle: float, max_angle: float) -> Vector2:
	var random_angle := randf_range(min_angle, max_angle)
	var random_radius := max_radius * sqrt(randf())
	var direction := Vector2.from_angle(random_angle)
	return center + direction * random_radius
