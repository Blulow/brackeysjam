extends Control
class_name AnimatedTextComponent

@onready var label := get_parent()

@export var pauses: Dictionary = {
	"": 0.01,
	",": 0.3,
	".": 0.3,
	"?": 0.3,
	"!": 0.3
}
@export var sfx: AudioStream

var pending_skip: bool = false

signal animated

func _ready() -> void:
	if sfx: $AudioStreamPlayer.stream = sfx

func show_text(text: String, idx: int) -> void:
	label.text = text.substr(0, idx)

func animate(text: String) -> void:
	var char_count = text.length()
	
	for i in range(char_count):
		if pending_skip:
			show_text(text, text.length())
			pending_skip = false
			animated.emit()
			break
		
		var regex = RegEx.new()
		regex.compile(r"\[[^\]]+\]")
		var result = regex.search_all(text)
		
		var matches = result.map(func(e: RegExMatch): return [e.get_start(), e.get_end()])
		var richtext_idxs: Array[int]
		for m in matches:
			if i >= m[0] and i < m[1]:
				richtext_idxs.append(i)
		
		label.text = text.substr(0, i + 1)
		if sfx: $AudioStreamPlayer.play(randf_range(0, sfx.get_length()))
		
		if not i in richtext_idxs:
			await get_tree().create_timer(pauses[""]).timeout
		
		var current_char = text[i]
		if current_char in pauses:
			await get_tree().create_timer(pauses[current_char]).timeout
		
		if sfx: $AudioStreamPlayer.stop()
		
		if i >= char_count - 1:
			animated.emit()

func skip_animation() -> void:
	pending_skip = true
