extends CharacterBody2D
class_name Player

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed = 300.0
@export var jump_height = -400

var jump_count = 0
var max_jump = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var attacking = false

@export var max_health = 10
var health = 0
var can_take_damage = true

const dash_speed = 700.0
var dashing = false
var can_dash = true

func _ready():
	health = max_health
	GameManager.player = self

func _process(delta):
	if Input.is_action_just_pressed("Attack"):
		attack()

func _physics_process(delta):
	if Input.is_action_just_pressed("Left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
	if Input.is_action_just_pressed("Right"):
		sprite.scale.x = abs(sprite.scale.x) 
		$AttackArea.scale.x = abs($AttackArea.scale.x) 
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("Jump") and jump_count < max_jump:
		velocity.y = jump_height
		jump_count += 1
	
	if Input.is_action_just_pressed("Dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing:
			velocity.x = direction * dash_speed
		else:
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
			area.get_parent().take_damage(1)
	
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
		if dashing == true:
			animation.play("Dash")

func take_damage(damage_amount : int):
	if can_take_damage:
		iframes()
		
		health -= damage_amount
		
		get_node("Healthbar").update_healthbar(health, max_health)
		get_node("../UIManager/ProgressHealthBar").update_healthbar(health, max_health)
				
		if health <= 0:
			die()

func eatChicken():
	health += 1;
	get_node("../UIManager/ProgressHealthBar").update_healthbar(health, max_health)

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	get_node("../UIManager/ProgressHealthBar")._ready()
	GameManager.respawn_player()

func _input(event):
	if event.is_action_pressed("Down") && is_on_floor():
		position.y += 5

func _on_timer_timeout():
	dashing = false

func _on_dash_again_timer_timeout():
	can_dash = true


