extends Area2D

@export var speed: float = 300.0

var direction: Vector2 = Vector2.LEFT

func _ready() -> void:
	$AnimatedSprite2D.play("rocket")

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if direction.x <0:
		$AnimatedSprite2D.flip_h = true
	else:
		$ANimatedSprite2D.flip_h = false
 
func _on_body_entered(body: Node2D) -> void:
	print("ROCKET HIT: ", body.name)
	if body.is_in_group("player"):
		print("EXPLODING")
		speed = 0
		body.take_damage(30)
		$AnimatedSprite2D.play("explosion")
		await $AnimatedSprite2D.animation_finished
		queue_free()
