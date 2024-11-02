@tool
extends Node2D
class_name Chatbot

#-----------NODE REFERENCES-----------#

@onready var miku_face: Sprite2D = %MikuFace as Sprite2D
@onready var miku_face_animations: AnimationPlayer = $MikuFaceAnimations as AnimationPlayer
@onready var user_prompt_field: TextField = $UserPromptField as TextField
@onready var chatbot_response_field: TextEdit = $ChatbotResponseField as TextEdit
@onready var text_fields_animations: AnimationPlayer = $TextFieldsAnimations as AnimationPlayer


#-----------SCENE REFERENCES-----------#

var llm_api_request_manager_scene:PackedScene = preload("res://scenes/managers/llm_api_request_manager/llm_api_request_manager.tscn")
var llm_api_request_manager:LlmApiRequestManager = null


#-----------PROPERTIES-----------#

var MIKU_FACE_IMAGES:Dictionary = {
	'happy' : load("res://assets/chatbot/miku_faces/happy_face.svg"),
	'normal' : load("res://assets/chatbot/miku_faces/normal_face.svg"),
	'sad' : load("res://assets/chatbot/miku_faces/sad_face.svg"),
	'shocked' : load("res://assets/chatbot/miku_faces/shocked_face.svg"),
	'thinking' : load("res://assets/chatbot/miku_faces/thinking_face.svg")
}

@export_enum('normal', 'happy', 'sad', 'shocked', 'thinking') var miku_face_type:String = 'normal':
	get:
		return miku_face_type
	set(value):
		if !(value in ['normal', 'happy', 'sad', 'shocked', 'thinking']):
			return
		miku_face_type = value
		if miku_face != null:
			miku_face.texture = MIKU_FACE_IMAGES.get(value)
		if miku_face_animations != null:
			miku_face_animations.stop()
			miku_face_animations.play(value)

var chatbot_response_display_animation_tween:Tween


#-----------METHODS-----------#

func _ready() -> void:
	llm_api_request_manager = llm_api_request_manager_scene.instantiate()
	add_child(llm_api_request_manager)
	llm_api_request_manager.got_llm_response.connect(_on_llm_api_request_manager_got_llm_response)
	llm_api_request_manager.got_llm_rating.connect(_on_llm_api_request_manager_got_llm_rating)
	user_prompt_field.text_submitted.connect(_on_user_prompt_field_text_submitted)
	user_prompt_field.clear()
	chatbot_response_field.clear()
	miku_face_type = 'normal'
	chatbot_response_display_animation_tween = create_tween()


func display_response_in_parts_animation(response_part_index:float, response:String) -> void:
	
	chatbot_response_field.text = response.substr(0, round(response_part_index))
	
	var scrollbar:VScrollBar = chatbot_response_field.get_v_scroll_bar()
	if scrollbar != null:
		chatbot_response_field.scroll_vertical = scrollbar.max_value


#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_user_prompt_field_text_submitted(text:String) -> void:
	if text.length() < 1:
		return
	
	if chatbot_response_display_animation_tween != null && chatbot_response_display_animation_tween.is_running():
		chatbot_response_display_animation_tween.kill()
	
	llm_api_request_manager.dialogue_request(text)
	miku_face_type = 'thinking'
	
	chatbot_response_field.clear()
	text_fields_animations.play('chatbot_response_field_loading')


func _on_llm_api_request_manager_got_llm_response(response:String) -> void:
	text_fields_animations.stop()
	chatbot_response_field.clear()
	
	chatbot_response_display_animation_tween = create_tween()
	
	var scrollbar:VScrollBar = chatbot_response_field.get_v_scroll_bar()
	
	chatbot_response_display_animation_tween.tween_method(
		display_response_in_parts_animation.bind(response), 0.0, float(response.length()) - 1, response.length() / 20
	)
	
	await chatbot_response_display_animation_tween.finished
	
	miku_face_type = 'normal'


func _on_llm_api_request_manager_got_llm_rating(rating:String) -> void:
	miku_face_type = rating
