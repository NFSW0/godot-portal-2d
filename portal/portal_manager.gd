extends Node
class_name _PortalManager


var request_list:Array[TransportData] = []
var process_limit = 100 # 进程限制


var _transport_tasks:Array[TransportingData] = [] # 进行中的传送，记录克隆体，用于判断重复的传送请求，特别是因克隆体导致的叠加传送


## 请求-添加传送
func append_transport_request(data: Dictionary):
	var new_request = TransportData.instantiate(data)
	if new_request == null:
		return
	
	# 剔除重复数据（在请求列表中检测）
	var length = min(request_list.size(), process_limit)
	var slice_list = request_list.slice(-length)
	for transport_data: TransportData in slice_list:
		if Tool.are_arrays_equal(transport_data.to_array(), new_request.to_array()):
			return
	
	# 检测 `_transport_tasks` 中是否已存在相同的任务
	for transporting_data: TransportingData in _transport_tasks:
		var portal_array1 = [transporting_data.portal1, transporting_data.portal2]
		var portal_array2 = [new_request.portal1, new_request.portal2]
		if Tool.are_arrays_equal(portal_array1, portal_array2) and transporting_data.targets.has(new_request.target):
			return
	
	# 添加待处理事件
	request_list.push_back(new_request)


## 请求-结束传送
func end_transport_request(data: Dictionary):
	var new_request = TransportData.instantiate(data)
	if new_request == null:
		return
	
	# 使用倒序索引遍历数组
	for i in range(_transport_tasks.size() - 1, -1, -1):
		var transporting_data: TransportingData = _transport_tasks[i]
		
		# 比较传送门数组
		var portal_array1 = [transporting_data.portal1, transporting_data.portal2]
		var portal_array2 = [new_request.portal1, new_request.portal2]
		if Tool.are_arrays_equal(portal_array1, portal_array2) and transporting_data.targets[0] == new_request.target:
			# 获取节点
			var node = get_node_or_null(transporting_data.targets[0])
			var duplicate_node = get_node_or_null(transporting_data.targets[1])
			var portal = get_node_or_null(transporting_data.portal1)
			
			# 检查节点有效性
			if not node or not duplicate_node or not portal:
				return
			
			# 调用传送结束方法
			portal.erase_task(node, duplicate_node)
			
			# 从数组中移除目标
			_transport_tasks.remove_at(i)
			break


## 清理缓存
func clear_hit_event():
	request_list.clear()


## 结算传送
func _physics_process(_delta: float) -> void:
	var events_to_process = min(request_list.size(), process_limit)
	for i in range(events_to_process):
		var transport_data: TransportData = request_list.pop_front()
		_handle_transport(transport_data.portal1, transport_data.portal2, transport_data.target)


## 处理传送(生成复制体，分配传送门，记录传送中数据)
func _handle_transport(portal1, portal2, target):
	var node_portal1 = get_node_or_null(portal1)
	var node_portal2 = get_node_or_null(portal2)
	var node_target = get_node_or_null(target)
	if not node_portal1 or not node_portal2 or not node_target:
		return
	var node_target_duplicate = node_target.duplicate()
	node_target_duplicate.name = node_target.name + "_duplicate"
	node_target_duplicate.material = (node_target_duplicate.material as ShaderMaterial).duplicate()
	node_target.get_parent().add_child(node_target_duplicate)
	_transport_tasks.append(TransportingData.new(portal1, portal2, [target, node_target_duplicate.get_path()]))
	node_portal1.add_task(node_target, node_target_duplicate)
