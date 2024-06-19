extends Area2D

var heal_amount = 20  # 药物回复的生命值数量


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.heal(heal_amount)
		print("+20health")  # 调用玩家角色的heal函数来回复生命值
		queue_free()  # 销毁药物节点
