extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jump: bool = true
var score: int = 0
var is_attacking: bool = false

@onready var basic_attack_area = $Mecanotron/basic_attack_Area
@onready var basic_attack_collision = $Mecanotron/basic_attack_Area/CollisionShape2D
@export var health_ui: ProgressBar

func _ready():
	basic_attack_collision.disabled = true
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and not double_jump:
		double_jump = true

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
		
	move_and_slide()
		
	if Input.is_action_just_pressed("basic_attack") and not is_attacking:
			basic_attack()
		
func basic_attack():
	is_attacking = true
	basic_attack_collision.disabled = false
	await get_tree().create_timer(0.5).timeout
	basic_attack_collision.disabled = true
	is_attacking = false
