extends Node2D

func _ready() -> void:
	$Alert.visible = false

func _on_rule_shown(count: int) -> void:
	$Alert.visible = true

func _on_clicked() -> void:
	$Alert.visible = false
