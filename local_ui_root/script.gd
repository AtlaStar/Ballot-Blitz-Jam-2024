
extends DialogicLayoutBase

## This layout won't do anything on its own

var registered_characters: Dictionary = {}
@onready var Display = $TextDisplay
var mesh
@export_group("Main")
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogicUtil.autoload().Text.about_to_show_text.connect(_on_dialogic_text_event)

func _process(_delta):
	if mesh != null:
		Display.rotation = mesh.rotation
		Display.position = mesh.position + Vector3(0.0,1.0,0.0)
	pass

func register_character(character:Variant, node:RigidBody3D):
	if typeof(character) == TYPE_STRING:
		var character_string: String = character
		if character.begins_with("res://"):
			character = load(character)
		else:
			character = DialogicResourceUtil.get_character_resource(character)
		if not character:
			printerr("[Dialogic] Textbubble: Tried registering character from invalid string '", character_string, "'.")
	mesh = node
	registered_characters[character] = node


func _get_persistent_info() -> Dictionary:
	return {"3DTextRegisters": registered_characters}


func _load_persistent_info(info: Dictionary) -> void:
	var register_info: Dictionary = info.get("3DTextRegisters", {})
	for character in register_info:
		if is_instance_valid(register_info[character]):
			register_character(character, register_info[character])


func _on_dialogic_text_event(info:Dictionary):
	pass
