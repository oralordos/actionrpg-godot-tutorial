extends KinematicBody2D

const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var ACCELERATION := 300
export(int) var MAX_SPEED := 50
export(int) var FRICTION := 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO

onready var state = pick_random_state([IDLE, WANDER])

onready var sprite := $AnimatedSprite
onready var stats := $Stats
onready var playerDetectionZone := $PlayerDetectionZone
onready var hurtbox := $Hurtbox
onready var softCollision := $SoftCollision
onready var wanderController := $WanderController

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()

		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(delta, wanderController.target_position)
			var distance := global_position.distance_squared_to(wanderController.target_position)
			if distance < velocity.length_squared() * delta:
				update_wander()

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(delta, player.global_position)
			else:
				state = IDLE

	velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(delta: float, point: Vector2) -> void:
	var direction: Vector2 = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player() -> void:
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander() -> void:
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_back()

func _on_Hurtbox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.2)
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect := EnemyDeathEffect.instance()
	enemyDeathEffect.position = position
	get_parent().add_child_below_node(self, enemyDeathEffect)
