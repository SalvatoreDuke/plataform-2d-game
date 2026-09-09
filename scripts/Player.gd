extends CharacterBody2D
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
#estados em enum do boneco
enum Playerstate {
	idle,
	walk,
	jump
}

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var status: Playerstate

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
	animated.play("Jump")


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
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
	jump()
func jump_state():
	move()
	if is_on_floor():
		go_to_idle_state()
		return
	jump()




#movimentação do boneco
func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction > 0:
			animated.flip_h = false
	elif direction < 0:
			animated.flip_h = true
func jump():
	var direction := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if is_on_floor() == false:
		if direction > 0:
			animated.flip_h = false
		elif direction < 0:
			animated.flip_h = true
