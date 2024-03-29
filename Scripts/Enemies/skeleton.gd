extends CharacterBody2D


var speed = -60

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var dead = false

var max_health = 3
var health

var should_flip_monster_healthbar: bool = true


func _ready():
	health = max_health
	$AnimationPlayer.play("Walk")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
	
	$Container/SkeletonHealthBar.scale.x = 1.0

func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("Player") && !dead:
		area.get_parent().take_damage(1)
	
func take_damage(damage_amount):
	
	health -= damage_amount
	$Container/SkeletonHealthBar.value = health
	$Container/SkeletonHealthBar.max_value = max_health
	$AnimationPlayer.play("Hit")
	$Hurt.play()
	
	if health <= 0:
		die()

func die():
	dead = true
	speed = 0
	$AnimationPlayer.play("Die")
	$Hurt.play()
	self.remove_from_group("Enemies")
