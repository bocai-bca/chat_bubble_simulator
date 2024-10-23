## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name MessageBubble
extends CanvasGroup

const ClassPackedScene: PackedScene = preload("res://message_bubble.tscn")

var bubble_number: int = -1 #气泡的序号排位，为0表示在屏幕最底部
var text: String #气泡的文本
var _config: CBS.BubbleConfig #气泡配置
var _send_from_right: bool #气泡来自哪端，false左，true右
var _life_timer: float = 0.0 #气泡的已存在时间，用于与淡入时间计算出状态和移动
#var _typing_time_left: float = 0.0 #剩余输入时间
var _show_corner: bool = true #控制是否显示气泡角

#transform变量组
var _tf_pos_timer: float = 0.0 #坐标变换计时器
var _tf_pos_from: Vector2 = Vector2.ZERO #移动目标坐标
var _tf_pos_to: Vector2 = Vector2.ZERO #移动起始坐标
var _tf_bubble_timer: float = 0.0 #气泡变换计时器
var _tf_bubble_x_from: float = CBSConfig.bubble_unit_pixel * 4 #气泡X起始长度(胶囊的高度)
var _tf_bubble_x_to: float = CBSConfig.bubble_unit_pixel * 4 #气泡X目标长度(胶囊的高度)
var _tf_bubble_y_from: float = 0.0 #气泡Y起始长度(下胶囊的Y位移)
var _tf_bubble_y_to: float = 0.0 #气泡Y目标长度(下胶囊的Y位移)
var _tf_corner_timer: float = 0.0 #气泡角变换计时器

@onready var n_text: Label = get_node("Text") as Label
@onready var n_bubble: Node2D = get_node("Bubble") as Node2D
@onready var n_up_capsule: MeshInstance2D = get_node("Bubble/UpCapsule") as MeshInstance2D
@onready var n_down_capsule: MeshInstance2D = get_node("Bubble/DownCapsule") as MeshInstance2D
@onready var n_quad: MeshInstance2D = get_node("Bubble/Quad") as MeshInstance2D
@onready var n_sphere_left: MeshInstance2D = get_node("SphereLeft") as MeshInstance2D
@onready var n_sphere_middle: MeshInstance2D = get_node("SphereMiddle") as MeshInstance2D
@onready var n_sphere_right: MeshInstance2D = get_node("SphereRight") as MeshInstance2D
@onready var n_corner_sphere: MeshInstance2D = get_node("Bubble/CornerSphere") as MeshInstance2D
@onready var n_corner_quad_up: MeshInstance2D = get_node("Bubble/UpCornerQuad") as MeshInstance2D
@onready var n_corner_quad_down: MeshInstance2D = get_node("Bubble/DownCornerQuad") as MeshInstance2D

func _enter_tree() -> void:
	set_visible(false)
	CBS.current.bubbles_move.connect(on_bubbles_move) #连接移动气泡的信号
	CBS.current.bubbles_add_number.connect(on_bubbles_add_number) #连接增加气泡序号的信号

func _ready() -> void:
	print("Bubble Creating Debug: open , right = ", _send_from_right)
	n_text.label_settings.font = CBSConfig.label_font
	_old_build_bubble()
	_old_fit_position()
	if (_send_from_right):
		CBS.current.n_audio_imessage_send.play()
	else:
		CBS.current.n_audio_imessage_receive.play()

