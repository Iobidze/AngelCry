extends CharacterBody2D

@onready var flashlight = $PointLight2D
@export var speed = 300
@onready var light = $PointLight2D
@onready var light_area = $PointLight2D2
var battery = 100
var light_area_max : float

# Ссылка на меню паузы (если добавили через редактор)
@onready var pause_menu = $CanvasLayer/Pause # Или как вы назвали узел

func _ready():
	print("TEST: Скрипт работает!")
	$Area2D.body_entered.connect(_on_area_entered)
	print("Скрипт батареи запущен =", battery)
	light.energy = 1
	light_area.energy = 0

func _process(delta):
	# Обработка паузы
	if Input.is_action_just_pressed("Esc"):
		toggle_pause()
	
	# Остальная логика только если игра не на паузе
	if not get_tree().paused:
		if Input.is_action_just_pressed("mouse_button"):
			print("нажатие сработало")
			battery = min(battery + 100 * delta, 100)
			print("зарядка батареи =", battery)
		else: 
			battery = max(battery - 5 * delta, 0)
			print("Разряд батареи = ", battery)
			light.energy = battery / 100 
			light.enabled = battery > 0 
			
			light_area_max = battery / 100 
			light_area_max = min(light_area_max, 0.3)
			light_area.energy = light_area_max
			light_area.enabled = battery > 0

func _physics_process(_delta):
	# Перемещение только если игра не на паузе
	if not get_tree().paused:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
		look_at(get_global_mouse_position())

func toggle_pause():
	if get_tree().paused:
		# Если игра на паузе - закрываем меню
		if pause_menu:
			pause_menu.close_pause_menu()
	else:
		# Если игра не на паузе - открываем меню
		if pause_menu:
			pause_menu.open_pause_menu()

func _on_area_entered(body):
	if body.is_in_group("Angel"):
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
