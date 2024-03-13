extends CharacterBody2D
class_name Player

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var speed = 300.0
@export var jump_height = -400

var toxic_ball = load("res://GameplayScenes/PlayerWeapon/new_arrow.tscn")
var bowequip = true
var bowcooldown = true
@onready var firepoint = $ArrowPoint
@onready var respawn = $Respawn

var jump_count = 0
var max_jump = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var attacking = false
@export var bowshooting = false

@export var max_health = 10
var health = 0
var can_take_damage = true

const dash_speed = 700.0
@export var dashing = false
var can_dash = true

var is_dead: bool = false

var last_sound_frame: int = 0
const sound_cooldown_frames: int = 45

func _ready():
	health = max_health
	GameManager.player = self
	print(health)
	respawn.get_child(0).hide()
	
func _process(delta):
	if !is_dead:
		if Input.is_action_just_pressed("Attack"):
			attack()

func _physics_process(delta):
	if !is_dead:
		if Input.get_action_strength("Left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
			$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
			$ArrowPoint.scale.x = abs($ArrowPoint.scale.x) * -1
			play_run_sound()
		if Input.get_action_strength("Right"):
			sprite.scale.x = abs(sprite.scale.x) 
			$AttackArea.scale.x = abs($AttackArea.scale.x) 
			$ArrowPoint.scale.x = abs($ArrowPoint.scale.x) 
			play_run_sound()
		
		if not is_on_floor():
			velocity.y += gravity * delta
			$Sound/Run.volume_db = -100
	
		if is_on_floor():
			jump_count = 0
			$Sound/Run.volume_db = -13

		if Input.is_action_just_pressed("Jump") and jump_count < max_jump:
			velocity.y = jump_height
			jump_count += 1
	
		if Input.is_action_just_pressed("Dash") and can_dash:
			dashing = true
			can_dash = false
			$dash_timer.start()
			$dash_again_timer.start()
		
		var direction = Input.get_axis("Left", "Right")
		if direction:
			if dashing:
				velocity.x = direction * dash_speed
			else:
				velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
		update_animation()
		move_and_slide()
		fire()
	
	if position.y >= 600:
		die()

func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(1)
		if area.get_parent().is_in_group("Boss"):
			area.get_parent().take_damage(1)
	
	attacking = true
	bowshooting = false
	animation.play("Attack")
	$Sound/MeleeAttack.play()

func update_animation():
	if !attacking and !bowshooting:
		if velocity.x != 0:
			animation.play("Run")
		else:
			animation.play("Idle")
			$Sound/Run.stop()
		if velocity.y < 0:
			animation.play("Jump")
			$Sound/Jump.play()
		if velocity.y > 0:
			animation.play("Fall")
		if dashing == true:
			animation.play("Dash")
			$Sound/Dash.play()
func take_damage(damage_amount : int):
	if can_take_damage and !dashing:
		iframes()
		
		health -= damage_amount
		
		get_node("../UIManager/TextureProgressBar").update_healthbar(health, max_health)
		
		$Sound/Pain.play()
		
		if health <= 0:
			die()

func eatChicken():
	health += 1;
	$Sound/Eat.play()
	get_node("../UIManager/TextureProgressBar").update_healthbar(health, max_health)

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	if !is_dead:
		respawn.get_child(0).show()
		is_dead = true
		$Sound/Run.stop()
		$Sound/Jump.stop()
		$Sound/Dash.stop()
		$Sound/Pain.stop()
		attacking = false
		bowshooting = false
	animation.play("Die")
	get_node("../Queen Fly").set_is_player_dead(true)
	self.remove_from_group("Player")
	$Sound/Die.play()

func _input(event):
	if event.is_action_pressed("Down") && is_on_floor():
		position.y += 5

func _on_timer_timeout():
	dashing = false

func _on_dash_again_timer_timeout():
	
	can_dash = true

func fire():
	if Input.is_action_just_pressed("Shoot") and bowequip and bowcooldown:
		attacking = false
		bowshooting = true
		$AnimationPlayer.play("Fire")
		$Sound/BowShoot.play()
		bowcooldown = false
		var spawned_ball = toxic_ball.instantiate()
		spawned_ball.direction = firepoint.scale.x
		spawned_ball.global_position = firepoint.global_position
		get_tree().get_root().add_child(spawned_ball)
		
		await get_tree().create_timer(0.8).timeout
		bowcooldown = true
		
func play_run_sound():
	var current_frame = Engine.get_frames_drawn()
	if current_frame - last_sound_frame >= sound_cooldown_frames:
		$Sound/Run.play()
		last_sound_frame = current_frame


