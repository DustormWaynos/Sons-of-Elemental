extends Control

@onready var fill_max = 100
var fill_amount : float

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.value = fill_max


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_healthbar(health, max_health):
	fill_amount = (float(health) / max_health) * fill_max
	
	print("Health " + str(fill_amount))
	
	$ProgressBar.value = fill_amount
