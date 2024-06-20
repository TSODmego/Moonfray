extends Control

onready var health_bar = $TextureRect

func update_health(current_health, max_health):
	var health_ratio = current_health / max_health
	health_bar.rect_scale.x = health_ratio
