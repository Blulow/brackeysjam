extends Node3D

@onready var camera_1: Camera3D = $Camera3D
@onready var camera_2: Camera3D = $Camera3D2
@onready var feet_cam: Control = $FeetCamLayer/FeetCam

var current_camera: Camera3D
var current_cam_idx: int = 0

func _ready() -> void:
	switch_cam(current_cam_idx)

func switch_cam(idx: int) -> void:
	match idx:
		0:
			current_camera = camera_1
			feet_cam.visible = false
		1:
			current_camera = camera_2
			feet_cam.visible = false
		2:
			current_camera = null
			feet_cam.visible = true
	
	current_cam_idx = idx
	if current_camera: current_camera.make_current()

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			if event.keycode == KEY_0:
				switch_cam(0)
			elif event.keycode == KEY_1:
				switch_cam(1)
			elif event.keycode == KEY_2:
				switch_cam(2)
