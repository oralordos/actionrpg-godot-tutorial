extends KinematicBody2D

const PlayerHurtSound := preload("res://Player/PlayerHurtSound.tscn")

export(int) var ACCELERATION := 500
export(int) var MAX_SPEED := 80
export(int) var ROLL_SPEED := 125
export(int) var FRICTION := 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state := MOVE
var velocity := Vector2.ZERO
var roll_vector := Vector2.DOWN
var stats := PlayerStats

onready var animationTree := ($AnimationTree as AnimationTree)
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
onready var swordHitbox := $HitboxPivot/SwordHitbox
onready var hurtbox := $Hurtbox
onready var blinkAnimationPlayer := $BlinkAnimationPlayer as AnimationPlayer

func _ready() -> void:
	randomize()
	var error_code := stats.connect("no_health", self, "queue_free")
	assert(error_code == 0)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			roll_state()

		ATTACK:
			attack_state()

func move_state(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
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

func roll_state() -> void:
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state() -> void:
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move() -> void:
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity.normalized() * MAX_SPEED
	state = MOVE

func attack_animation_finished() -> void:
	state = MOVE

func _on_Hurtbox_area_entered(area) -> void:
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound := PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started() -> void:
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended() -> void:
	blinkAnimationPlayer.play("Stop")
