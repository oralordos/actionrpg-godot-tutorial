extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible := false setget set_invincible

onready var timer := $Timer as Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value: bool) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration: float) -> void:
	self.invincible = true
	timer.start(duration)

func create_hit_effect() -> void:
	var effect := HitEffect.instance()
	effect.global_position = global_position
	var main := get_tree().current_scene
	main.add_child(effect)

func _on_Timer_timeout() -> void:
	self.invincible = false

func _on_Hurtbox_invincibility_started() -> void:
	set_deferred("monitorable", false)

func _on_Hurtbox_invincibility_ended() -> void:
	monitorable = true
