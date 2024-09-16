extends Area3D

@export var npc_name = "null"
@export var follow_player = true
var current_string = 0
var tween = null
var look_towards = null
var look_at_point = null
#var UIRoot = preload("res://local_ui_root/scene.tscn")
var local_root = null
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#local_root = UIRoot.instantiate()
	#add_child(local_root)
	#local_root.get_node("TextDisplay").position = position
	area_entered.connect(area_entered_delegate)
	area_exited.connect(area_exited_delegate)
	pass # Replace with function body.

func look_towards_area(target):
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_method(
		set_owner_transform,
		owner.transform,
		owner.transform.looking_at(target.owner.position, Vector3(0,1,0), true),
		0.2
	).set_ease(Tween.EASE_IN_OUT)

func set_owner_transform(new_transform):
	owner.transform = new_transform

func area_entered_delegate(_dummy):
	look_towards = _dummy
	EventBus.playerEntered.emit(self)
func area_exited_delegate(_dummy):
	look_towards = null
	EventBus.playerLeft.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !follow_player:
		return
	if has_overlapping_areas() && look_towards != null:
		if look_at_point != look_towards.owner.position:
			look_at_point = look_towards.owner.position
			look_towards_area(look_towards)
	pass
