extends Node3D


var owning_node = null
var ratio = 1;
var printing = false

signal awaiting_player

@export_range(0.1, 1.0, 0.05) var text_speed = 1.0
@onready var rich_text_node = $SubViewport/RichTextLabel
@onready var text_backdrop = $TextDisplay

@export var holders: Array[Resource]

var TextHolderNode = preload("res://text_holder.tscn")

var default_position
var holder_instance
# Called when the node enters the scene tree for the first time.
var is_finished = false

func _ready():
	holder_instance = TextHolderNode.instantiate()
	#add_child(holder_instance)
	owning_node = get_parent()
	default_position = position
	reset_text(owning_node.getString())
	
	rich_text_node.finished.connect(
		func():
			if is_equal_approx(rich_text_node.visible_ratio, 1.0):
				awaiting_player.emit()
	)
	#holder_instance.play.emit()
	#holder_instance.playhead_incremented.connect(debug)
	#holder_instance.finished.connect(detach)

func debug(val):
	print(val)
func detach():
	holder_instance.playhead_incremented.disconnect(debug)
	holder_instance.finished.disconnect(detach)

func reset_text(string):
	rich_text_node.visible_ratio = 0
	ratio = 1.0/string.length() * text_speed
	is_finished = false
	text_backdrop.visible = false
	#rich_text_node.text = "[center]" + string + "[/center]"

func process_text():
	text_backdrop.visible = true
	var value = clamp(rich_text_node.visible_ratio + ratio, 0.0, 1.0)
	rich_text_node.visible_ratio = value
	is_finished = is_equal_approx(value, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if printing:
		process_text()
	pass
