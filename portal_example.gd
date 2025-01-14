extends Node2D

@onready var simple_entity: CharacterBody2D = $SimpleEntity

# 定义每帧的变化速度
var move_speed = 100       # 移动速度
var rotate_speed = 1.0     # 旋转速度（弧度/秒）
var scale_speed = 0.5      # 缩放速度

func _process(delta: float) -> void:
	# 处理位置控制
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1

	# 更新位置
	simple_entity.position += move_direction.normalized() * move_speed * delta

	# 处理旋转控制
	if Input.is_action_pressed("rotate_left"):
		simple_entity.rotation -= rotate_speed * delta
	if Input.is_action_pressed("rotate_right"):
		simple_entity.rotation += rotate_speed * delta

	# 处理缩放控制
	if Input.is_action_pressed("scale_up"):
		simple_entity.scale += Vector2.ONE * scale_speed * delta
	if Input.is_action_pressed("scale_down"):
		simple_entity.scale -= Vector2.ONE * scale_speed * delta

	# 限制缩放范围
	simple_entity.scale.x = clamp(simple_entity.scale.x, 0.5, 1.5)
	simple_entity.scale.y = clamp(simple_entity.scale.y, 0.5, 1.5)
