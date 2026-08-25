extends Control

@onready var cam: Node3D = $UI/PanelContainer/HBoxContainer/TextureRect/SubViewportContainer/SubViewport/SecurityCamera

var cams: Array[int] = [0, 1, 2]

func _on_left_button_pressed() -> void:
	var i: int = cams.find(cam.current_cam_idx)
	if i <= 0:
		cam.switch_cam(cams[-1])
	else:
		cam.switch_cam(cams[i - 1])

func _on_right_button_pressed() -> void:
	var i: int = cams.find(cam.current_cam_idx)
	if i >= cams.size() - 1:
		cam.switch_cam(cams[0])
	else:
		cam.switch_cam(cams[i + 1])
