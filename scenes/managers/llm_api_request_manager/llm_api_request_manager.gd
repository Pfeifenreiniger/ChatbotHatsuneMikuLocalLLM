extends Node
class_name LlmApiRequestManager

#-----------CUSTOM SIGNALS-----------#

signal got_llm_response(response:String)
signal got_llm_rating(rating:String)


#-----------PROPERTIES-----------#

const URL:String = "http://127.0.0.1:5000/api/get-llm-response"
const HEADERS:Array[String] = ["Content-type: application/json"]

var request:HTTPRequest


#-----------METHODS-----------#

func _ready() -> void:
	request = HTTPRequest.new()
	request.use_threads = true
	add_child(request)
	request.request_completed.connect(_on_request_complete)


func dialogue_request(prompt:String) -> void:
	
	var body:String = JSON.new().stringify(
		{
			'prompt' : prompt
		}
	)
	
	var send_request = request.request(
		URL, HEADERS, HTTPClient.METHOD_POST, body
	)
	
	if send_request != OK:
		printerr("FEHLER FEHLER BEIM POST REQUEST SENDEN FUER DIE BEANTWORTUNG DES PROMPTS")


#-----------METHODS: CONNECTED SIGNALS-----------#

func _on_request_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.new()
	
	json.parse(body.get_string_from_utf8())
	
	var response_dict:Dictionary = json.get_data()
	
	if 'response' in response_dict && 'rating' in response_dict:
		var response_text:String = response_dict['response']
		got_llm_response.emit(response_text)
		
		var rating:String = response_dict['rating']
		got_llm_rating.emit(rating)
	
	else:
		printerr("FEEHLER! Weder Response noch Rating erhalten")