func _physics_process(__delta: float) -> void:
	__delta *= CBSConfig.time_speed
	self_modulate = Color(Color.WHITE, clampf(_life_timer, 0.0, CBSConfig.bubble_fadein_time) / CBSConfig.bubble_fadein_time)
	#n_text.modulate = Color(Color.WHITE, ease((_life_timer - CBSConfig.bubble_fadein_time) / CBSConfig.text_fadein_time, CBSConfig.bubble_transform_ease_curve)) #平滑阶梯，二选一
	n_text.modulate = Color(Color.WHITE, clampf((_life_timer - CBSConfig.text_fadein_start_time) / CBSConfig.text_fadein_time, 0.0, 1.0)) #线性，二选一
	position = _tf_pos_from.lerp(_tf_pos_to, ease(_tf_pos_timer / CBSConfig.bubble_fadein_time, CBSConfig.bubble_transform_ease_curve)) #平滑阶梯，二选一
	#position = _tf_pos_from.lerp(_tf_pos_to, clampf(_tf_pos_timer / CBSConfig.bubble_fadein_time, 0.0, 1.0)) #线性，二选一
	_life_timer += __delta #存活时间增加
	_tf_pos_timer += __delta #位移计时增加
	#_typing_time_left -= __delta #打字时间减少
	#if (_typing_time_left <= 0.0): #如果已经完成打字
		#_tf_bubble_timer += __delta #气泡变换计时增加
	_tf_bubble_timer += __delta #气泡变换计时增加
	#网格形状的变换计算
	var __mesh_transform_process: float = ease(_tf_bubble_timer / CBSConfig.bubble_fadein_time, CBSConfig.bubble_transform_ease_curve) #平滑阶梯，二选一
	#var __mesh_transform_process: float = clampf(_tf_bubble_timer / CBSConfig.bubble_fadein_time, 0.0, 1.0) #线性，二选一
	var __x_now: float = _tf_bubble_x_from + (_tf_bubble_x_to - _tf_bubble_x_from) * __mesh_transform_process #气泡横向总长
	(n_up_capsule.mesh as CapsuleMesh).height = __x_now
	(n_quad.mesh as QuadMesh).size.x = __x_now
	var __y_now: float = _tf_bubble_y_from + (_tf_bubble_y_to - _tf_bubble_y_from) * __mesh_transform_process
	n_down_capsule.position.y = __y_now #设置下胶囊的Y位置
	n_quad.position.y = __y_now / 2.0 #设置矩形的Y位置，为下胶囊与上胶囊位置的中心
	(n_quad.mesh as QuadMesh).size.y = __y_now #设置矩形的高度
	# 气泡角变换计算
	_tf_corner_timer += __delta #气泡角变换计时器加时
	var __corner_radius: float #气泡角圆形半径
	if (_show_corner): #如果本气泡应显示气泡角
		__corner_radius = lerpf(CBSConfig.bubble_unit_pixel, CBSConfig.bubble_corner_min_radius, ease(_tf_corner_timer / CBSConfig.bubble_corner_animation_time, CBSConfig.bubble_transform_ease_curve))
	else: #如果本气泡不应显示气泡角
		__corner_radius = lerpf(CBSConfig.bubble_corner_min_radius, CBSConfig.bubble_unit_pixel, ease(_tf_corner_timer / CBSConfig.bubble_corner_animation_time, CBSConfig.bubble_transform_ease_curve))
	(n_corner_sphere.mesh as SphereMesh).radius = __corner_radius
	(n_corner_sphere.mesh as SphereMesh).height = __corner_radius * 2.0
	var __corner_quad_size: Vector2
	n_corner_sphere.position = Vector2(__x_now / 2.0 - __corner_radius, __y_now + CBSConfig.bubble_unit_pixel - __corner_radius)
	__corner_quad_size = Vector2(CBSConfig.bubble_unit_pixel, clampf(CBSConfig.bubble_unit_pixel - __corner_radius, 0.0, CBSConfig.bubble_unit_pixel))
	(n_corner_quad_up.mesh as QuadMesh).size = __corner_quad_size #两个气泡角矩形使用同一个网格，所以设置上矩形等同于一起设置了下矩形
	n_corner_quad_up.position = Vector2(__x_now / 2.0 - __corner_quad_size.x / 2.0, n_down_capsule.position.y + __corner_quad_size.y / 2.0)
	n_corner_quad_down.position = Vector2(__x_now / 2.0 - __corner_radius - __corner_quad_size.y / 2.0, n_down_capsule.position.y + __corner_quad_size.x / 2.0)
	if (not _send_from_right): #如果不是右侧气泡
		n_corner_sphere.position.x *= -1
		n_corner_quad_up.position.x *= -1
		n_corner_quad_down.position.x *= -1
	# /气泡角变换计算
	#/网格形状的变换计算
	n_text.set_position(n_quad.position + n_text.size / -2.0 + Vector2(0.0, -0.5)) #将文本居中于气泡中心
	#重设可见性，用于刷新MeshInstance节点的渲染边界
	n_up_capsule.set_visible(false)
	n_up_capsule.set_visible(true)
	#/重设可见性，用于刷新MeshInstance节点的渲染边界
	set_visible(true)

