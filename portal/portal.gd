extends Node2D
class_name Portal


@export var targe_portal:Portal
@onready var portal_manager = get_node("/root/PortalManager")  # 获取传送管理器


var teleporting_task = []


## 开始
func _on_area_entered(area: Area2D) -> void:
	if not targe_portal:
		return
	var transport_request = TransportData.new(self.get_path(), targe_portal.get_path(), area.get_path())
	portal_manager.append_transport_request(transport_request.serialize())
func _on_body_entered(body: Node2D) -> void:
	if not targe_portal:
		return
	var transport_request = TransportData.new(self.get_path(), targe_portal.get_path(), body.get_path())
	portal_manager.append_transport_request(transport_request.serialize())


## 结束
func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


## 传送开始 开启Shader裁剪
func add_task(node:Node, duplicate_node:Node):
	teleporting_task.append({"node":node, "duplicate_node":duplicate_node})
	


## 传送结束 关闭Shader裁剪
func erase_task(node:Node, duplicate_node:Node):
	teleporting_task.erase({"node":node, "duplicate_node":duplicate_node})
	


## 传送处理
func _process(delta: float) -> void:
	# 遍历所有传送中的节点
	for task in teleporting_task:
		var node = task["node"]
		var duplicate_node = task["duplicate_node"]
		if not is_instance_valid(node) or not is_instance_valid(duplicate_node) or not targe_portal:  # 确保节点和目标传送门有效
			continue
		
		_update_material(node, duplicate_node)
		
		_sync_transform(node, duplicate_node)


## 更新材质 用于更新裁剪
func _update_material(node, duplicate_node):
	var node_material = node.get("material")


## 同步变换
func _sync_transform(node, duplicate_node):
	pass


## 交换
func _interchange(node, duplicate_node):
	pass
