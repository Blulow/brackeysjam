extends TextureRect

var points: Array[Vector2] = []
var scroll_speed := 200.0
var bpm := 72.0
#var time_passed := 0.0
var wave_offset := 0.0

const SAMPLE_SPACING := 1.0
const ECG_COLOR := Color("#39ff88")
const GRID_COLOR := Color(0.08, 0.25, 0.15, 0.5)

@export var heartbeats: Array[Heartrate]
@export var override: bool

func _ready():
	if override:
		for e in GameManager.round_manager.people.people:
			heartbeats.append(e.heart_rate)
	
	#for x in range(0, int(size.x) + 20, 4):
	for x in range(0, int(size.x) + 20, SAMPLE_SPACING):
		points.append(Vector2(x, size.y / 2.0))

	queue_redraw()

func _process(delta):
	#time_passed += delta
	wave_offset += scroll_speed * delta

	for i in range(points.size()):
		var x = points[i].x - scroll_speed * delta
		points[i].x = x

	# Remove points that have left the screen.
	while points.size() > 0 and points[0].x < 0:
		points.pop_front()

	# Add new ECG samples on the right.
	var last_x := points[-1].x if points.size() > 0 else size.x

	while last_x < size.x:
		#last_x += 4.0
		last_x += SAMPLE_SPACING

		var y := generate_combined_ecg(last_x)
		points.append(Vector2(last_x, y))

	queue_redraw()


func generate_heartbeat(x: float, bpm: float, amplitude: float, phase: float) -> float:
	var beat_time := 60.0 / bpm
	#var t := fmod(time_passed + x / scroll_speed + phase, beat_time)
	var t := fposmod((x + wave_offset) / scroll_speed + phase, beat_time)

	var y := 0

	# P wave
	y += -0.15 * amplitude * exp(-pow((t - 0.15) / 0.04, 2))
	# Q wave
	y += 0.20 * amplitude * exp(-pow((t - 0.25) / 0.01, 2))
	# R wave
	y += -1.3 * amplitude * exp(-pow((t - 0.27) / 0.02, 2))
	# S wave
	y += 0.45 * amplitude * exp(-pow((t - 0.29) / 0.06, 2))
	# T wave
	y += -0.24 * amplitude * exp(-pow((t - 0.43) / 0.06, 2))

	return y

func generate_combined_ecg(x: float) -> float:
	var center := size.y / 2.0
	
	var combined: float = 0.0
	for heartbeat: Heartrate in heartbeats:
		combined += generate_heartbeat(x, heartbeat.bpm, heartbeat.amp, heartbeat.pha)

	return combined + center

func _draw():
	# Background grid
	for x in range(0, int(size.x), 20):
		draw_line(
			Vector2(x, 0),
			Vector2(x, size.y),
			GRID_COLOR,
			1.0
		)

	for y in range(0, int(size.y), 20):
		draw_line(
			Vector2(0, y),
			Vector2(size.x, y),
			GRID_COLOR,
			1.0
		)

	# ECG line
	if points.size() > 1:
		for i in range(1, points.size()):
			draw_line(
				points[i - 1],
				points[i],
				ECG_COLOR,
				2.5,
				true
			)