func _old_build_bubble() -> void: #直接成品气泡构建函数，将气泡各项状态调整到与当前文本、发送方、配置参数适配的状态，只在直接创建成品气泡时调用
	#气泡构成组织
	n_text.label_settings.font_size = int(CBSConfig.bubble_unit_pixel) #设置文本字体大小
	n_text.modulate = Color(1.0, 1.0, 1.0, 0.0)
	# 求文本框大小
	var __text_splitted: PackedStringArray = text.split("\n") #将文本以行列分段的列表
	var __length_array: Array[float] = [] #长度表
	var __is_auto_warp: Array[bool] = [false] #记录是否存在自动换行的情况的引用布尔，如果为true表示当前存在单行文本以多行显示的情况
	for __text_part in __text_splitted:
		__length_array.append(_find_min_length_of_line(__text_part, __is_auto_warp))
	__length_array.sort()
	n_text.set_text(text) #赋予文本
	n_text.set_size(Vector2(__length_array[-1], 0.0)) #设定X为确定的最小X
	# /求文本框大小
	# 求气泡大小并构成气泡
	var __bubble_empty_width: float = (CBSConfig.bubble_max_width_multiplier - CBSConfig.bubble_text_max_width_multiplier) * CBSConfig.bubble_unit_pixel #求气泡与文本的宽度差值，表示将上述比值求出结果的明确的像素数值
	#  构成气泡的X
	var __bubble_width: float = __bubble_empty_width + __length_array[-1]
	_tf_bubble_x_to = __bubble_width #将X赋予胶囊形
	(n_quad.mesh as QuadMesh).size.x = __bubble_width #将X赋予矩形
	#  /构成气泡的X
	#  构成气泡的Y
	if (__text_splitted.size() <= 1 and not __is_auto_warp[0]): #单行文本
		n_text.set_text("") #用于用玄学修复set_size不影响Y的问题
		n_text.set_size(Vector2(n_text.size.x, 0.0)) #重设文本框的Y长度
		n_text.set_text(text) #用于用玄学修复set_size不影响Y的问题
		n_down_capsule.set_visible(false)
		n_quad.set_visible(false)
		_tf_bubble_y_to = 0.0
		n_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else: #多行文本
		n_text.set_text("") #用于用玄学修复set_size不影响Y的问题
		n_text.set_size(Vector2(n_text.size.x, 0.0)) #重设文本框的Y长度
		n_text.set_text(text) #用于用玄学修复set_size不影响Y的问题
		n_text.set_size(Vector2(n_text.size.x, 0.0)) #重设文本框的Y长度
		var __bubble_height: float = n_text.size.y - 6.0
		var __capsule_radius: float = CBSConfig.bubble_unit_pixel #获取胶囊半径，该值等同于文本字体大小
		var __capsule_offset: float = __bubble_height - __capsule_radius #计算下胶囊偏移距离
		_tf_bubble_y_to = __capsule_offset
	#  /构成气泡的Y
	(n_up_capsule.mesh as CapsuleMesh).rings = CBSConfig.bubble_mesh_rings #设置气泡环数
	(n_corner_sphere.mesh as SphereMesh).rings = CBSConfig.bubble_mesh_rings #设置气泡环数
	# /求气泡大小并构成气泡
	# 设置颜色
	print("Bubble Creating Debug: setting color")
	n_bubble.modulate = _config.fill_color
	n_text.label_settings.font_color = _config.text_color
	# /设置颜色
	#/气泡构成组织
	#气泡缩放
	(n_up_capsule.mesh as CapsuleMesh).radius = CBSConfig.bubble_unit_pixel
	#/气泡缩放

