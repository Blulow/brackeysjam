extends TextureRect

var feet_count: int

const MAX_POINT_RADIUS: float = 150
const MIN_FEET_GAP: float = 120

enum FootRegion { BIGTOE, TOES, FOREFOOT, SIDE, ARCH, HEEL }
var foot_regions: Dictionary = {
	FootRegion.BIGTOE: {
		"region": [
			Vector2(0.1, 0.9),
			Vector2(0.4, 0.9),
			Vector2(0.1, 0.85)
		],
		"center": Vector2(0.15, 0.875)
	},
	FootRegion.TOES: {
		"region": [
			Vector2(0.1, 0.95),
			Vector2(0.9, 0.95),
			Vector2(0.9, 0.85),
			Vector2(0.1, 0.85)
		],
		"center": Vector2(0.15, 0.875)
	},
	FootRegion.FOREFOOT: {
		"region": [
			Vector2(0.1, 0.8),
			Vector2(0.9, 0.8),
			Vector2(0.8, 0.6)
		],
		"center": Vector2(0.45, 0.75)
	},
	FootRegion.SIDE: {
		"region": [
			Vector2(0.6, 0.65),
			Vector2(0.85, 0.65),
			Vector2(0.8, 0.4)
		],
		"center": Vector2(0.75, 0.55)
	},
	FootRegion.ARCH: {
		"region": [
			Vector2(0.1, 0.8),
			Vector2(0.6, 0.65),
			Vector2(0.85, 0.25),
			Vector2(0.3, 0.25)
		],
		"center": Vector2(0.6, 0.5)
	},
	FootRegion.HEEL: {
		"region": [
			Vector2(0.2, 0.25),
			Vector2(0.8, 0.25),
			Vector2(0.5, 0.05)
		],
		"center": Vector2(0.5, 0.175)
	},
}

var pressure_points: Array[Vector2]
var pressure_radii: Array[float]

func _ready() -> void:
	feet_count = GameManager.round_manager.people.people.filter(func(e): return e.feet_view).size()
	show_feet(feet_count)

func show_feet(count: int) -> void:
	var foot_dim: Vector2 = Vector2(min(1080 / count - MIN_FEET_GAP, 400), 900)
	
	for i in count:
		var feet_points: Array[Vector2]
		var feet_radii: Array[float]
		var left_points = get_rotated_points(\
			generate_pressure_points(foot_dim), foot_dim / 2, PI)
		var left_radii = generate_pressure_radii(left_points, foot_dim)
		var right_points = get_reflected_points(\
			get_rotated_points(\
				generate_pressure_points(foot_dim), foot_dim / 2, PI),\
				Vector2(foot_dim.x / 2, 0),\
				Vector2(foot_dim.x / 2, foot_dim.y))
		var right_radii = generate_pressure_radii(right_points, foot_dim)
		
		var alt_left_points: Array[Vector2] = get_rotated_points(left_points, foot_dim / 2, randf() * -PI / 16)
		var alt_right_points: Array[Vector2]
		alt_right_points.assign(get_rotated_points(right_points, foot_dim / 2, randf() * PI / 16)\
				.map(func(e): return e + Vector2(foot_dim.x, 0)))
		
		feet_points.assign(\
			(alt_left_points + alt_right_points).map(func(e): return e + Vector2(foot_dim.x * 2 * i + (randf() * 100 + MIN_FEET_GAP), randf() * 100 - 50)))
		feet_radii = left_radii + right_radii
		
		pressure_points.append_array(feet_points)
		pressure_radii.append_array(feet_radii)
	
	material.set_shader_parameter("pressure_points", pressure_points.map(func(e): return e + size / 2 - (foot_dim * Vector2(2 * count, 1) + Vector2(MIN_FEET_GAP * feet_count, 0)) / 2))
	material.set_shader_parameter("pressure_radii", pressure_radii)

