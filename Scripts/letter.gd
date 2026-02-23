extends Node2D
@export var textLetter = ""

@onready var area = $Area2D
@onready var hint = $CanvasLayer2/Control/HintLabel
@onready var panel = $CanvasLayer/LetterPanel

var player_in_zone = false

func _ready():
	# Все скрыто в начале
	hint.visible = false
	panel.visible = false
	$CanvasLayer/LetterPanel/LetterText.text = textLetter

func _on_area_2d_body_entered(body):
	# Когда игрок входит в зону
	if body.name == "Player":  # или body.is_in_group("player")
		player_in_zone = true
		hint.visible = true

func _on_area_2d_body_exited(body):
	# Когда игрок выходит из зоны
	if body.name == "Player":
		player_in_zone = false
		hint.visible = false
		panel.visible = false

func _input(event):
	# При нажатии E
	if player_in_zone and event.is_action_pressed("action"):
		panel.visible = !panel.visible
