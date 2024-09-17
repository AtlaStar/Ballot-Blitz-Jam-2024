extends Node

#horrible, non-extensible, hard coded madness
var _bill = {"mad": false, "happy": false}
var _susan = {"mad": false, "happy": false}
var _charles = {"mad": false, "happy": false};
var _sammy = {"mad": false, "happy": false}
var _carol= {"mad": false, "happy": false};


func _process(_delta):
	var debug = Input.is_action_pressed("ui_cancel")
	if debug == true:
		if Input.is_action_pressed("ui_text_backspace"):
			restart()
		if Input.is_action_pressed("ui_left"):
			bill("mad")
			susan("mad")
			charles("mad")
			sammy("mad")
			carol("mad")
		if Input.is_action_pressed("ui_right"):
			bill("happy")
			susan("happy")
			charles("happy")
			sammy("happy")
			carol("happy")
		if Input.is_action_pressed("ui_right"):
			bill("happy")
			susan("happy")
			charles("happy")
			sammy("happy")
			carol("mad")
func bad_ending_test():
	return _bill["mad"] && _susan["mad"] && _charles["mad"] && _sammy["mad"] && _carol["mad"]
func good_ending_test():
	return _bill["happy"] && _susan["happy"] && _charles["happy"] && _sammy["happy"] && _carol["happy"]
func ending_test():
	print()
	return (
		(get_true_count(_bill) as int)
		+ (get_true_count(_susan) as int)
		+ (get_true_count(_charles) as int)
		+ (get_true_count(_sammy) as int)
		+ (get_true_count(_carol) as int)
	) == 5.0
	
func get_true_count(hash):
	return hash.values().count(true) >= 1
	
func bill(val):
	_bill[val] = true
func susan(val):
	_susan[val]  = true
func charles(val):
	_charles[val]  = true
func sammy(val):
	_sammy[val] = true
func carol(val):
	_carol[val]  = true
	
func restart():
	Dialogic.VAR.reset()
	_bill = {"mad": false, "happy": false}
	_susan = {"mad": false, "happy": false}
	_charles = {"mad": false, "happy": false};
	_sammy = {"mad": false, "happy": false}
	_carol= {"mad": false, "happy": false};