func _init_text() -> void: #Label初始化，影响字体大小、颜色、节点调制
	n_text.label_settings.font_size = int(CBSConfig.bubble_unit_pixel) #设置文本字体大小
	n_text.modulate = Color(1.0, 1.0, 1.0, 0.0)
	n_text.label_settings.font_color = _config.text_color

func _handle_text() -> void: #将气泡的文本根据配置的宽度进行适配，影响Label节点的边框并为Label节点设置文本，不影响坐标。在使用之前需要确保本节点的text已被赋值
	var __text_splitted: PackedStringArray = text.split("\n") #将文本以行列分段的列表
	var __length_array: Array[float] = [] #长度表
	var __is_auto_warp: Array[bool] = [false] #记录是否存在自动换行的情况的引用布尔，如果为true表示当前存在单行文本以多行显示的情况
	for __text_part in __text_splitted:
		__length_array.append(_find_min_length_of_line(__text_part, __is_auto_warp))
	__length_array.sort()
	n_text.set_text(text) #赋予文本
	n_text.set_size(Vector2(__length_array[-1], 0.0)) #设定X为确定的最小X

func _build_typing_bubble() -> void: #构成输入气泡
	pass

func _old_fit_position() -> void: #根据气泡渲染的形状适配坐标变换的起始位置和目标位置，跟随气泡构建函数一起使用，只能调用一次。适用于输入气泡和直接成品的气泡
	#设定气泡位置
	var __anchor_offset: Vector2 = Vector2(0.0, _tf_bubble_y_to + (n_down_capsule.mesh as CapsuleMesh).radius) #从锚点(中心)到定位点的坐标偏移量
	var __target: Vector2 #用于计算目标位置的坐标
	var __bottom_distance: float = CBSConfig.bubble_unit_pixel * CBSConfig.screen_bubble_bottom_distance_multiplier
	var __beside_distance: float = CBSConfig.bubble_unit_pixel * CBSConfig.screen_bubble_border_distance_multiplier
	if (_send_from_right): #如果是靠右的气泡
		__anchor_offset += Vector2(_tf_bubble_x_to / 2.0, 0.0)
		#前往右下角
		__target = Vector2(CBS.viewport_width * (1.0 - CBSConfig.screen_bubble_border_distance_multiplier), CBS.viewport_height * (1.0 - CBSConfig.screen_bubble_bottom_distance_multiplier))
		#/前往右下角
	else: #如果是靠左的气泡
		__anchor_offset -= Vector2(_tf_bubble_x_to / 2.0, 0.0)
		#前往左下角
		__target = Vector2(__beside_distance, CBS.viewport_height * (1.0 - CBSConfig.screen_bubble_bottom_distance_multiplier))
		#/前往左下角
	var __start_pos_offset: Vector2 = Vector2(0.0, (n_up_capsule.mesh as CapsuleMesh).radius * -2.0 - _tf_bubble_y_to - __bottom_distance)
	if ((_send_from_right and CBS.newest_bubble_side == 2) or (not _send_from_right and CBS.newest_bubble_side == 1)): #如果上一个气泡与自己同侧
		print("Bubble Creating Debug: same side")
		__start_pos_offset.y += __bottom_distance * clampf(1.0 - CBSConfig.screen_same_side_bubbles_distance_multiplier, 0.0, 1.0) #将偏移值加上同侧气泡的距离缩短
	_tf_pos_to = __target - __anchor_offset - __start_pos_offset
	var __bubble_empty_width: float = (CBSConfig.bubble_max_width_multiplier - CBSConfig.bubble_text_max_width_multiplier) * CBSConfig.bubble_unit_pixel #求气泡与文本的宽度差值，表示将上述比值求出结果的明确的像素数值
	if (_send_from_right):
		_tf_pos_from = Vector2(
			CBS.viewport_width - __bubble_empty_width - (n_up_capsule.mesh as CapsuleMesh).height / 2.0,
			_tf_pos_to.y
		)
	else:
		_tf_pos_from = Vector2(
			#__beside_distance * 3.0 + (n_up_capsule.mesh as CapsuleMesh).radius,
			__bubble_empty_width + (n_up_capsule.mesh as CapsuleMesh).height / 2.0,
			_tf_pos_to.y
		)
	CBS.current.emit_signal("bubbles_move", __start_pos_offset)
	match (_send_from_right):
		false: #左侧
			CBS.newest_bubble_side = 1
		true: #右侧
			CBS.newest_bubble_side = 2
	CBS.current.emit_signal("bubbles_add_number")
	#/设定气泡位置

