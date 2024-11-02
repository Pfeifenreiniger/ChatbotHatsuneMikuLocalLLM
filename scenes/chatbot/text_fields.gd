extends TextEdit
class_name TextField

#-----------CUSTOM SIGNALS-----------#

signal text_submitted(text)


#-----------METHODS-----------#

func _process(_delta: float) -> void:
	
	if !has_focus():
		return
	
	if Input.is_action_just_pressed("send-message") && !Input.is_action_pressed("shift"):
		text_submitted.emit(text)
		clear()  # TextEdit leeren
