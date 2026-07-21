extends CharacterBody2D

@onready var flashlight = $PointLight2D
@export var speed = 300
@onready var light = $PointLight2D
@onready var light_area = $PointLight2D2
@onready var battery_bar = $BatteryBar
var battery = 100
var light_area_max : float

# Таймер для разрядки
var discharge_timer: float = 0.0
var discharge_interval: float = 0.5  # Разряжать каждые 0.5 секунды
var discharge_amount: float = 2.5    # На сколько разряжать за интервал (5% в секунду)

@onready var pause_menu = $CanvasLayer/Pause
@onready var dead = $CanvasLayer2/Dead

func _ready():
	#print("TEST: Скрипт работает!")
	$Area2D.body_entered.connect(_on_area_entered)
	#print("Скрипт батареи запущен =", battery)
	light.energy = 1
	light_area.energy = 0
	
	# Настройка статус-бара
	if battery_bar:
		battery_bar.min_value = 0
		battery_bar.max_value = 100
		battery_bar.value = battery

func _process(delta):
	# Обработка паузы
	if Input.is_action_just_pressed("Esc"):
		toggle_pause()
	
	# Остальная логика только если игра не на паузе
	if not get_tree().paused:
		# Обработка клика мыши для зарядки
		if Input.is_action_just_pressed("mouse_button"):
			#print("Клик мыши - зарядка!")
			battery = min(battery + 5, 100)  # Заряжаем на 10% за клик
			#print("Батарея после зарядки =", battery)
			update_battery_visuals()
			update_battery_bar()
		
		# Разрядка по таймеру (не зависит от delta)
		discharge_timer += delta
		if discharge_timer >= discharge_interval:
			discharge_timer = 0.0
			# Разряжаем только если не нажата кнопка мыши в этот момент
			if not Input.is_action_just_pressed("mouse_button"):
				battery = max(battery - discharge_amount, 0)
				#print("Разряд батареи (таймер) = ", battery)
				update_battery_visuals()
				update_battery_bar()

func update_battery_visuals():
	# Обновляем визуал фонарика на основе текущей батареи
	light.energy = battery / 100 
	light.enabled = battery > 0 
	
	light_area_max = battery / 100 
	light_area_max = min(light_area_max, 0.3)
	light_area.energy = light_area_max
	light_area.enabled = battery > 0

func update_battery_bar():
	if battery_bar:
		battery_bar.value = battery
		
		# Меняем цвет в зависимости от уровня батареи
		if battery > 70:
			battery_bar.modulate = Color.GREEN
		elif battery > 40:
			battery_bar.modulate = Color.YELLOW
		else:
			battery_bar.modulate = Color.RED

func _physics_process(_delta):
	# Перемещение только если игра не на паузе
	if not get_tree().paused:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
		look_at(get_global_mouse_position())

func toggle_pause():
	if get_tree().paused:
		if pause_menu:
			pause_menu.close_pause_menu()
	else:
		if pause_menu:
			pause_menu.open_pause_menu()

func _on_area_entered(body):
	if body.is_in_group("Angel"):
		await get_tree().process_frame
		dead.open_dead_menu()
		
func dead_screen ():
	
	get_tree()
	pass 
