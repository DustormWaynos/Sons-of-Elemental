extends Node2D

@onready var witch := $WitchLabel

func _ready():
	$AnimationPlayer.play("Idle")

func start_conversation():
	witch.text = "Sorry, I can't let you go because 
	  Lord Dustorm won't allow it!"
	witch.visible = true

func stop_conversation():
	witch.visible = false

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		start_conversation()
		$Ting.play()

func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:
		stop_conversation()
