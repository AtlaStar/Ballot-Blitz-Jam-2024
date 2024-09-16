extends Node

signal play(string)
signal pause
signal waiting
signal finished
signal next_text_panel(string)
signal choice(result)
signal destroyed
signal playhead_incremented(normalized_pos)


# Sequence of text before this Dialog Scene has ended
@export var text_for_panels: Array[String] = []
# value of the current text to draw. Used because we need to wait for the last update of the scene
# to occur
var text_current = -1
# Json's with option -> result pair
@export var options: Array[JSON] = []
@export var close_on_finish = false
@export_range(0.1, 1.5, 0.05) var text_speed
@export_range(0.0, 0.1)

var completion = 0.0

enum {
	PS_PLAYING,
	PS_PAUSED,
	PS_STOPPED,
	PS_AWAITING_INPUT,
	PS_FINISHED,
	PS_ERROR
}

var state = PS_ERROR

func _next_line():
	if text_current < text_for_panels.size() - 1:
		text_current += 1
	else:
		finished.emit()
	

func _pause_holder():
	state = PS_STOPPED

func _waiting():
	state = PS_AWAITING_INPUT
	
func _play():
	if state == PS_STOPPED:
		play.emit(get_string())
	state = PS_PLAYING
func _finished():
	print("finished")
	state = PS_FINISHED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = PS_PAUSED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(state)
	match state:
		PS_PLAYING:
			completion += 1/(get_string().length() + 1) * text_speed
			playhead_incremented.emit(completion)
			if completion >= 1.0:
				finished.emit()
		PS_STOPPED:
			completion = 0.0
		_:
			pass
	pass

func add_text(text: String):
	text_for_panels.push_back(text)

func remove_text_at(idx: int):
	text_for_panels.remove_at(idx)

func add_option(text: String):
	options.push_back(text)

func get_string():
	if text_current > -1:
		return text_for_panels[text_current]
	else:
		return ""
	
