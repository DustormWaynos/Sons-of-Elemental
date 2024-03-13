extends CharacterBody2D

var arrow = preload("res://Scripts/Player/Player.gd")
var direction 
var speed = 800.0
var lifetime = 0.8
var hit_target = false
@onready var sprite = $Sprite2D
@onready var player = get_node(".")

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func die():
	if !hit_target:
		hit_target = true
		$AnimationPlayer.play("Hit")
		queue_free()
		
func _physics_process(delta):
	if !hit_target:
		var velocity = Vector2(speed * delta * direction, 0)
		var raycast_position = position + velocity.normalized() 
		$RayCast2D.global_position = raycast_position
		if $RayCast2D.is_colliding():
			hit_target = true
			$AnimationPlayer.play("Hit")
			queue_free()
		else:
			position += velocity
		
		if direction < player.position.x:
			print(direction)
			sprite.scale.x = abs(sprite.scale.x) * direction * -1
		elif direction > player.position.x:
			print(direction)
			sprite.scale.x = abs(sprite.scale.x) * direction 

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Enemies") and !hit_target:
		area.get_parent().take_damage(1)
		die()
	if area.get_parent().is_in_group("Boss") and !hit_target:
		area.get_parent().take_damage(1)
		die()
