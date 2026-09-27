extends Area2D


@export var max_health: int = 500
@onready var health_bar = $"../CanvasLayer/BossHealthBar"
@export var projectile_scene: PackedScene
@onready var player = get_tree().get_first_node_in_group("player")

var attack_position = [-6, 100, 200]
var health: int

func _ready() -> void:
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	
func take_damage(damage: int) -> void:
	health -= damage
	health = max(health, 0)
	print("HEALTH:", health)
	health_bar.value = health
	
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func shoot_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	var attack_row = randi_range(0, 2)
	
	attack_position.shuffle()
	var y_position = attack_position[0]
	projectile.global_position = Vector2(global_position.x, y_position)
	
	get_tree().current_scene.add_child(projectile)
	
	projectile.direction = Vector2.LEFT
	projectile.speed = 400.0
	

func _on_timer_timeout() -> void:
	shoot_projectile()
