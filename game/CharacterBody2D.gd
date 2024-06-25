extends CharacterBody2D

var speed = 170 # 移动速度，与玩家相同
var rotation_speed = 5  # 旋转速度
var follow_distance = 30  # 与玩家保持的距离，略微增加
var pet_scale = 0.75  # 宠物的缩放比例
var smoothing_factor = 10  # 平滑移动因子

@onready var player = $"../Player"  # 假设玩家节点在同一级别
@onready var sprite = $Sprite2D  # 假设你有一个Sprite2D子节点

func _ready():
	# 设置宠物的整体大小
	scale = Vector2(pet_scale, pet_scale)
	
	# 不再调整速度，保持与玩家相同
	# follow_distance 不再缩放，保持固定值
	
	# 设置碰撞层
	set_collision_mask_value(1, false)  # 不检测与玩家的碰撞
	set_collision_mask_value(2, true)   # 检测与地图碰撞
	set_collision_layer_value(1, false) # 玩家不会与宠物碰撞
	set_collision_layer_value(2, true)  # 地图会与宠物碰撞

func _physics_process(delta):
	if not player:
		return
	
	# 计算朝向玩家的方向
	var direction = (player.global_position - global_position).normalized()
	
	# 计算与玩家的距离
	var distance = global_position.distance_to(player.global_position)
	
	# 目标速度
	var target_velocity = Vector2.ZERO
	
	# 如果距离大于follow_distance，则移动
	if distance > follow_distance:
		target_velocity = direction * speed
	
	# 平滑移动
	velocity = velocity.lerp(target_velocity, delta * smoothing_factor)
	
	# 移动宠物
	move_and_slide()
	
	# 更新朝向
	update_orientation(delta)

	# 调试输出
	# print("Pet velocity: ", velocity.length())

func update_orientation(delta):
	# 根据玩家位置翻转精灵
	if player.global_position.x > global_position.x:
		sprite.flip_h = false  # 玩家在右边，不翻转
	else:
		sprite.flip_h = true   # 玩家在左边，翻转
	
	# 滚动动画
	if velocity.length() > 0:
		var rotation_direction = 1 if velocity.x > 0 else -1
		rotation += rotation_speed * delta * rotation_direction
	else:
		rotation = lerp_angle(rotation, 0, 5 * delta)

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = 2 * PI
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

# 如果你需要在游戏运行时动态改变宠物大小，可以使用这个函数
func change_pet_size(new_scale: float):
	pet_scale = new_scale
	scale = Vector2(pet_scale, pet_scale)
	# 速度和跟随距离不再随大小变化
