extends Node2D

var direction
var speed = 100.0
var lifetime = 3.0
var hit = false
var dead = false
var max_health = 1
var health

func _ready():
	health = max_health
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(lifetime).timeout
	hitt()

func hitt():
	hit = true
	$AnimationPlayer.play("Hit")

func _physics_process(delta):
	position.x += abs(speed * delta) * direction

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player") && !hit:
		area.get_parent().take_damage(1)
		hitt()

func take_damage(damage_amount):
	health -= damage_amount
	
	if health <= 0:
		hit = false
		die()

func die(): 
	dead = true
	speed = 0
	$AnimationPlayer.play("Die")
	$"Hurt&Dead".play()
	self.remove_from_group("Enemies")
