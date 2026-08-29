extends Control

@onready var label: RichTextLabel = $UI/AnimatedTextureRect/RichTextLabel
@onready var animator: AnimatedTextComponent = $UI/AnimatedTextureRect/RichTextLabel/AnimatedTextComponent
@onready var last_sol: RichTextLabel = $UI/LastSolution

var dialogue: Array[String]
var idx: int = 0
var animating: bool = false

func _ready() -> void:
	GameManager.round_manager.dialogue_set.connect(_on_dialogue_set)
	last_sol.visible = false

func _on_dialogue_set(_dialogue: Array[String]) -> void:
	dialogue = _dialogue
	
	if GameManager.round_manager.people and GameManager.round_manager.people.pending_penalization:
		show_last_solution(GameManager.round_manager.people.last_identities, GameManager.round_manager.people.last_singular)
	
	animating = true
	animator.animate(dialogue[idx])
	get_tree().get_root().find_child("PhoneLayer", true, false).layer += 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if animating:
				animating = false
				animator.skip_animation()
			else:
				animating = true
				advance_dialogue()

func advance_dialogue() -> void:
	idx += 1
	if idx >= dialogue.size():
		get_tree().paused = false
		get_tree().get_root().find_child("PhoneLayer", true, false).layer = 1
		GameManager.round_manager.dialogue_finish.emit()
		queue_free()
		return
	
	animator.animate(dialogue[idx])

func _on_animator_animated() -> void:
	animating = false

func show_last_solution(identities: Array[PersonIdentity], singular: bool) -> void:
	var counts: Dictionary = {}
	for identity in identities:
		var i: String = ""
		match identity.identity:
			PersonIdentity.Identity.ENTITY:
				i = "Entity"
			PersonIdentity.Identity.TWIN:
				i = "Twin"
			PersonIdentity.Identity.REFLECTION:
				i = "Reflection"
			PersonIdentity.Identity.CLONE:
				i = "Clone"
			PersonIdentity.Identity.DOLL:
				i = "Doll"
		
		if i in counts:
			counts[i] += 1
		else:
			counts[i] = 1
	
	var c_strings: Array[String]
	for c in counts:
		c_strings.append(str(counts[c]) + " " + c)
	
	var str: String = ", ".join(c_strings)
	last_sol.visible = true
	last_sol.text =\
	"[b]Last Solution:[/b]
	%s

	%s" %\
	[str,
	"[b][color=#f00]REJECT[/color][/b]"
	if singular else
	"[b][color=#0f0]ACCEPT[/color][/b]"]
