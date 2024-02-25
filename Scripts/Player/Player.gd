extends CharacterBody2D
class_name Player

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed = 300.0
@export var jump_height = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player = self

func _physics_process(delta):
	if Input.is_action_just_pressed("Left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	if Input.is_action_just_pressed("Right"):
		sprite.scale.x = abs(sprite.scale.x) 
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_height

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	update_animation()
	move_and_slide()
	
	if position.y >= 600:
		die()

func update_animation():
	if velocity.x != 0:
		animation.play("Run")
	else:
		animation.play("Idle")
	
	if velocity.y < 0:
		animation.play("Jump")
	if velocity.y > 0:
		animation.play("Fall")

func die():
	GameManager.respawn_player()
