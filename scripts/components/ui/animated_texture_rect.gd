@tool
class_name AnimatedTextureRect
extends TextureRect

@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value
		if sprite_frames and not animation in sprite_frames.get_animation_names():
			animation = "default"
		update_frame()

@export var animation: String = "default":
	set(value):
		animation = value
		frame = 0
		time_accumulator = 0.0
		update_frame()

@export var frame: int = 0:
	set(value):
		frame = value
		update_frame()

@export var fps: float = 10.0
@export var playing: bool = true

var time_accumulator: float = 0.0

func _process(delta: float) -> void:
	if not playing or not sprite_frames or Engine.is_editor_hint():
		return
		
	var frame_count = sprite_frames.get_frame_count(animation)
	if frame_count <= 1:
		return
		
	time_accumulator += delta
	if time_accumulator >= (1.0 / fps):
		time_accumulator -= (1.0 / fps)
		frame = (frame + 1) % frame_count

func update_frame() -> void:
	if sprite_frames and sprite_frames.has_animation(animation):
		if frame < sprite_frames.get_frame_count(animation):
			texture = sprite_frames.get_frame_texture(animation, frame)
