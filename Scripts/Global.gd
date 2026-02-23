extends Node


# Прогресс
var current_level: int = 0
var game_completed: bool = false 

# История
var read_letters: Array[String] = []
var found_documents: Array[String] = []

# Статистика
var total_deaths: int = 0
var time_played: float = 0.0

# Лор
var lore_facts: Array[String] = [
	"ОНИ ДВИГАЮТСЯ ТОЛЬКО КОГДА ТЫ НЕ СМОТРИШЬ.",
	"СВЕТ — ТВОЙ ЕДИНСТВЕННЫЙ ДРУГ В ЭТОМ МЕСТЕ.",
	"ЦЕРКОВЬ ГОДАМИ ТРАВИЛА ОЗЕРО ОТХОДАМИ.",
	"ОТЕЦ ГЕНРИХ ПРИЗНАЛСЯ В ГРЕХЕ ПЕРЕД СМЕРТЬЮ.",
	"АНГЕЛЫ НЕ УБИВАЮТ — ОНИ ЖДУТ, ПОКА ТЫ УСТАНЕШЬ.",
	"ПЛАЧУЩИЕ АНГЕЛЫ — ЭТО НЕ ДЕМОНЫ. ЭТО ЧИСТИЛИЩЕ.",
	"ОЗЕРО ГЛУБОКОЕ БЫЛО КОГДА-ТО ЧИСТЫМ.",
	"ТЫ НЕ ПЕРВЫЙ. ТЫ НЕ ПОСЛЕДНИЙ.",
	"ДВЕРИ ДЕРЖАТ ИХ 12 СЕКУНД.",
	"ФОНАРИК САДИТСЯ БЫСТРЕЕ ВО ВЛАЖНОСТИ.",
	"ИХ СЛЁЗЫ — ЭТО ПЛАЧ ПО ЧУЖИМ ГРЕХАМ.",
	"ЗЕРКАЛА ИХ ПУГАЮТ. ИЛИ ЗАСТАВЛЯЮТ ВСПОМИНАТЬ.",
	"КОЛОКОЛЬНЫЙ ЗВОН МОЖЕТ ИХ РАЗБУДИТЬ... ИЛИ УСПОКОИТЬ.",
	"В КАТАКОМБАХ ЕСТЬ ТЕ, КТО ЖДАЛ СТОЛЕТИЯМИ.",
	"ТЫ СЛЫШИШЬ ПЛАЧ? ЭТО НЕ ОНИ. ЭТО ТЫ.",
]

func get_random_fact() -> String:
	return lore_facts.pick_random()

func add_read_letter(letter_id: String):
	if not letter_id in read_letters:
		read_letters.append(letter_id)
		print("📖 Письмо прочитано: ", letter_id)

func _process(delta):
	if not get_tree().paused:
		time_played += delta
