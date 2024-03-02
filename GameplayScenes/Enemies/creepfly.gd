extends CharacterBody2D

var speed = 5000.0

var dead = false
@onready var sprite = $Sprite2D

var max_health = 2
var health

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var container = get_node("Container")
@onready var player = get_node("../Player")

var player_in_sight

func _ready():
	health = max_health
	$Container/AnimationPlayer.play("Idle")

func _physics_process(delta):
	if player_in_sight:
		velocity = (player.global_position - self.global_position).normalized() * speed * delta

	if self.global_position.x > player.global_position.x:
		sprite.scale.x = abs(sprite.scale.x)
		
	elif self.global_position.x < player.global_position.x:
		sprite.scale.x = abs(sprite.scale.x) * -1
		

	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !dead:
		area.get_parent().take_damage(2)

func take_damage(damage_amount):
	health -= damage_amount
	
	get_node("MonsterHealthbar").update_healthbar(health, max_health)
	
	if health <= 0:
		die()

func die(): 
	dead = true
	speed = 0
	$Container/AnimationPlayer.play("Die")
	
func _on_player_in_sight(area):
	if area.get_parent() is Player:
		player_in_sight = true
