extends CharacterBody2D

var speed = 5000.0

var dead = false
@onready var sprite = $Sprite2D

var max_health = 2
var health

var players : Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var container = get_node("Container")
@onready var player = get_node("../Player")

var player_in_sight

func _ready():
	health = max_health
	$Container/AnimationPlayer.play("Idle")

func _physics_process(delta):
	if player_in_sight and player.is_in_group("Player"):
		velocity = (player.global_position - self.global_position).normalized() * speed * delta
	else:
		velocity = Vector2(0, 0)
		
	if self.global_position.x > player.global_position.x:
		sprite.scale.x = abs(sprite.scale.x)
		
	elif self.global_position.x < player.global_position.x:
		sprite.scale.x = abs(sprite.scale.x) * -1
		

	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player") && !dead:
		area.get_parent().take_damage(2)

func take_damage(damage_amount):
	health -= damage_amount
	
	get_node("MonsterHealthBar").update_healthbar(health, max_health)
	
	$Container/AnimationPlayer.play("Hit")
	$Hurt.play()
	
	if health <= 0:
		die()

func die(): 
	dead = true
	speed = 0
	$Container/AnimationPlayer.play("Die")
	$Hurt.play
	self.remove_from_group("Enemies")
	
func _on_player_in_sight(area):
	if area.get_parent().is_in_group("Player"):
		player_in_sight = true
		speed = 5000

func _on_exit_area_area_exited(area):
	if area.get_parent().is_in_group("Player"):
		speed = 0

