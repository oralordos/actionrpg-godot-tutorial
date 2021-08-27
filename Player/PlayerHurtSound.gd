extends AudioStreamPlayer

func _ready() -> void:
	var error_code := connect("finished", self, "queue_free")
	assert(error_code == 0)
