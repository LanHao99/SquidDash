extends CharacterBody2D
class_name Player
@onready var PlayerSprite2D = $PlayerSprite2D
@onready var WalkParticles2D = $WalkParticles2D
@onready var DashCollision = $DashCollision
@onready var StandCollision = $StandCollision
@onready var PlayerDetect = $PlayerDetect
const DEAD_SOUND = preload("res://Sounds/dead.mp3")
signal dead
signal entered_checkpoint

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0

var is_jumping = false
var dashing = false
var can_dash = true
var dash_direction = Vector2(1,0)
var current_direction = Vector2(1,0)
var rotated = false

func walk():
	var direction := Input.get_axis("left", "right")

	if (direction > 0):
		PlayerSprite2D.flip_h = false
		current_direction = Vector2(1,0)
	elif (direction < 0):
		PlayerSprite2D.flip_h = true
		current_direction = Vector2(-1,0)

	if direction:
		velocity.x = direction * SPEED
		if (is_on_floor()):
			PlayerSprite2D.play("walk")
	elif direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if (is_on_floor()):
			PlayerSprite2D.play("idle")

func jump():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	if (velocity.y > 0):
		PlayerSprite2D.play("fall")
	elif (velocity.y < 0):
		PlayerSprite2D.play("jump")
	else:
		if is_jumping:
			is_jumping = false
			PlayerSprite2D.play("jump_end")

func dash(delta: float):
	if Input.is_action_just_pressed("dash") and can_dash:
		#根据当前的上下左右按键计算出冲刺方向
		dash_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
		if dash_direction == Vector2(0,0):
			dash_direction = current_direction
		# 给予冲刺初速度，之后每帧由 dash() 函数递减
		velocity = dash_direction * DASH_SPEED
		dashing = true
		can_dash = false
		# 播放动画
		PlayerSprite2D.play("dash")
		# 旋转
		var dash_rotation = dash_direction.angle()
		PlayerSprite2D.flip_h = false
		#改变碰撞箱
		DashCollision.disabled = false
		StandCollision.disabled = true
		#直接旋转了父节点，可能造成意想不到的问题
		rotate(dash_rotation)
		rotated = true
		#停顿0.6秒，这也是动画时间
		await get_tree().create_timer(0.6).timeout
		DashCollision.disabled = true
		StandCollision.disabled = false
		dashing = false
	
	if dashing:
		velocity -= dash_direction * DASH_SPEED * delta * 0.17 #1/6
		WalkParticles2D.emitting = true
	if is_on_floor() and !dashing:
		can_dash = true
		WalkParticles2D.emitting = false
	if rotated and !dashing:
		rotation = 0

func die():
	set_physics_process(false)
	PlayerSprite2D.play("die")
	SoundManager.play_sound(DEAD_SOUND)
	await PlayerSprite2D.animation_finished
	dead.emit()
	queue_free()
	
	
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !dashing:
		walk()
		jump()
	dash(delta)
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"CheckPoint"):
		entered_checkpoint.emit()
