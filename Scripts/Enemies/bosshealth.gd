extends Control

@onready var fill_max = $queenbosshealth.size.x
var fill_amount : float


func update_healthbar(health, max_health):
	fill_amount = (float(health) / max_health) * fill_max
	$queenbosshealth.size.x = fill_amount
