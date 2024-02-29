extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("Player")

func _physics_process(delta):
	velocity = (player.position - self.position).normalized() * SPEED * delta

	move_and_slide()
