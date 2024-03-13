extends Control

var progress_bar : TextureProgressBar

func _ready():
	progress_bar = $TextureProgressBar
	start_loading()

func start_loading():
	load_game()

func update_progress(value):
	progress_bar.value = value

func load_game():
	load_game_content()

func load_game_content():
	for i in range(100):
		update_progress(i)
		await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://WorldScenes/WorldScenes/first.tscn")
