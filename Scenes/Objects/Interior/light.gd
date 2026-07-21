extends PointLight2D

@export var view_distance: float = 2300.0
@export var view_angle: float = 45.0
@export var fade_speed: float = 5.0
@export var target_energy: float = 1.0

var current_energy: float = 0.0
var player: Node2D = null
var ray: RayCast2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	energy = 0.0
	
	# Создаём RayCast2D как дочерний узел света
	ray = RayCast2D.new()
	ray.collision_mask = 1  # слой стен (настрой под свой проект)
	add_child(ray)

func _process(delta):
	if player == null:
		return
	
	# Проверяем, смотрит ли игрок на свет И нет ли стены на пути
	var is_looked_at = is_player_looking_at_me() and not is_wall_in_way()
	
	if is_looked_at:
		current_energy = min(current_energy + fade_speed * delta, target_energy)
	else:
		current_energy = max(current_energy - fade_speed * delta, 0.0)
	
	energy = current_energy

func is_player_looking_at_me() -> bool:
	var distance = global_position.distance_to(player.global_position)
	if distance > view_distance:
		return false
	
	var direction_to_light = (global_position - player.global_position).normalized()
	var player_facing = Vector2.RIGHT.rotated(player.rotation)
	var angle_rad = deg_to_rad(view_angle)
	var dot_product = player_facing.dot(direction_to_light)
	
	return dot_product > cos(angle_rad)

func is_wall_in_way() -> bool:
	# Настраиваем луч от ИГРОКА к СВЕТУ
	ray.global_position = player.global_position
	ray.target_position = ray.to_local(global_position)
	ray.force_raycast_update()
	
	return ray.is_colliding()
