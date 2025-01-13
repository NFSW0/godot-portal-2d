extends Node2D

@onready var simple_entity: CharacterBody2D = $SimpleEntity

# 定义每帧的相对变化量
var velocity = Vector2(10, 5)       # 位置变化量
var angular_velocity = 0.2         # 旋转变化量
var scale_velocity = 0.1           # 缩放变化量
var scale_direction = Vector2(1, 1)  # 缩放变化方向

func _process(delta: float) -> void:
	# 相对改变位置
	simple_entity.position += velocity * delta

	# 相对改变旋转
	simple_entity.rotation += angular_velocity * delta

	# 相对改变缩放
	simple_entity.scale += scale_velocity * scale_direction * delta

	# 在缩放变换中，不对任何外力施加限制，仅在超出范围时自动反向循环
	if simple_entity.scale.x > 1.5 or simple_entity.scale.x < 0.5:
		scale_direction.x *= -1
	if simple_entity.scale.y > 1.5 or simple_entity.scale.y < 0.5:
		scale_direction.y *= -1
