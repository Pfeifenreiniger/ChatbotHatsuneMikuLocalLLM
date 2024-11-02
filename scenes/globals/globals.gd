extends Node2D

var global_mouse_position:Vector2


#-----------METHODS-----------#

func _ready() -> void:
	global_mouse_position = get_global_mouse_position()


func _process(_delta: float) -> void:
	global_mouse_position = get_global_mouse_position()
