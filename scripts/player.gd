extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const WIGGLE_INI = 0

@export var x_rot = rotation.x
@export var increment = PI/16
@export_range(0.0005, 0.002) var factor = .002
@onready var cam = $Camera
@onready var text_node = $Interact
@onready var original_text = text_node.text
@export var sensitivity = 1.0

var look_rot : Vector2
var min_angle = -85
var max_angle = -min_angle
var wiggle = 0
var last_direction = Vector3(0.0,0.0,0.0)
var node_list = []
var character = null
var style
var motion = true;

var last_cam_rot = Vector3.ZERO
var last_player_rot = Vector3.ZERO

func _init():
	await Dialogic.ready
	style = Dialogic.Styles.load_style("speech_bubble_test")
	for node in get_tree().get_nodes_in_group("Characters"):
		await node.ready
		var id = node.get_node("BodyMesh3D/Area3D")
		id.facing_player.connect(access_dialogue.bind(id))
		id.look_towards = self
		style.register_character(id.npc_name, id.get_node("TextBubbleLocation"))

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Dialogic.timeline_ended.connect(reset_mouse_look)


func access_dialogue(id):
	character = null
	motion = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if id == null || Dialogic.current_timeline != null:
		return
	if id is Node3D:
		var layout = Dialogic.start(id.npc_name + "_timeline")

func reset_mouse_look():
	motion = true;
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	look_rot = Vector2(last_cam_rot.x, last_player_rot.y)

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	text_node.visible = !node_list.is_empty()
	
	if text_node.visible:
		var npc_name = node_list.front().npc_name
		text_node.text = original_text.format({"NPC": npc_name})
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if motion:
		if direction:
			wiggle += increment * direction.z
			last_direction = direction

			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if !is_equal_approx(cam.rotation.x, x_rot):
				wiggle += increment * last_direction.z
			else:
				last_direction = Vector3.ZERO
				wiggle = WIGGLE_INI;
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()
		cam.rotation.x = x_rot + cos(wiggle) * factor

		cam.rotation_degrees.x = look_rot.x
		rotation_degrees.y = look_rot.y
		last_cam_rot = cam.rotation_degrees
		last_player_rot = rotation_degrees
	
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 1000.0
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		match result.collider:
			var body when RigidBody3D:
				character = body.get_node("BodyMesh3D/Area3D")
					

func _input(event):
	if !motion:
		pass
	if event is InputEventMouseMotion:
		look_rot.y -= (event.screen_relative.x * sensitivity)
		look_rot.x -= (event.screen_relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		if character != null:
			character.dialogue_begin.emit(self)
