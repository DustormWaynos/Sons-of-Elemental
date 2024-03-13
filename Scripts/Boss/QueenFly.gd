extends CharacterBody2D

var speed = 3000.0

var dead = false
@onready var sprite = $Sprite2D
@onready var audio_player = $BattleMusic
var is_music_playing = false
var is_alive = true

var bosswall = BossWall

var canDealDamage = false
var damageCooldown = 1.0

var child2 = load("res://GameplayScenes/Enemies/queenflychild_2.tscn")
var child = load("res://GameplayScenes/Enemies/queenflychild.tscn")
@export var spawning : bool
var spawnrate = 5

@onready var spawnpoint = $Spawnpoint
@onready var spawnpoint2 = $Spawnpoint2

var max_health = 150
var health

var initial_position = global_position

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var container = get_node("$Container")
@onready var player = get_node("../Player")

var player_in_sight
var is_player_dead = false;

func _ready():
	$Timer.set_one_shot(false)
	health = max_health
	$Container/AnimationPlayer.play("Idle")
	$Fly.play()
	$CanvasLayer.get_child(0).hide()
	spawning = true
	spawn()
	

func _physics_process(delta):
	if player_in_sight:
		velocity = (player.global_position - self.global_position).normalized() * speed * delta
	
	dealContinuousDamage()
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("Player") and !dead:
		if is_alive:
			area.get_parent().take_damage(5)
			canDealDamage = true
			$Timer.start()
	
func take_damage(damage_amount):
	health -= damage_amount
	
	get_node("CanvasLayer/QueenFly").update_healthbar(health, max_health)
	
	$Container/AnimationPlayer.play("Hit")
	
	$Hurt.play()
	
	if health <= 0:
		die()

func die(): 
	spawning = false
	is_alive = false
	dead = true
	speed = 0
	$Container/AnimationPlayer.play("Die")
	$Fly.stop()
	$CanvasLayer.get_child(0).hide()
	self.remove_from_group("Boss")
	
	if is_alive:
		$Hurt.play()
	
	get_node("../BossWall").hide_wall()
	get_node("../BossWall2").hide_wall()
	
	var initial_volume = audio_player.volume_db
	var target_volume = -80
	var step = 1.0
	while audio_player.volume_db > target_volume:
		audio_player.volume_db -= step
		await get_tree().create_timer(0.35).timeout
	audio_player.stop()
	$Timer.stop()
	
func _on_detect_area_entered(area):
	if area.get_parent().is_in_group("Player") and !is_music_playing:
		player_in_sight = true
		$CanvasLayer.get_child(0).show()
		audio_player.play()
		is_music_playing = true
		audio_player.stream.loop = true
		speed = 3000
		audio_player.volume_db = 1
		get_node("../BossWall").show_wall()
		get_node("../BossWall2").show_wall()

func spawn():
	while spawning and is_alive:
		$Container/AnimationPlayer.play("Spawn")
		await get_tree().create_timer(spawnrate).timeout
		
func getspawn1():
	var spawned_ball = child.instantiate()
	spawned_ball.direction = spawnpoint.scale.x * -1
	spawned_ball.global_position = spawnpoint.position
	add_child(spawned_ball)

func getspawn2():
	var spawned_ball = child2.instantiate()
	spawned_ball.direction = spawnpoint2.scale.x 
	spawned_ball.global_position = spawnpoint2.position
	add_child(spawned_ball)
	
func dealContinuousDamage():
	if canDealDamage and is_alive and player.is_in_group("Player") and !is_player_dead:
		player.take_damage(5)

func _on_timer_timeout():
	if is_alive and player.is_in_group("Player"):
		player.take_damage(5)
		canDealDamage = false

func _on_hitbox_area_exited(area):
	if area.get_parent().is_in_group("Player") and !dead:
		canDealDamage = false
		$Timer.stop()

func _on_exit_area_area_exited(area):
	if area.get_parent().is_in_group("Player") and !dead and is_music_playing:
		$CanvasLayer.get_child(0).hide()
		is_player_dead = false;
		speed = 0
		is_music_playing = false
		health = max_health
		get_node("CanvasLayer/QueenFly").update_healthbar(health, max_health)
		var initial_volume = audio_player.volume_db
		var target_volume = -80
		var step = 1.0
		while audio_player.volume_db > target_volume:
			audio_player.volume_db -= step
			await get_tree().create_timer(0.03).timeout
		returnToInitialPosition()
		get_node("../BossWall").hide_wall()
		get_node("../BossWall2").hide_wall()

func returnToInitialPosition():
	global_position = initial_position

func set_is_player_dead(is_dead):
	is_player_dead = is_dead;


