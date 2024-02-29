extends CharacterBody2D
class_name Player

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed = 300.0
@export var jump_height = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var attacking = false

@export var max_health = 10
var health = 0
var can_take_damage = true

func _ready():
	health = max_health
	GameManager.player = self

func _process(delta):
	if Input.is_action_just_pressed("Attack"):
		attack()

func _physics_process(delta):
	if Input.is_action_just_pressed("Left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		#$Area2D.scale.x = abs($Area2D.scale.x) * -1
	if Input.is_action_just_pressed("Right"):
		sprite.scale.x = abs(sprite.scale.x) 
		#$Area2D.scale.x = abs($Area2D.scale.x) 
	
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

func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().die()
	
	attacking = true
	animation.play("Attack")

func update_animation():
	if !attacking:
		if velocity.x != 0:
			animation.play("Run")
		else:
			animation.play("Idle")
	
		if velocity.y < 0:
			animation.play("Jump")
		if velocity.y > 0:
			animation.play("Fall")

func take_damage(damage_amount : int):
	if can_take_damage:
		iframes()
		
		health -= damage_amount
		
		get_node("Healthbar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	GameManager.respawn_player()

func _input(event):
	if event.is_action_pressed("Down") && is_on_floor():
		position.y += 5
