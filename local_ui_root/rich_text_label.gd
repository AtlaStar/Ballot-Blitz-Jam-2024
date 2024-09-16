extends RichTextLabel

@export var text_path = "res://text_holder.tscn"
var TextHolderNode = load(text_path)
# Called when the node enters the scene tree for the first time.
var holder
func _ready() -> void:

	holder = TextHolderNode.instantiate()
	add_child(holder)
	holder.play.connect(set_text)
	holder.next_text_panel.connect(set_text)
	holder.playhead_incremented.connect(set_visible_ratio)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
