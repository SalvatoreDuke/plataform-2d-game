extends CharacterBody2D
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

#estados em enum do boneco
enum Playerstate {
	idle,
	walk,
	jump,
	fall,
	duck
}

#variaveis globais
const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var status: Playerstate
var direction = 0
var jump_count = 0
@export var max_jump_count = 2
#funções de estado global
func _ready() -> void:
	go_to_idle_state()
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		Playerstate.idle:
			idle_state()
		Playerstate.walk:
			walk_state()
		Playerstate.jump:
			jump_state()
		Playerstate.duck:
			duck_state()
		Playerstate.fall:
			fall_state()
	move_and_slide()


#estados do boneco
func go_to_idle_state():
	status = Playerstate.idle
	animated.play("Idle")
func go_to_walk_state():
	status = Playerstate.walk
	animated.play("walk")
func go_to_jump_state():
	status = Playerstate.jump
	animated.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func go_to_duck_state():
	status = Playerstate.duck
	animated.play("duck")
	collision_shape.shape.radius = 4
	collision_shape.shape.height = 12
	collision_shape.position.y = 7
func go_to_fall_state():
	status = Playerstate.fall
	animated.play("fall")

#maquina de estados do boneco
func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	jump()
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
	if !is_on_floor():
		jump_count += 1 #caso eu queira remover, isso desconta o "pulo duplo pós queda"
		go_to_fall_state() 
	jump()
func jump_state():
	move()
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
		
	if velocity.y > 0:
		go_to_fall_state()
		return
	
	jump()
func duck_state():
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
func fall_state():
	move()
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()

	if is_on_floor():
		jump_count = 0
		go_to_idle_state()
		return

#movimentação do boneco
func move():
	update_direction()
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if is_on_floor() == false:
		update_direction()
func update_direction():
	direction = Input.get_axis("left", "right")
	if direction > 0:
			animated.flip_h = true
	elif direction < 0:
			animated.flip_h = false
func exit_from_duck_state():
	collision_shape.shape.radius = 4
	collision_shape.shape.height = 24
	collision_shape.position.y = 1
func can_jump() -> bool:
	return jump_count < max_jump_count
	
