extends Node2D


#-----------SCENE REFERENCES-----------#

@onready var chatbot: Chatbot = $Chatbot as Chatbot


#-----------NODE REFERENCES-----------#

@onready var quit_button: Button = $QuitButton as Button
@onready var texture_rect: TextureRect = $TextureRect as TextureRect


#-----------PROPERTIES-----------#

var hover_over_window:bool

var WINDOW_SIZE = DisplayServer.window_get_size()
var MONITOR_SIZE = DisplayServer.screen_get_size()


#-----------METHODS-----------#

func _ready() -> void:
	_init_window_position()
	quit_button.pressed.connect(_on_quit_button_pressed)
	texture_rect.mouse_entered.connect(_on_texture_rect_mouse_entered)
	texture_rect.mouse_exited.connect(_on_texture_rect_mouse_exited)


func _process(_delta: float) -> void:
	_move_window()


func _init_window_position() -> void:
	DisplayServer.window_set_position(
		MONITOR_SIZE / 2
	)


func _move_window() -> void:
	
	if !(hover_over_window && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	
	var mouse_position:Vector2i = Vector2i(Globals.global_mouse_position.x, Globals.global_mouse_position.y) + DisplayServer.window_get_position()
	
	var mouse_position_offset:Vector2i = Vector2i(WINDOW_SIZE.x / 2, WINDOW_SIZE.y / 2)
	
	DisplayServer.window_set_position(
		mouse_position - mouse_position_offset
	)



#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_texture_rect_mouse_entered() -> void:
	hover_over_window = true


func _on_texture_rect_mouse_exited() -> void:
	hover_over_window = false
