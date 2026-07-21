# MainMenu.gd
extends Control

@onready var start_button = $BoxContainer/VBoxContainer/StartButton
@onready var options_button = $BoxContainer/VBoxContainer/OptionsButton
@onready var quit_button = $BoxContainer/VBoxContainer/QuitButton

func _ready():
	pass


func _on_options_pressed():
	# Открываем настройки
	get_tree().change_scene_to_file("res://Scenes/Levels/testlevel.tscn")
   

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level0/level_0.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
