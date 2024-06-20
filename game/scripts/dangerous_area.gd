extends Area2D

@onready var timer = $Timer




func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_body_entered(body):
	timer.start()
	Engine.time_scale = 0.5
	print("fall out")
