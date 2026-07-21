extends Control
signal options_closed
@onready var back_button = $BoxContainer/VBoxContainer/Back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Делаем опции поверх всего
	process_mode = PROCESS_MODE_ALWAYS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed():
	# Отправляем сигнал, что опции закрыты
	options_closed.emit()
	
	# Удаляем сцену опций
	queue_free()
	pass # Replace with function body.
