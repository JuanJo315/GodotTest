extends Control

signal dialogue_finished

@export_file("*.json") var dialogue_file

var dialogues = []  # Lista de diálogos del NPC actual
var current_dialogue_id = 0

var dialogue_active = false

func _ready():
	$NinePatchRect.visible = false

func start(): 
	print("chatting")
	if dialogue_active: 
		return 
	dialogue_active = true
	$NinePatchRect.visible = true
	dialogues = load_dialogues() 
	current_dialogue_id = -1 
	show_next_dialogue()

func load_dialogues():
	var file = FileAccess.open("res://Dialogo_npc_talk.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func show_next_dialogue():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogues):
		dialogue_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		return

	$NinePatchRect/Name.text = dialogues[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogues[current_dialogue_id]['text']

func end_dialogue():
	dialogue_active = false
	$NinePatchRect.visible = false
	emit_signal("dialogue_finished")  # Emitir la señal al finalizar el diálogo

func _input(event):
	if !dialogue_active:
		return
		
	if event.is_action_pressed("ui_accept"):
		show_next_dialogue()
