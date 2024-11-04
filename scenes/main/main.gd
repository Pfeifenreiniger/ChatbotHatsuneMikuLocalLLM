extends Control


#-----------SCENE REFERENCES-----------#

@onready var chatbot: Chatbot = $Chatbot as Chatbot
@onready var konami_code_manager: KonamiCodeManager = $KonamiCodeManager as KonamiCodeManager


#-----------NODE REFERENCES-----------#

@onready var quit_button: Button = $QuitButton as Button
@onready var quit_button_sound: AudioStreamPlayer = $QuitButtonSound as AudioStreamPlayer
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
	konami_code_manager.konami_code_activated.connect(_on_konami_code_manager_konami_code_activated)


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
	quit_button_sound.play()
	var quit_tween:Tween = create_tween()
	quit_tween.tween_property($".", "scale", Vector2(.01, .01), 1.6)
	await quit_button_sound.finished
	get_tree().quit()


func _on_texture_rect_mouse_entered() -> void:
	hover_over_window = true


func _on_texture_rect_mouse_exited() -> void:
	hover_over_window = false


func _on_konami_code_manager_konami_code_activated() -> void:
	var easter_egg_sound:AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(easter_egg_sound)
	easter_egg_sound.stream = load("res://assets/sounds/miku/my-name-is-hatsune-miku!-made-with-Voicemod.mp3")
	easter_egg_sound.play()
	scale = Vector2(.6, .6)
	
	var rotation_tween:Tween = create_tween()
	rotation_tween.set_loops(0)
	rotation_tween.tween_property($".", "rotation_degrees", 360, .5).from(0)
	
	await easter_egg_sound.finished
	
	rotation_tween.kill()
	scale = Vector2(1, 1)
	rotation_degrees = 0
	easter_egg_sound.queue_free()
