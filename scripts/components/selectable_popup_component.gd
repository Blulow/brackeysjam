extends Node2D
class_name SelectablePopupComponent

@onready var selectable: SelectableComponent = get_parent().find_child("SelectableComponent")
@onready var popup: PopupUiComponent = get_parent().find_child("PopupUiComponent")

func _ready() -> void:
	selectable.clicked.connect(_on_clicked)

func _on_clicked() -> void:
	popup.show_ui()
