extends PointLight2D

# === НАСТРОЙКИ МЕРЦАНИЯ ===
@export var flicker_speed: float = 1.0
@export var min_energy: float = 0.3
@export var max_energy: float = 1.0
@export var flicker_interval: float = 1.0

# === НАСТРОЙКИ ЗАВИСИМОСТИ ОТ ВЗГЛЯДА ===
@export var view_distance: float = 1000.0
@export var view_angle: float = 45.0
@export var fade_speed: float = 5.0

# === ПЕРЕМЕННЫЕ ===
var player: Node2D = null
var is_visible_by_player: bool = false      # видит ли игрок этот свет
var current_visibility: float = 0.0         # плавный переход видимости (0-1)

# Переменные для мерцания
var flicker_timer: float = 0.0
var flicker_target: float = 1.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	# Настройки света
	energy = 0.0
	flicker_timer = randf_range(0.5, flicker_interval)
	flicker_target = randf_range(min_energy, max_energy)

func _process(delta):
	if player == null:
		return
	
	# 1. Проверяем, видит ли игрок этот свет (взгляд + нет стены)
	is_visible_by_player = is_player_looking_at_me() and not is_wall_in_way()
	
	# 2. Плавно меняем current_visibility (0-1)
	if is_visible_by_player:
		current_visibility = min(current_visibility + fade_speed * delta, 1.0)
	else:
		current_visibility = max(current_visibility - fade_speed * delta, 0.0)
	
	# 3. Если свет не виден — просто выключаем и не мерцаем
	if current_visibility <= 0.0:
		energy = 0.0
		return
	
	# 4. Если свет виден — обновляем мерцание
	flicker_timer -= delta
	if flicker_timer <= 0:
		flicker_target = randf_range(min_energy, max_energy)
		flicker_timer = randf_range(0.5, flicker_interval)
	
	# 5. Плавно меняем яркость к целевой
	var flicker_energy = lerp(energy, flicker_target, delta * 5.0)
	
	# 6. Итоговая яркость = мерцание × видимость
	energy = flicker_energy * current_visibility

# === ПРОВЕРКА, СМОТРИТ ЛИ ИГРОК ===
func is_player_looking_at_me() -> bool:
	# Расстояние
	var distance = global_position.distance_to(player.global_position)
	if distance > view_distance:
		return false
	
	# Направление от игрока к свету
	var direction_to_light = (global_position - player.global_position).normalized()
	
	# Направление взгляда игрока
	var player_facing = Vector2.RIGHT.rotated(player.rotation)
	
	# Угол между взглядом и направлением к свету
	var angle_rad = deg_to_rad(view_angle)
	var dot_product = player_facing.dot(direction_to_light)
	
	return dot_product > cos(angle_rad)

# === ПРОВЕРКА, ЕСТЬ ЛИ СТЕНА МЕЖДУ ИГРОКОМ И СВЕТОМ ===
var ray: RayCast2D = null

func is_wall_in_way() -> bool:
	# Создаём луч, если его ещё нет
	if ray == null:
		ray = RayCast2D.new()
		ray.collision_mask = 1  # слой стен (настрой под свой проект)
		add_child(ray)
	
	# Настраиваем луч от игрока к свету
	ray.global_position = player.global_position
	ray.target_position = ray.to_local(global_position)
	ray.force_raycast_update()
	
	return ray.is_colliding()
