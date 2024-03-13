extends Node2D

func _on_play_pressed():
	$Press.play()
	get_tree().change_scene_to_file("res://GameplayScenes/LoadingScreen/loading_screen.tscn")

func _on_quit_pressed():
	$Press.play()
	get_tree().quit()

