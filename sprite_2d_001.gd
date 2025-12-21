# 代码结构：
# - 变量定义
# - _ready() 初始化函数
# - _process(delta) 更新函数
# - _on_body_entered(body) 碰撞检测函数
# - move(direction) 移动方法
# - rotate_sprite(amount) 旋转方法

extends Sprite2D

# 变量定义
var speed = 200.0
var rotation_speed = 1.0
var is_moving = false

# 初始化函数
func _ready():
    # 设置初始位置
    position = Vector2(200, 300)
    # 设置初始旋转
    rotation = 0.0
    # 启用碰撞检测
    $CollisionShape2D.disabled = false
    print("Sprite2D 已初始化")

# 更新函数
func _process(delta):
    var direction = Vector2.ZERO
    
    # 键盘输入检测
    if Input.is_action_pressed("ui_right"):
        direction.x += 1
    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
    if Input.is_action_pressed("ui_down"):
        direction.y += 1
    if Input.is_action_pressed("ui_up"):
        direction.y -= 1
    
    # 如果有输入，移动精灵
    if direction.length() > 0:
        direction = direction.normalized()
        move(direction)
        is_moving = true
    else:
        is_moving = false
    
    # 旋转精灵
    if Input.is_action_pressed("ui_accept"):
        rotate_sprite(rotation_speed * delta)

# 移动方法
func move(direction):
    position += direction * speed * get_process_delta_time()

# 旋转方法
func rotate_sprite(amount):
    rotation += amount

