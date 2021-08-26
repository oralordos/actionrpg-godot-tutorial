extends Area2D

func is_colliding() -> bool:
	var areas := get_overlapping_areas()
	return !areas.empty()

func get_push_vector() -> Vector2:
	var areas := get_overlapping_areas()
	var push_vector := Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
	return push_vector