extends StaticBody2D

var toxic_ball = load("res://GameplayScenes/Interactable/toxicball.tscn")
var dead = false

@export var shooting : bool
var firerate = 3

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $Firepoint

var max_health = 5
var health

func _ready():
	health = max_health
	shooting = true
	shoot()

func shoot():
	while shooting and !dead:
		$AnimationPlayer.play("Fire")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = toxic_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)

func take_damage(damage_amount):
	
	health -= damage_amount
	
	get_node("MonsterHealthBar").update_healthbar(health, max_health)
	
	$AnimationPlayer.play("Hit")
	$Node2D/Hurt.play()
	
	if health <= 0:
		die()

func die():
	dead = true
	$AnimationPlayer.play("Die")
	self.remove_from_group("Enemies")
	$Node2D/Hurt.play()


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player") && !dead:
		area.get_parent().take_damage(3)
