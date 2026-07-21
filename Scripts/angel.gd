extends CharacterBody2D

@export var speed = 500.0
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var nav_agent = $NavigationAgent2D
@onready var ray = $RayCast2D
@onready var animation_player = $AnimatedSprite2D
@onready var angel_sound = $AngelSound
@onready var hearth_sound = $Hearth
@onready var collision = $CollisionShape2D
@onready var step_lighthose = $Step_light

# ПЛАВНОЕ МИГАНИЕ
var blink_timer = 0.0
var is_light_on = false
var target_scale = 0.5

func _physics_process(_delta):
	if not player:
		return

	if is_watched():
		velocity = Vector2.ZERO
		return

	nav_agent.target_position = player.global_position
	if not nav_agent.is_navigation_finished():
		var next_path_pos = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next_path_pos) * speed
		move_and_slide()

func _process(delta):
	if player == null:
		return

	if speed == 0:
		animation_player.play("Idle")
		if angel_sound and angel_sound.playing:
			angel_sound.stop()
			hearth_sound.stop()
		step_lighthose.energy = 0.0
		step_lighthose.texture_scale = 0.5
		return

	if not is_watched():
		# Поворот и анимация
		look_at(player.global_position)
		rotation += deg_to_rad(90)
		animation_player.play("Walk")

		# ЗВУКИ
		if angel_sound and not angel_sound.playing:
			angel_sound.play()
			hearth_sound.play()

		# === ПЛАВНОЕ МИГАНИЕ СВЕТА ===
		blink_timer += delta

		# Плавно меняем размер света к целевым значениям
		step_lighthose.texture_scale = lerp(step_lighthose.texture_scale, target_scale, delta * 5.0)

		if blink_timer >= 1.0:
			blink_timer = 0.0
			step_lighthose.energy = 1.0
			target_scale = 1.0
			is_light_on = true

		elif is_light_on and blink_timer >= 0.4:
			target_scale = 3.0

		elif is_light_on and blink_timer >= 0.8:
			target_scale = 0.5
			step_lighthose.energy = lerp(step_lighthose.energy, 0.0, delta * 10.0)

			if step_lighthose.energy < 0.05:
				step_lighthose.energy = 0.0
				is_light_on = false
				target_scale = 0.5

	else:
		# Игрок смотрит — замираем
		animation_player.stop()
		if angel_sound and angel_sound.playing:
			angel_sound.stop()
			hearth_sound.stop()

		# Сбрасываем свет
		step_lighthose.energy = 0.0
		step_lighthose.texture_scale = 0.5
		is_light_on = false
		target_scale = 0.5
		blink_timer = 0.0

func is_watched() -> bool:
	if player.has_method("is_blinking") and player.is_blinking():
		return false

	if not player.flashlight.enabled:
		return false

	var dir_to_angel = player.global_position.direction_to(global_position)
	var forward_vector = Vector2.RIGHT.rotated(player.rotation)
	var dot_product = forward_vector.dot(dir_to_angel)

	if dot_product > 0.7:
		ray.target_position = ray.to_local(player.global_position)
		ray.force_raycast_update()

		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Player"):
				return true

	return false
