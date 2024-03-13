extends Node2D

@onready var hanna_label := $HannaLabel

func _ready():
	$AnimationPlayer.play("Idle")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		start_conversation()
		$Ting.play()
		
func start_conversation():
	hanna_label.text = "Hello, hope you have a good journey!"
	hanna_label.visible = true

func _on_area_2d_area_exited(area):
	if area.get_parent() is Player:
		stop_conversation()

func stop_conversation():
	hanna_label.visible = false
