extends Node

signal gained_coins()

var coins : int

var current_checkpoint : Checkpoint

var player : Player

func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	player.respawn.get_child(0).hide()
	player.is_dead = false
	player.get_node("../UIManager/TextureProgressBar")._ready()
	player.add_to_group("Player")
	player.animation.play()

func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins")
	print(coins)
