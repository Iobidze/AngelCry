extends Node2D

@export var angels: Array[Node2D]

func _ready():
	print("Найдено ангелов в массиве: ", angels.size())  # Проверяем массив
	
	for angel in angels:
		if angel:
			print("Ангел найден: ", angel.name)
			angel.visible = false
			angel.set_process(false)
			angel.set_physics_process(false)
			angel.collision.set_deferred("disabled", true)
			angel.angel_sound.stop()


func _on_body_entered_group2(body):
	if body.is_in_group("Player"):
		for angel in angels:
			if angel:
				angel.visible = true
				angel.show()  # Принудительно показываем
				angel.set_process(true)
				angel.set_physics_process(true)
				angel.collision.set_deferred("disabled", false)

				angel.move_and_slide()
				angel.process_mode = Node.PROCESS_MODE_INHERIT  # Включаем обработку
				
				if angel.has_node("angel_sound"):
					angel.angel_sound.play()
		
		await get_tree().process_frame  # Ждём один кадр
	
