extends Node2D

@export_group("Door Settings")
@export var door_sprite: Sprite2D
@export var door_body: StaticBody2D
@export var door_collision: CollisionShape2D
@export var interaction_area: Area2D
@export var light_occluder: LightOccluder2D
@export var open_rotation: float = -90.0
@export var closed_rotation: float = 0.0
@export var animation_speed: float = 3.0

@export_group("Hold Settings")
@export var hold_time: float = 1.0

@export_group("UI Elements")
@export var progress_bar: TextureProgressBar
@export var interaction_label: Label

# Состояния
var player_in_range: bool = false
var is_open: bool = false
var is_animating: bool = false
var hold_progress: float = 0.0
var current_rotation: float = 0.0
var target_rotation: float = 0.0
var holding: bool = false  # Флаг процесса удержания

func _ready():
	# Подключаем сигналы
	# if interaction_area:
		# interaction_area.body_entered.connect(_on_body_entered_door)
		# interaction_area.body_exited.connect(_on_body_exited_door)
	
	# Скрываем UI изначально
	if progress_bar:
		progress_bar.hide()
		progress_bar.value = 0
	if interaction_label:
		interaction_label.hide()
	
	# Устанавливаем начальное вращение
	if door_sprite:
		current_rotation = closed_rotation
		door_sprite.rotation_degrees = closed_rotation
		if door_body:
			door_body.rotation_degrees = closed_rotation

func _process(delta):
	if is_animating:
		animate_door(delta)

func _input(event):
	# Показываем подсказку ТОЛЬКО когда игрок рядом и дверь не анимируется
	if player_in_range and not is_animating and not holding:
		if event.is_action_pressed("action"):
			start_holding()
	elif event.is_action_released("action"):
		stop_holding()

func _physics_process(delta):
	if player_in_range and Input.is_action_pressed("action") and not is_animating:
		holding = true
		hold_progress += delta / hold_time
		hold_progress = min(hold_progress, 1.0)
		
		# Показываем прогресс бар
		if progress_bar:
			progress_bar.visible = true
			progress_bar.value = hold_progress * 100
		
		# Скрываем текстовую подсказку во время удержания
		if interaction_label:
			interaction_label.hide()
		
		# Визуальный фидбек
		if door_sprite and hold_progress > 0 and hold_progress < 1:
			var shake = sin(Time.get_ticks_msec() * 0.02) * 1
			door_sprite.rotation_degrees = current_rotation + shake
			if door_body:
				door_body.rotation_degrees = current_rotation + shake
		
		# Открываем при достижении 100%
		if hold_progress >= 1.0:
			toggle_door()
	else:
		# Сбрасываем прогресс если не удерживаем
		if holding:
			holding = false
			hold_progress = 0.0
			if progress_bar:
				progress_bar.hide()
			
			# Возвращаем дверь в нормальное положение
			if door_sprite:
				door_sprite.rotation_degrees = current_rotation
				if door_body:
					door_body.rotation_degrees = current_rotation
			
			# Показываем подсказку снова если игрок рядом
			if player_in_range and not is_animating:
				show_interaction_prompt()

func _on_body_entered_door (body):
	print("1. Вошел объект: ", body.name)
	print("2. Группы объекта: ", body.get_groups()) 
	if body.is_in_group("Player"):
		print("3. Это игрок! 👍")
		player_in_range = true
		# Показываем подсказку только если дверь не анимируется
		if not is_animating and not holding:
			show_interaction_prompt()
		else:
			print("3. Это НЕ игрок, группа не 'Player'")


func _on_body_exited_door (body):
	if body.is_in_group("Player"):
		player_in_range = false
		# Скрываем ВСЕ элементы UI
		hide_all_ui()
		holding = false
		hold_progress = 0.0

func show_interaction_prompt():
	if interaction_label and not is_animating and not holding and player_in_range:
		var action = "Открыть" if not is_open else "Закрыть"
		interaction_label.text = action + " (E)"
		interaction_label.show()
	

func hide_interaction_prompt():
	if interaction_label:
		interaction_label.hide()

func hide_all_ui():
	if interaction_label:
		interaction_label.hide()
	if progress_bar:
		progress_bar.hide()

func start_holding():
	if is_animating or not player_in_range:
		return
	
	holding = true
	hold_progress = 0.0
	
	# Показываем прогресс бар, скрываем текст
	if progress_bar:
		progress_bar.show()
		progress_bar.value = 0
	if interaction_label:
		interaction_label.hide()

func stop_holding():
	if holding:
		holding = false
		
		if hold_progress < 1.0:
			# Не до конца удержали
			hold_progress = 0.0
			if progress_bar:
				progress_bar.hide()
			
			# Возвращаем дверь в норму
			if door_sprite:
				door_sprite.rotation_degrees = current_rotation
				if door_body:
					door_body.rotation_degrees = current_rotation
			
			# Показываем подсказку снова
			if player_in_range and not is_animating:
				show_interaction_prompt()

func toggle_door():
	if is_animating:
		return
	
	is_open = not is_open
	target_rotation = open_rotation if is_open else closed_rotation
	is_animating = true
	holding = false
	
	# Отключаем/включаем коллизию
	if door_collision:
		door_collision.set_deferred("disabled", is_open)
		
	if light_occluder:
		light_occluder.visible = not is_open
	
	# Скрываем весь UI
	hide_all_ui()
	hold_progress = 0.0

func animate_door(delta):
	if not door_sprite:
		is_animating = false
		return
	
	var step = animation_speed * delta * 60
	current_rotation = move_toward(current_rotation, target_rotation, step)
	
	door_sprite.rotation_degrees = current_rotation
	if door_body:
		door_body.rotation_degrees = current_rotation
	
	if abs(current_rotation - target_rotation) < 0.5:
		door_sprite.rotation_degrees = target_rotation
		if door_body:
			door_body.rotation_degrees = target_rotation
		is_animating = false
		current_rotation = target_rotation
		
		# Показываем подсказку снова если игрок рядом
		if player_in_range and not holding:
			show_interaction_prompt()
