extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 125
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state := MOVE
var velocity := Vector2.ZERO
var roll_vector := Vector2.LEFT

onready var animationTree := ($AnimationTree as AnimationTree)
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			roll_state(delta)

		ATTACK:
			attack_state(delta)

func move_state(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(_delta: float) -> void:
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(_delta: float) -> void:
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move() -> void:
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity.normalized() * MAX_SPEED
	state = MOVE

func attack_animation_finished() -> void:
	state = MOVE
