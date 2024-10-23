## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBS
extends Node2D

signal bubbles_move(relative_pos: Vector2)
signal bubbles_add_number()

const CURRENT_VERSION: String = "0.2.2"
const WORK_MODE_VIDEO: int = 0
const WORK_MODE_IMAGE: int = 1

static var viewport_width: float
static var viewport_height: float
static var current: CBS #用于访问当前的伪单例
static var newest_bubble_side:int = 0 #记录上一个生成的气泡来自哪侧，0=空，1=左，2=右
var _state: int = 0 #0=初始化前,1=主循环,2=最后一次循环并标记退出,3=现在退出
var _left_timer: float = 0.0 #左侧计时器
var _right_timer: float = 0.0 #右侧计时器
var _left_array: Array[MessageStruct] = [] #左侧气泡列表，用于Video模式
var _right_array: Array[MessageStruct] = [] #右侧气泡列表，用于Video模式
var _left_index: int = 0 #CBSConfig.messages的索引计数，用于左侧气泡列表
var _right_index: int = 0 #CBSConfig.messages的索引计数，用于右侧气泡列表
var _is_left_typing: bool = false #左侧是否正在打字，决定当前计时使用等待时间还是打字时间
var _auto_exit_timer: float = 0.0 #自动退出计时器

@onready var n_background_color: ColorRect = get_node("BackgroundColor")
@onready var n_audio_imessage_send: AudioStreamPlayer = get_node("Audio_iMessageSend")
@onready var n_audio_imessage_receive: AudioStreamPlayer = get_node("Audio_iMessageReceive")

func _enter_tree() -> void:
	current = self
	viewport_width = get_viewport().get_window().size.x
	viewport_height = get_viewport().get_window().size.y

func _ready() -> void:
	print("Chat Bubble Simulator initializing, version: " + CURRENT_VERSION)
	var __total_messages: int = CBSConfig.messages.size() #消息条数总计
	if (CBSConfig.work_mode == WORK_MODE_VIDEO):
		print("Work mode = Video Mode")
		var __max_time: float = CBSConfig.bubble_fadein_time #最大持续时间计算器
		for __message in CBSConfig.messages: #遍历消息列表
			if (not __message.sender): #如果本消息是左侧发送
				_left_array.append(__message)
				__max_time += __message.waiting_time + __message.typing_time
		var __right_side_time: float = CBSConfig.bubble_fadein_time #临时计算用的右侧持续时间
		for __message in CBSConfig.messages:
			if (__message.sender): #如果本消息是右侧发送
				_right_array.append(__message)
				__right_side_time += __message.waiting_time + __message.typing_time
		__max_time = maxf(__max_time, __right_side_time) #将最大时间设为左侧和右侧中更大的那一个
		print("Total messages = " + str(__total_messages))
		print("Total time = " + str(__max_time))
	else:
		print("Work mode = Image Mode")
		print("Total messages = " + str(__total_messages))
	n_background_color.color = CBSConfig.background_color
	n_background_color.custom_minimum_size = get_viewport().get_window().size
	for __audio in get_tree().get_nodes_in_group("Audio"):
		(__audio as AudioStreamPlayer).pitch_scale = CBSConfig.time_speed
	if (_state == 0):
		_state = 1

func _physics_process(__delta: float) -> void:
	if (_state >= 2 and CBSConfig.auto_exit): #退出处理逻辑
		_auto_exit_timer += __delta
		if (_auto_exit_timer >= CBSConfig.auto_exit_wait_time):
			if (_state >= 3):
				get_tree().call_deferred("quit")
			_state += 1
	elif (_state == 1): #如果状态处于主循环
		__delta *= CBSConfig.time_speed
		match (CBSConfig.work_mode): #匹配工作模式
			WORK_MODE_VIDEO:
				_main_video(__delta)
			WORK_MODE_IMAGE:
				_main_image(__delta)

func _main_video(__delta: float) -> void: #Video模式的主循环
	_left_timer += __delta #左计时器加时
	_right_timer += __delta #右计时器加时
	var __loop_control: bool = true #单刻循环控制
	while (__loop_control): #进入左侧循环
		if (_left_index >= _left_array.size()): #如果左列表没有剩余任务
			break #直接退出循环
		match (_is_left_typing): #左侧是否正处于输入状态
			false: #否，计时器跟随等待时长
				if (_left_timer >= _left_array[_left_index].waiting_time): #当左计时器达到等待时长
					_left_timer -= _left_array[_left_index].waiting_time #左计时器减去等待时长
					_is_left_typing = true
					##启用左侧输入效果器
				else: #左计时器未达到等待时长
					__loop_control = false #结束循环
			true: #是，计时器跟随输入时长
				if (_left_timer >= _left_array[_left_index].typing_time): #当左计时器达到输入时长
					_left_timer -= _left_array[_left_index].typing_time #左计时器减去输入时长
					_is_left_typing = false
					##结束左侧输入效果器，并生成新的左侧气泡
					add_child(MessageBubble.get_new(_left_array[_left_index].content, false, CBSConfig.left_bubble_config))
					_left_index += 1
				else: #左计时器未达到输入时长
					__loop_control = false #结束循环
	__loop_control = true #重设单刻循环控制
	while (__loop_control): #进入右侧循环
		if (_right_index >= _right_array.size()): #如果右列表没有剩余任务
			break #直接退出循环
		if (_right_timer >= _right_array[_right_index].waiting_time): #当右计时器达到等待时长
			_right_timer -= _right_array[_right_index].waiting_time #右计时器减去等待时长
			##生成新的右侧气泡
			add_child(MessageBubble.get_new(_right_array[_right_index].content, true, CBSConfig.right_bubble_config))
			_right_index += 1
		else: #右计时器未达到等待时长
			__loop_control = false #结束循环
	if (_left_index >= _left_array.size() and _right_index >= _right_array.size() and minf(_left_timer, _right_timer) >= maxf(CBSConfig.bubble_fadein_time - CBSConfig.text_fadein_start_time + CBSConfig.text_fadein_time, CBSConfig.bubble_corner_animation_time)): #如果左侧右侧均已完成，并且数字最小的计时器也达到了气泡的淡入时间
		_state = 2 #标记于接下来的第二刻退出项目

func _main_image(__delta: float) -> void: #Image模式的主循环
	pass

class MessageStruct:
	var content: String
	var sender: bool
	var waiting_time: float
	var typing_time: float
	func _init(__send_from_right: bool, __content: String, __waiting_time: float, __typing_time: float) -> void:
		sender = __send_from_right
		content = __content
		waiting_time = __waiting_time
		typing_time = __typing_time

class BubbleConfig: #气泡设置
	var fill_color: Color #气泡填充颜色
	var text_color: Color #文本颜色
	func _init(__fill_color: Color, __text_color: Color) -> void:
		fill_color = __fill_color
		text_color = __text_color
