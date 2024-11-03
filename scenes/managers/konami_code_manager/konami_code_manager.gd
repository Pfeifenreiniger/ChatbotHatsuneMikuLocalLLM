extends Node
class_name KonamiCodeManager


#-----------CUSTOM SIGNALS-----------#

signal konami_code_activated


#-----------PROPERTIES-----------#

const KONAMI_CODE:Array[int] = [
	KEY_UP, KEY_UP,
	KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT,
	KEY_LEFT, KEY_RIGHT,
	KEY_B, KEY_A
]

var current_index:int = 0

#-----------METHODS-----------#

func _input(event: InputEvent) -> void:
	# Ueberprüfe, ob das Event eine Tastenfreigabe ist
	if event is InputEventKey and event.pressed:
		# Ueberprüfe, ob die gedrueckte Taste mit der aktuellen Position im Konami-Code uebereinstimmt
		if event.keycode == KONAMI_CODE[current_index]:
			# Wenn die Taste korrekt ist, gehe zur nächsten Position
			current_index += 1

			# Pruefe, ob die Sequenz abgeschlossen ist
			if current_index == KONAMI_CODE.size():
				konami_code_activated.emit() # feuer custom signal ab, um andere Scenes zu informieren
				current_index = 0  # Setze die Position zurück für die nächste Eingabe
		else:
			# Falls eine falsche Taste gedrueckt wurde, beginne von vorne
			current_index = 0

