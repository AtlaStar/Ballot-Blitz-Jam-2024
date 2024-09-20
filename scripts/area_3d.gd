extends Area3D

@export var npc_name = "null"
@export var follow_player = true
var current_string = 0
var tween = null
var look_towards = null
var look_at_point = null
signal dialogue_begin(target)
signal facing_player()
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if follow_player:
		dialogue_begin.connect(look_towards_area)
	pass # Replace with function body.

func look_towards_area(target):
	if target == null:
		pass
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_method(
		set_owner_transform,
		owner.transform,
		owner.transform.looking_at(target.position, Vector3(0,1,0), true),
		0.2
	).set_ease(Tween.EASE_IN_OUT)

func set_owner_transform(new_transform):
	owner.transform = new_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if tween != null && tween.get_loops_left() == 0:
		tween = null
		facing_player.emit()
	pass
