extends Control

var hearts := 4 setget set_hearts
var max_hearts := 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull as TextureRect
onready var heartUIEmpty = $HeartUIEmpty as TextureRect

func set_hearts(value: int) -> void:
	hearts = clamp(value, 0, max_hearts) as int
	heartUIFull.rect_size.x = hearts * 15

func set_max_hearts(value: int) -> void:
	max_hearts = max(value, 1) as int
	self.hearts = min(hearts, max_hearts) as int
	heartUIEmpty.rect_size.x = max_hearts * 15

func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	var error_code := PlayerStats.connect("health_changed", self, "set_hearts")
	assert(error_code == 0)
	error_code = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	assert(error_code == 0)
