extends Control

@onready var start_button = $BoxContainer/VBoxContainer/StartButton
@onready var options_button = $BoxContainer/VBoxContainer/OptionsButton
@onready var quit_button = $BoxContainer/VBoxContainer/QuitButton

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	hide()
	
func open_dead_menu():
	print("Открытие меню паузы")
	show()
	get_tree().paused = true

func close_dead_menu():
	print("Закрытие меню паузы")
	hide()
	get_tree().paused = false


#func _on_options_pressed():
	# Открываем настройки
   # var options_scene = load("res://OptionsMenu.tscn").instantiate()
   # add_child(options_scene)

func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
