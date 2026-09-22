extends Area2D


@export var max_health: float = 100.0
@onready var current_health: float = max_health

func take_damage(damage_amount: float):
	current_health -= damage_amount
	
	if current_health <= 0:
		queue_free()	
