extends Node2D
@export var activation_delay: float = 5.0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(activation_delay).timeout
		# Активируем всех детей (ангелов)
		for child in get_children():
			# Пропускаем саму триггер-зону
			if child is CharacterBody2D:
				child.speed = 500
		# Отключаем триггер, чтобы не срабатывал повторно
		var trigger = $Area2D
		if trigger:
			trigger.queue_free()
