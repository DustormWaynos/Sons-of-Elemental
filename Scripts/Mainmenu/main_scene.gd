extends Node2D




func _on_thoát_trò_chơi_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_trò_chơi_mới_pressed():
	get_tree().change_scene_to_file("res://WorldScenes/WorldScenes/first.tscn")
	pass # Replace with function body.
