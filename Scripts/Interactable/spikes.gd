extends Node2D


#spikes

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().take_damage(10)
