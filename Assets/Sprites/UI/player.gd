extends CharacterBody2D
@onready var flashlight = $PointLight2D # Убедись, что имя совпадает с твоим узлом
@export var speed = 400.0
var flicker_timer = 0.0
var is_flickering = false
@onready var light = $PointLight2D
var battery = 100
@onready var light2 = $PointLight2D2
@onready var sfx_player = $AudioStreamPlayer2D


func _ready():
	light.energy = 2.5
	light2.energy = 2.5
	add_to_group("player")
	

func  _process(delta):
	if not sfx_player.playing:
		sfx_player.play()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		battery = min(battery + 20 * delta, 100)
	else: battery = max(battery- 5 * delta, 0)
	light.energy = battery / 100.0
	light.enabled = battery > 0
	light2.energy = battery / 100.0
	light2.enabled = battery > 0
	
	

func _physics_process(_delta):
	# Движение (WASD)
	var direction = Input.get_vector("left", "right", "up ", "down")
	velocity = direction * speed
	move_and_slide()

	# Поворот за мышкой (фонарик будет светить куда смотришь)
	look_at(get_global_mouse_position())
