extends CharacterBody2D
class_name Player


@onready var anim = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var running_direction = 1
var idle_direction = 0

enum State { IDLE, RUNNING, JUMP_FALL, JUMP_PEAK, JUMP_UP, HIT, CROUCH_UP, CROUCH_IDLE, CROUCH_DOWN, CLIMB }

var state = State.IDLE

func _physics_process(delta: float) -> void:
	manage_state(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta


	_run()

	move_and_slide()



func set_state(new_state: State) -> void:
	if state != new_state:
		state = new_state

	print("STATE => ", State.keys()[state])

func _jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		set_state(State.JUMP_UP)

func _run() -> void:
	running_direction = Input.get_axis("ui_left", "ui_right")
	if running_direction:
		velocity.x = running_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if running_direction != 0:
		idle_direction = sign(running_direction)


	anim.flip_h = idle_direction < 0



func manage_state(delta: float) -> void:
	match state:
		State.IDLE:
			handle_idle_state(delta)
		State.RUNNING:
			handle_running_state(delta)
		State.JUMP_FALL:
			handle_jump_fall_state(delta)
		State.JUMP_PEAK:
			handle_jump_peak_state(delta)
		State.JUMP_UP:
			handle_jump_up_state(delta)
		State.HIT:
			handle_hit_state(delta)
		State.CROUCH_UP:
			handle_crouch_up_state(delta)
		State.CROUCH_IDLE:
			handle_crouch_idle_state(delta)
		State.CROUCH_DOWN:
			handle_crouch_down_state(delta)
		State.CLIMB:
			handle_climp_state(delta)


func handle_idle_state(_delta: float) -> void:
	anim.play("idle")

	_jump()

	if int(velocity.x) != 0:
		set_state(State.RUNNING)



func handle_running_state(_delta: float) -> void:
	anim.play("run")

	_jump()

	if int(velocity.x) == 0:
		set_state(State.IDLE)




func handle_jump_fall_state(_delta: float) -> void:
	anim.play("jump_fall")



func handle_jump_peak_state(_delta: float) -> void:
	anim.play("jump_peak")

	if is_on_floor():
		set_state(State.IDLE)


func handle_jump_up_state(_delta: float) -> void:
	anim.play("jump_up")

	if velocity.y > JUMP_VELOCITY / 2:
		set_state(State.JUMP_PEAK)




func handle_hit_state(_delta: float) -> void:
	anim.play("hit")




func handle_crouch_up_state(_delta: float) -> void:
	anim.play("crouch_up")



func handle_crouch_idle_state(_delta: float) -> void:
	anim.play("crouch_idle")




func handle_crouch_down_state(_delta: float) -> void:
	anim.play("crouch_down")




func handle_climp_state(_delta: float) -> void:
	anim.play("climb")
