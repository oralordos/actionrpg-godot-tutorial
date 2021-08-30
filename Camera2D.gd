extends Camera2D

onready var topLeft := $Limits/TopLeft as Position2D
onready var bottomRight := $Limits/BottomRight as Position2D

func _ready() -> void:
	# warning-ignore:narrowing_conversion
	limit_top = topLeft.position.y
	# warning-ignore:narrowing_conversion
	limit_left = topLeft.position.x
	# warning-ignore:narrowing_conversion
	limit_bottom = bottomRight.position.y
	# warning-ignore:narrowing_conversion
	limit_right = bottomRight.position.x
