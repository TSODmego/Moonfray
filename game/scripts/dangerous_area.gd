extends Area2D

@onready var timer = $Timer




func _on_timer_timeout():
	get_tree().reload_current_scene()


func _on_body_entered(body):
	timer.start()
	print("fall out")