func get_reflected_points(points: Array[Vector2], a: Vector2, b: Vector2) -> Array[Vector2]:
	var reflected: Array[Vector2]
	for p in points:
		var ab: Vector2 = b - a
		var ap: Vector2 = p - a
		
		# Project ap onto ab to find the closest point on the line segment
		var t: float = ap.dot(ab) / ab.dot(ab)
		var proj: Vector2 = a + t * ab
		
		# Reflect the point across the projection
		reflected.append(2.0 * proj - p)
	return reflected

func get_rotated_points(points: Array[Vector2], pivot: Vector2, angle: float) -> Array[Vector2]:
	var rotated: Array[Vector2]
	for p in points:
		var dir = p - pivot
		dir = dir.rotated(angle)
		rotated.append(dir + pivot)
	return rotated

func generate_pressure_radii(points: Array[Vector2], foot_dim: Vector2) -> Array[float]:
	var radii: Array[float]
	
	for p in points:
		var radius: float
		if randf() < 0.3: radius = randf() * MAX_POINT_RADIUS
		else:
			radius = (p / foot_dim).distance_to(Vector2(0.5, 0.5)) * MAX_POINT_RADIUS
		
		radii.append(radius)
	
	return radii

func generate_pressure_points(foot_dim: Vector2, left: bool = true) -> Array[Vector2]:
	var points: Array[Vector2]
	
	var count: int = 100
	for i in range(count):
		var weighted_region: FootRegion = get_weighted_region()
		var foot_region: Array[Vector2]
		foot_region.assign(foot_regions[weighted_region].region)
		var point: Vector2 = get_weighted_random_point(foot_region, foot_regions[weighted_region].center)
		var scaled_point: Vector2 = foot_dim * point
		points.append(scaled_point)
	
	return points

func get_weighted_region() -> FootRegion:
	var region: FootRegion
	
	var r = randf()
	if r >= 0.94 and r < 1.00: # 6%
		region = FootRegion.BIGTOE
	elif r >= 0.91 and r < 0.94: # 3%
		region = FootRegion.TOES
	elif r >= 0.41 and r < 0.91: # 50%
		region = FootRegion.FOREFOOT
	elif r >= 0.31 and r < 0.41: # 10%
		region = FootRegion.SIDE
	elif r >= 0.28 and r < 0.31: # 3%
		region = FootRegion.ARCH
	elif r >= 0.00 and r < 0.28: # 28%
		region = FootRegion.HEEL
	
	return region

func get_weighted_random_point(polygon: Array[Vector2], center_point: Vector2, falloff: float = 2.0) -> Vector2:
	if polygon.size() < 3:
		push_error("Polygon must have at least 3 vertices.")
		return Vector2.ZERO
		
	# 1. Find the Bounding Box (AABB) of the polygon
	var min_x := polygon[0].x
	var max_x := polygon[0].x
	var min_y := polygon[0].y
	var max_y := polygon[0].y
	
	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
		
	# Calculate maximum possible distance within the bounding box for normalization
	var max_possible_dist := Vector2(min_x, min_y).distance_to(Vector2(max_x, max_y))
	if max_possible_dist == 0:
		return center_point

	# 2. Rejection Sampling Loop
	var attempts := 0
	const MAX_ATTEMPTS := 2000 # Prevents infinite loops in edge-case geometries
	
	while attempts < MAX_ATTEMPTS:
		attempts += 1
		
		# Pick a random candidate position within the bounding box bounds
		var candidate = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
		
		# Check if the candidate point is physically inside the polygon geometry
		if Geometry2D.is_point_in_polygon(candidate, polygon):
			# Calculate normalized distance from the center (0.0 = at center, 1.0 = far away)
			var dist := candidate.distance_to(center_point)
			var normalized_dist := clampf(dist / max_possible_dist, 0.0, 1.0)
			
			# Probability curve: Closer points yield values near 1.0; far points drop near 0.0
			var spawn_probability := pow(1.0 - normalized_dist, falloff)
			
			# Roll a random dice to determine whether to accept this point
			if randf() < spawn_probability:
				return candidate
				
	# Fallback safety if the polygon is extremely thin or highly constrained
	return center_point
	
