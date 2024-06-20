extends Control

@onready var health_bar = $TextureRect
@onready var initial_width = health_bar.size.x  # 存储初始宽度

func update_health(current_health, max_health):
	var health_ratio = current_health / max_health
	health_bar.size.x = initial_width * health_ratio
