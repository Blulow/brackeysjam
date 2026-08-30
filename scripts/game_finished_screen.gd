extends Control

var noise := FastNoiseLite.new()

@export var base_alpha: float = 0.6
@export var flicker_strength: float = 0.25
@export var flicker_speed: float = 4.0
@export var rotation_strength: float = 16
@export var rotation_speed: float = 0.7

var flickering: bool = false
var flicker_time: float = randf() * 0.3
var timer: float = 0.0

func _ready() -> void:
	$UI.visible = false
	noise.seed = randi()
	noise.frequency = 1.5

func _process(delta: float) -> void:
	var n := noise.get_noise_1d(timer * flicker_speed)
	var alpha := base_alpha + n * flicker_strength

	$Label.modulate.a = alpha
	$Label2.modulate.a = alpha
	if timer >= flicker_time:
		var min = -PI/rotation_strength
		var max = PI/rotation_strength
		$Label.rotation = (randf() * (max - (min))) + (min)
		$Label2.rotation = (randf() * (max - (min))) + (min)
		if randf() < 0.3:
			$Label2.text = "YOU ARE [color=#f00]REJECTED[/color]"
		else:
			$Label2.text = "YOU ARE REJECTED"
		flicker_time = randf() * rotation_speed
		flickering = false
	timer += delta

func _on_timer_timeout() -> void:
	$Label.visible = false
	$Label2.visible = false
	await get_tree().create_timer(0.5).timeout
	$UI.visible = true

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_button_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()

func _on_button_2_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()
