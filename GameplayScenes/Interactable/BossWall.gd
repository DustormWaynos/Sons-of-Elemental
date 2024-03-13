extends StaticBody2D
class_name BossWall


@onready var wall = $CollisionShape2D

func _ready():
	hide_wall()

func show_wall():
	wall.set_deferred("disabled", false)
	$AnimationPlayer.play("Idle")
	$Sprite2D.show()

func hide_wall():
	wall.set_deferred("disabled", true)
	$Sprite2D.hide()
