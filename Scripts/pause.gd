extends Control

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	print(">>> МЕНЮ ПАУЗЫ: _ready() вызван")
	print(">>> Visible: ", visible)
	hide()
	set_process_input(true)
	
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Esc") and visible:
		_on_continue_pressed()

func open_pause_menu():
	print("Открытие меню паузы")
	show()
	get_tree().paused = true

func close_pause_menu():
	print("Закрытие меню паузы")
	hide()
	get_tree().paused = false

func _on_continue_pressed():
	print("Нажата кнопка: ПРОДОЛЖИТЬ")
	close_pause_menu()

func _on_restart_pressed():
	print("Нажата кнопка: ПЕРЕЗАПУСТИТЬ")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	print("Нажата кнопка: ГЛАВНОЕ МЕНЮ")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
