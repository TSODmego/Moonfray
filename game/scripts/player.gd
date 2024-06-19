extends CharacterBody2D

const SPEED = 180
const JUMP_VELOCITY = -250
const DOUBLE_JUMP_VELOCITY = -200 # 二段跳的跳跃速度

# 生命值相关变量
var max_health = 100  # 最大生命值
var health = max_health  # 当前生命值

# 二段跳相关变量
var can_double_jump = false  # 是否可以执行二段跳

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 0.9 * delta
	else:
		can_double_jump = true  # 落地后可以执行二段跳

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false  # 执行二段跳后不能再次执行

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func heal(amount):
	# 回复生命值
	health += amount
	health = min(health, max_health)  # 确保生命值不超过最大值

func take_damage(amount):
	# 受到伤害
	health -= amount
	if health <= 0:
		die()  # 生命值小于等于0时,调用死亡函数

func die():
	# 玩家死亡逻辑
	print("Player died!")
	get_tree().reload_current_scene()
	# 在此添加玩家死亡后的处理逻辑,如重新开始游戏或返回关卡选择界面等
