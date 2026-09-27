extends CharacterBody2D


const SPEED = 500
const JUMP_VELOCITY = -600

var double_jump: bool = true
var score: int = 0
var is_attacking: bool = false
var can_attack: bool = true

@export var max_health: int = 100
@onready var health_bar = $"../CanvasLayer2/PlayerHealthBar"
@onready var attack_area = $Mecanotron/AttackArea
@onready var attack_collision = $Mecanotron/AttackArea/CollisionShape2D
@export var health_ui: ProgressBar
@onready var animated_sprite = $Mecanotron
@export var attack_cooldown: float = 0.5

var health: int

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and not double_jump:
		double_jump = true
		
	if Input.is_action_just_pressed("attack") and can_attack and not is_attacking:
		attack()

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = false
			
		if Input.is_action_just_pressed("ui_down") and is_on_floor():
			position.y += 1
			
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not is_attacking:
		if direction !=0:
			animated_sprite.play("walk")
		else:
			velocity.x = 0
			animated_sprite.play("Idle")
			
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false
	
	if direction > 0:
		attack_area.position.x = 1
	elif direction <0:
		attack_area.position.x = -40
	else:
		attack_area.position.x = 1
	
	move_and_slide()

func attack():
	is_attacking = true
	can_attack = false
	attack_collision.disabled = false
	$Mecanotron.play("attack")
	await $Mecanotron.animation_finished
	attack_collision.disabled = true
	is_attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _ready():
	attack_collision.disabled = true
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health

func _on_attack_area_area_entered(area: Area2D) -> void:
	
	if area.name == "Hitbox":
		area.take_damage(10)

func take_damage(damage: int) -> void:
	health -= damage
	health = max(health, 0)
	
	health_bar.value = health
	print("PLAYER HEALTH:", health)
	if health <= 0:
		die()

func die() -> void:
	print("PLAYER DIED")
