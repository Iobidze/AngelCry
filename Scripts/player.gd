extends CharacterBody2D
@export var speed = 300


func _physics_process(_delta):
	# Движение (WASD)
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

	# Поворот за мышкой (фонарик будет светить куда смотришь)
	look_at(get_global_mouse_position())
