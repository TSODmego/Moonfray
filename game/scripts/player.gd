extends CharacterBody2D

signal healthChanged

const SPEED = 165
const JUMP_VELOCITY = -250
const DOUBLE_JUMP_VELOCITY = -200 # 二段跳的跳跃速度
const MAX_HEALTH = 100  # 最大生命值

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound

var currentHealth = MAX_HEALTH   # 当前生命值
var can_double_jump = false  # 是否可以执行二段跳
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dying = false

func _physics_process(delta):
	if is_dying:
		return
	if currentHealth <= 0:
		die()
		return 
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 0.9 * delta
	else:
		can_double_jump = true  # 落地后可以执行二段跳
	
	# Handle jump.
	if Input.is_action_just_pressed("action_jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			play_jump_sound()
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false  # 执行二段跳后不能再次执行
			play_jump_sound()
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Move direction:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	# Player state:
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif direction != 0:
			animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func take_damage(amount):

	currentHealth -= amount
	currentHealth = max(currentHealth, 0)
	emit_signal("healthChanged")
	print("Current health: %d" % currentHealth)


func heal(amount):
	currentHealth += amount
	currentHealth = min(currentHealth, MAX_HEALTH)
	emit_signal("healthChanged")
	print("Current health: %d" % currentHealth)

func die():
	is_dying = true	
	print("Player died!")
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished 
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene() 

func isPlayer():
	return true
	

func play_jump_sound():
	if jump_sound:
		if jump_sound.playing:
			jump_sound.stop()
		jump_sound.pitch_scale = randf_range(0.9, 1.1)  # 添加一些随机音调变化
		jump_sound.play()
