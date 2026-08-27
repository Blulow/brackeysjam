extends Node2D

var lamp_count: int = 3

func _ready() -> void:
	for l: AnimatedSprite2D in get_children():
		l.animation = "default"

func break_lamp() -> void:
	lamp_count -= 1
	var lamp: AnimatedSprite2D = get_child(2 - lamp_count)
	lamp.play("break")
	await lamp.animation_finished
	lamp.play("broken")