func _refit_position() -> void: #根据气泡渲染的形状和坐标变换的起始位置适配目标位置，跟随气泡构建函数一起使用，可被重复调用。适用于输入气泡变形为成品气泡
	pass

func _find_min_length_of_line(__single_line: String, out__is_auto_warp: Array[bool]) -> float:
	#输入一个单行的文本，输出该文本保持为单行时的最小宽度
	#如果输入因太长或带有换行符等原因导致在受限于最大文本宽度时不得不大于等于两行，则输出最大宽度
	var __text_max_width: float = CBSConfig.bubble_text_max_width_multiplier * CBSConfig.bubble_unit_pixel #求文本最大宽度
	var __result: float = __text_max_width
	n_text.set_text(__single_line) #设定Label的文本为输入参数
	n_text.set_size(Vector2(__text_max_width, 0.0)) #将Label的宽度设为最大宽度
	var __current_lines: int = n_text.get_line_count()
	if (__current_lines >= 2): #如果文本大于等于两行
		out__is_auto_warp[0] = true
		return __text_max_width
	else: #如果文本为单行
		while (__result > 0.0): #直到结果宽度不再大于0之前循环
			__result -= 1.0 #将输出减少1
			n_text.set_size(Vector2(__result, 0.0)) #设定缩减X后的宽度
			if (n_text.get_line_count() != __current_lines): #如果显示行数变了
				__result += 1.0 #将输出增加1
				print("Bubble Creating Debug: x decreasing finished, width is ", __result)
				break #退出循环
	return clampf(__result, (CBSConfig.bubble_max_width_multiplier - CBSConfig.bubble_text_max_width_multiplier) * CBSConfig.bubble_unit_pixel * 1.5, __result)

func on_bubbles_move(__pos_add: Vector2) -> void: #收到移动气泡的信号时，将自身坐标加上传入参数
	_tf_pos_from = _tf_pos_from.lerp(_tf_pos_to, clampf(_tf_pos_timer, 0.0, CBSConfig.bubble_fadein_time) / CBSConfig.bubble_fadein_time)
	_tf_pos_to += __pos_add
	_tf_pos_timer = 0.0

func on_bubbles_add_number() -> void: #收到增加气泡序号的信号时，给自身序号增加1
	if (bubble_number == 0):
		if (_send_from_right and CBS.newest_bubble_side == 2): #如果自身为右且新气泡为右
			_show_corner = false
			_tf_corner_timer = 0.0
		elif (not _send_from_right and CBS.newest_bubble_side == 1): #如果自身为左且新气泡为左
			_show_corner = false
			_tf_corner_timer = 0.0
	bubble_number += 1
	z_index += 1

func on_out_of_viewport() -> void: #收到超出屏幕范围的信号时，根据配置决定是否清除自身
	if (CBSConfig.auto_free):
		queue_free()

static func get_new(__text: String, __sender_is_right: bool, __config: CBS.BubbleConfig) -> MessageBubble: #通过类获取节点实例
	var __ins: MessageBubble = ClassPackedScene.instantiate() as MessageBubble
	__ins.text = __text
	__ins._config = __config
	__ins._send_from_right = __sender_is_right
	return __ins
