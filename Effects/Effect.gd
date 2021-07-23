extends AnimatedSprite

func _ready() -> void:
	var error_code := connect("animation_finished", self, "_on_animation_finished")
	assert(error_code == 0)
	play("Animate")

func _on_animation_finished() -> void:
	queue_free()
