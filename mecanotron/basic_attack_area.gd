class_name boss

extends Area2D

@export var damage: float = 1.5

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	var boss = area.get_parent()
	if boss.has_method("take_damage"):
		boss.take_damage(area.damage)
		queue_free()
