extends Node2D

func _on_clicked() -> void:
	spawn_paper()

func spawn_paper() -> void:
	var world: Node2D = get_tree().get_root().find_child("World", true, false)
	if world.has_node("Paper"): return #already has paper
	
	var paper: Node2D = preload("res://scenes/objects/paper.tscn").instantiate()
	world.add_child(paper)
	
	paper.global_position = Vector2(-21.0, 314.0)
	$AudioStreamPlayer2D.play()
