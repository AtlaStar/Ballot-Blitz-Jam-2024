extends Node

var bill_mad = false;
var susan_mad = false
var charles_mad = false;
var sammy_mad = false
var carol_mad = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bad_ending_test():
	return bill_mad && susan_mad && charles_mad && sammy_mad && carol_mad
func bill():
	bill_mad = true
func susan():
	susan_mad = true
func charles():
	charles_mad = true
func sammy():
	sammy_mad = true
func carol():
	carol_mad = true

func restart():
	Dialogic.VAR.reset()
