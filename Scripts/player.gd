extends CharacterBody2D
@export var speed = 300

func _ready():
	$Area2D.body_entered.connect(_on_area_entered)
	
func _on_area_entered(body):
	if body.is_in_group("Angel"):
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _physics_process(_delta):
	# Движение (WASD)
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

	# Поворот за мышкой (фонарик будет светить куда смотришь)
	look_at(get_global_mouse_position())


func _on_touch_screen_button_pressed():
	
	pass # Replace with function body.
