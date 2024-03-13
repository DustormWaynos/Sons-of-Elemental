extends Node2D

var direction
var speed = 200.0
var lifetime = 1.0
var hit = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func die():
	hit = true
	$AnimationPlayer.play("Hit")

func _physics_process(delta):
	position.x += abs(speed * delta) * direction

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player") && !hit:
		area.get_parent().take_damage(1)
		die()

