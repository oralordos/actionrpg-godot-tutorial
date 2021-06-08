extends Node2D

onready var animatedSprite := ($AnimatedSprite as AnimatedSprite)

func _ready() -> void:
	animatedSprite.play("Animate")

func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
