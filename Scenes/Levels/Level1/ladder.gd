extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("Загрузка уровня...")
		# Небольшая задержка для плавности
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file.call_deferred("res://Scenes/Levels/Level2/level_2.tscn")
