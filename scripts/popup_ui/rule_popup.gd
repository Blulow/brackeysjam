extends Control

@onready var rule_container: VBoxContainer = $UI/TextureRect/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer
var rule_label_scene: PackedScene = preload("res://scenes/popup_ui/ui/rule_label.tscn")

@export var rules: Array[String] = [
	"Only accept encounters with more than 2 people",
]

var shown_rules: int = 1

func _ready() -> void:
	show_rules(shown_rules)

func show_rules(count: int) -> void:
	for i in range(count):
		var rule_label: Label = rule_label_scene.instantiate()
		rule_container.add_child(rule_label)
		rule_label.text = "%d. %s" % [i + 1, rules[i]]

func increment_rules(count: int) -> void:
	shown_rules += count
	show_rules(shown_rules)
