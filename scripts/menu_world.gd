extends Node3D

@onready var cam1: Camera3D = $World/Cams/Camera3D
@onready var cam2: Camera3D = $World/Cams/Camera3D2
@onready var cam3: Camera3D = $World/Cams/Camera3D3
@onready var cam4: Camera3D = $World/Cams/Camera3D4
@onready var master: Camera3D = $World/Cams/MasterCam

func switch_to_camera(cam_idx: int) -> void:
	var tween = create_tween()
	var target_cam: Camera3D
	match cam_idx:
		1:
			target_cam = cam1
		2:
			target_cam = cam2
		3:
			target_cam = cam3
		4:
			target_cam = cam4
	
	tween.parallel().tween_property(master, "global_position", target_cam.global_position, 0.7)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(master, "global_rotation", target_cam.global_rotation, 0.7)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_OUT)
