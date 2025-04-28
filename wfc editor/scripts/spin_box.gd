extends SpinBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	var line_edit = get_line_edit()

	if not (has_focus() or (line_edit and line_edit.has_focus())):
		return
	
	if event.is_action_pressed("ui_up"):
		value += step
	elif event.is_action_pressed("ui_down"):
		value -= step
