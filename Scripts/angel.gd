extends CharacterBody2D

@export var speed = 500.0
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var nav_agent = $NavigationAgent2D
@onready var ray = $RayCast2D # Наш новый луч
# @onready var sfx_player = $AudioStreamPlayer2D 
@onready var animation_player = $AnimatedSprite2D


func _physics_process(_delta):
	if not player: return

	# 1. ПРОВЕРКА: ВИДЯТ ЛИ АНГЕЛА
	if is_watched():
		velocity = Vector2.ZERO
		#if sfx_player.playing:
			# sfx_player.stop() # Тишина, когда он замер
		return 
	
	# 2. ЗВУК: ЕСЛИ НЕ ВИДЯТ И ОН МОЛЧИТ — ВКЛЮЧАЕМ
	# if not sfx_player.playing:
		# sfx_player.play()
	
	# 3. ДВИЖЕНИЕ: К ИГРОКУ В ОБХОД СТЕН
	nav_agent.target_position = player.global_position
	if not nav_agent.is_navigation_finished():
		var next_path_pos = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next_path_pos) * speed
		move_and_slide()
		
func _process(_delta):
	if player == null:
		return
	# Проверяем, смотрит ли игрок на ангела
	if not is_watched():
		# Игрок НЕ смотрит - вращаемся к нему6
		look_at(player.global_position)
		rotation += deg_to_rad(90)
		animation_player.play() # корректировка
	else:
		animation_player.pause()
		# Игрок смотрит - НЕ вращаемся, стоим на месте61
		pass  

func is_watched() -> bool:
	# 1. Если игрок моргает — ангел невидим и может идти
	if player.has_method("is_blinking") and player.is_blinking():
		return false
		
	# 2. Если фонарик выключен — ангел может идти
	if not player.flashlight.enabled:
		return false

	# 3. Проверка: светит ли фонарик В СТОРОНУ ангела?
	var dir_to_angel = player.global_position.direction_to(global_position)
	var forward_vector = Vector2.RIGHT.rotated(player.rotation)
	var dot_product = forward_vector.dot(dir_to_angel)
	
	# dot_product > 0.7 означает примерно 45 градусов обзора
	if dot_product > 0.7:
		# 4. Фонарик направлен на ангела, НО не мешает ли стена?
		ray.target_position = ray.to_local(player.global_position)
		ray.force_raycast_update()
		
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Player"):
				# Стены нет, фонарик светит прямо на ангела — СТОИМ
				return true
				
	# Во всех остальных случаях (фонарик в сторону, за стеной и т.д.) — ИДЕМ
	return false
