extends Node2D

const GrassEffect := preload("res://Effects/GrassEffect.tscn")

func create_grass_effect() -> void:
	var grassEffect := GrassEffect.instance()
	grassEffect.position = position
	get_parent().add_child_below_node(self, grassEffect)

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	create_grass_effect()
	queue_free()
