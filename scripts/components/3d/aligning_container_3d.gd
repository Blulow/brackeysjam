@tool
extends Node3D
class_name AligningContainer3D

enum AlignAxis { X, Y, Z }
enum AlignmentMode { BEGIN, CENTER }

@export var sort_axis: AlignAxis = AlignAxis.X:
	set(value):
		sort_axis = value
		queue_sort()
	
@export var alignment: AlignmentMode = AlignmentMode.CENTER:
	set(value):
		alignment = value
		queue_sort()
	
@export var reverse_order: bool = false:
	set(value):
		reverse_order = value
		queue_sort()
	
@export var separation: float = 2.0:
	set(value):
		separation = value
		queue_sort()

func _ready() -> void:
	# Trigger a sort when child nodes are added, removed, or reordered
	child_order_changed.connect(queue_sort)
	queue_sort()

func queue_sort() -> void:
	# Wait for the end of the frame to avoid redundant sorting calls
	if is_inside_tree():
		sort_children.call_deferred()

func sort_children() -> void:
	# 1. Filter out valid, visible 3D children
	var valid_children: Array[Node3D] = []
	for child in get_children():
		if child is Node3D and child.visible:
			valid_children.append(child)
			
	if valid_children.is_empty():
		return

	# 2. Reverse the array direction if the toggle is enabled
	if reverse_order:
		valid_children.reverse()

	# 3. Calculate the center offset modifier
	var center_offset: float = 0.0
	if alignment == AlignmentMode.CENTER:
		var total_length = (valid_children.size() - 1) * separation
		center_offset = total_length / 2.0

	# 4. Position the children
	var current_offset: float = 0.0
	for child in valid_children:
		var new_pos = Vector3.ZERO
		var final_position = current_offset - center_offset
		
		match sort_axis:
			AlignAxis.X:
				new_pos.x = final_position
			AlignAxis.Y:
				new_pos.y = final_position
			AlignAxis.Z:
				new_pos.z = final_position
				
		child.transform.origin = new_pos
		current_offset += separation
