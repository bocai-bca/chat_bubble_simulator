## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBS
extends Node2D

@warning_ignore("unused_signal")
signal bubbles_move(relative_pos: Vector2)
@warning_ignore("unused_signal")
signal bubbles_add_number()

const CURRENT_VERSION: String = "0.2.8"
const WORK_MODE_VIDEO: int = 0
const WORK_MODE_IMAGE: int = 1

const SUPPORT_FONT_POSTFIX: PackedStringArray = [".tres", ".res", ".ttf", ".fontdata", ".ttc", ".otf", ".otc", ".woff", ".woff2", ".pfb", ".pfm", ".fnt", ".font"] #自动字体搜寻所支持的所有文件后缀

static var viewport_width: float
static var viewport_height: float
static var current: CBS #用于访问当前的伪单例
static var newest_bubble_side:int = 0 #记录上一个生成的气泡来自哪侧，0=空，1=左，2=右
var _state: int = 0 #0=初始化前,1=主循环,2=最后一次循环并标记退出,3=现在退出
var _left_timer: float = 0.0 #左侧计时器
var _right_timer: float = 0.0 #右侧计时器
var _left_array: Array[MessageStruct] = [] #左侧气泡列表，用于Video模式
var _right_array: Array[MessageStruct] = [] #右侧气泡列表，用于Video模式
var _left_index: int = 0 #CBSConfig.messages的索引计数，用于左侧气泡列表，只在Video模式生效
var _right_index: int = 0 #CBSConfig.messages的索引计数，用于右侧气泡列表，只在Video模式生效
var _auto_exit_timer: float = 0.0 #自动退出计时器

@onready var n_background_color: ColorRect = get_node("BackgroundColor")
@onready var n_audio_imessage_send: AudioStreamPlayer = get_node("Audio_iMessageSend")
@onready var n_audio_imessage_receive: AudioStreamPlayer = get_node("Audio_iMessageReceive")
@onready var n_bubbles: Node2D = get_node("Bubbles")

func _enter_tree() -> void:
	current = self
	viewport_width = get_viewport().get_window().size.x
	viewport_height = get_viewport().get_window().size.y

func _ready() -> void:
	print("Chat Bubble Simulator initializing, version: " + CURRENT_VERSION)

	if (Engine.get_write_movie_path() != "" and CBSConfig.work_mode == WORK_MODE_IMAGE): #获取MovieMaker的输出路径，不为空表示开了MovieMaker，并且当前处于图片模式
		print("Warning! It isn't allowed to enable MovieMaker when run as Image Mode.\nLaunching cancelling...")
		get_tree().quit(1) #退出
		return

	if (CBSConfig.auto_search_font): #是否开启自动搜索字体
		print("AutoSearchFont = True")
		if (not DirAccess.dir_exists_absolute("res://fonts")): #如果fonts目录不存在
			print("AutoFontSearching: Folder \"fonts\" not found, creating...")
			DirAccess.make_dir_absolute("res://fonts") #创建fonts目录
		var _fonts_dir: DirAccess = DirAccess.open("res://fonts") #打开fonts目录
		if (DirAccess.get_open_error() != OK): #如果打开有问题
			print("AutoFontSearching: Error on opening DirAccess. Searching cancelled.")
		else: #否则(如果打开没问题)
			var _files_in_fonts: PackedStringArray = _fonts_dir.get_files() #获取文件列表
			if (_files_in_fonts.size() >= 1): #如果找到了文件
				print("AutoFontSearching: Found files:")
				for _file in _files_in_fonts: #遍历找到的文件
					print("	", _file)
				var _found_font_usable: bool = false
				for _postfix in SUPPORT_FONT_POSTFIX: #遍历所有支持的后缀
					if (_files_in_fonts.has("font" + _postfix) and load("res://fonts/font" + _postfix) is Font): #如果存在font.<后缀>且有效
						print("AutoFontSearching: Using \"font" + _postfix + "\".")
						CBSConfig.label_font = load("res://fonts/font" + _postfix) as Font
						_found_font_usable = true
						break
				if (!_found_font_usable): #如果都不存在或有效，就遍历
					for _file_name in _files_in_fonts: #遍历找到的文件
						var _file_postfix_name: String = _file_name.split(".")[-1] #获取文件后缀名
						if (SUPPORT_FONT_POSTFIX.has("." + _file_postfix_name)): #检查后缀名是否可用
							if (load("res://fonts/" + _file_name) is Font): #如果文件是字体资源
								print("AutoFontSearching: Using \"", _file_name, "\".")
								CBSConfig.label_font = load("res://fonts/" + _file_name) as Font #应用字体
								_found_font_usable = true
								break
				if (!_found_font_usable): #如果没有可用的文件
					print("AutoFontSearching: No file is usable. Searching cancelled.")
			else: #否则(没有找到文件)
				print("AutoFontSearching: No file found. Searching cancelled.")
	else:
		print("AutoSearchFont = False")

	var __total_messages: int = CBSConfig.messages.size() #消息条数总计
	if (CBSConfig.work_mode == WORK_MODE_VIDEO):
		print("Work mode = Video Mode")
		var __max_time: float = CBSConfig.bubble_fadein_time #最大持续时间计算器
		for __message in CBSConfig.messages: #遍历消息列表
			if (not __message.sender): #如果本消息是左侧发送
				_left_array.append(__message)
				__max_time += __message.waiting_time
		var __right_side_time: float = CBSConfig.bubble_fadein_time #临时计算用的右侧持续时间
		for __message in CBSConfig.messages:
			if (__message.sender): #如果本消息是右侧发送
				_right_array.append(__message)
				__right_side_time += __message.waiting_time
		__max_time = maxf(__max_time, __right_side_time) #将最大时间设为左侧和右侧中更大的那一个
		print("Total messages = " + str(__total_messages))
		print("Total time = " + str(__max_time))
		if (not DirAccess.dir_exists_absolute("res://movie_output")): #如果movie_output目录不存在
			print("VideoMode: Folder \"movie_output\" not found, creating...")
			DirAccess.make_dir_absolute("res://movie_output") #创建movie_output目录
	else:
		print("Work mode = Image Mode")
		print("Total messages = " + str(__total_messages))
	n_background_color.color = CBSConfig.background_color
	n_background_color.custom_minimum_size = get_viewport().get_window().size
	for __audio in get_tree().get_nodes_in_group("Audio"):
		(__audio as AudioStreamPlayer).pitch_scale = CBSConfig.time_speed
	if (_state == 0):
		_state = 1

func _process(__delta: float) -> void:
	if (CBSConfig.work_mode != WORK_MODE_IMAGE):
		return
	if (_state == 1): #如果处于主循环
		_main_image()
	if (_state == 9):
		_main_image_set_viewport()
	if (_state >= 10): #如果主循环已完成
		if (_state == 10): #位于第10刻时进行截图
			if (not DirAccess.dir_exists_absolute("res://image_output")): #如果image_output目录不存在
				print("ImageMode: Folder \"image_output\" not found, creating...")
				DirAccess.make_dir_absolute("res://image_output") #创建image_output目录
			var _date_dict: Dictionary = Time.get_datetime_dict_from_system() #获取系统时间字典
			var _date_time: String = str(_date_dict.year) + "_" + str(_date_dict.month) + "_" + str(_date_dict.day) + "_" + str(_date_dict.hour) + "_" + str(_date_dict.minute) + "_" + str(_date_dict.second) #组合时间字符串
			var _random_postfix: String = ""
			while (true): #获取时间并设为文件名
				if (not FileAccess.file_exists("res://image_output/"+_date_time+_random_postfix+".png")): #如果路径中没有重名文件
					break
				_random_postfix = "_%x" % str(randi_range(16, 255)) #生成一个随机二位十六进制数后缀
			var _final_path: String = "res://image_output/"+_date_time+"_"+_random_postfix+".png"
			get_window().get_texture().get_image().save_png(_final_path) #保存图片文件
			if (FileAccess.file_exists(_final_path)): #检查文件是否存在
				print("ImageMode: Image has been outputted at ", _final_path)
		elif (_state >= 11 and CBSConfig.auto_exit): #11刻之后，并且开启了自动退出
			get_tree().quit()
	_state += 1 #进行延时

func _physics_process(__delta: float) -> void:
	if (CBSConfig.work_mode != WORK_MODE_VIDEO):
		return
	if (_state >= 2 and CBSConfig.auto_exit): #退出处理逻辑
		_auto_exit_timer += __delta
		if (_auto_exit_timer >= CBSConfig.auto_exit_wait_time):
			if (_state >= 3):
				get_tree().call_deferred("quit")
			_state += 1
	elif (_state == 1): #如果状态处于主循环
		__delta *= CBSConfig.time_speed
		_main_video(__delta)

func _main_video(__delta: float) -> void: #Video模式的主循环
	_left_timer += __delta #左计时器加时
	_right_timer += __delta #右计时器加时
	var __loop_control: bool = true #单刻循环控制
	while (__loop_control): #进入左侧循环
		if (_left_index >= _left_array.size()): #如果左列表没有剩余任务
			break #直接退出循环
		if (_left_timer >= _left_array[_left_index].waiting_time): #当左计时器达到等待时长
			_left_timer -= _left_array[_left_index].waiting_time #左计时器减去等待时长
			n_bubbles.add_child(MessageBubble.get_new(_left_array[_left_index].content, false, CBSConfig.left_bubble_config))
			_left_index += 1
		else: #左计时器未达到等待时长
			__loop_control = false #结束循环
	__loop_control = true #重设单刻循环控制
	while (__loop_control): #进入右侧循环
		if (_right_index >= _right_array.size()): #如果右列表没有剩余任务
			break #直接退出循环
		if (_right_timer >= _right_array[_right_index].waiting_time): #当右计时器达到等待时长
			_right_timer -= _right_array[_right_index].waiting_time #右计时器减去等待时长
			##生成新的右侧气泡
			n_bubbles.add_child(MessageBubble.get_new(_right_array[_right_index].content, true, CBSConfig.right_bubble_config))
			_right_index += 1
		else: #右计时器未达到等待时长
			__loop_control = false #结束循环
	if (_left_index >= _left_array.size() and _right_index >= _right_array.size() and minf(_left_timer, _right_timer) >= maxf(CBSConfig.bubble_fadein_time - CBSConfig.text_fadein_start_time + CBSConfig.text_fadein_time, CBSConfig.bubble_corner_animation_time)): #如果左侧右侧均已完成，并且数字最小的计时器也达到了气泡的淡入时间
		_state = 2 #标记于接下来的第二刻退出项目

func _main_image() -> void: #Image模式的主操作
	for _message in CBSConfig.messages: #进入循环
		if (_message.sender): #如果是右侧发出的
			n_bubbles.add_child(MessageBubble.get_new(_message.content, true, CBSConfig.right_bubble_config))
		else: #如果是左侧发出的
			n_bubbles.add_child(MessageBubble.get_new(_message.content, false, CBSConfig.left_bubble_config))

func _main_image_set_viewport() -> void:
	var _window: Window = get_window() #获取根窗口
	var _y_max: float = 0.0 #Y最大值
	var _y_min: float = 0.0 #Y最小值
	var _bubbles: Array[MessageBubble]
	for _node in n_bubbles.get_children():
		_bubbles.append(_node as MessageBubble)
	for _bubble in _bubbles: #获取所有气泡
		if (_bubble.bubble_number == 0): #屏幕最底部的气泡
			_y_max = _bubble._tf_pos_to.y + _bubble._tf_bubble_y_to + (_bubble.n_down_capsule.mesh as CapsuleMesh).radius + CBSConfig.screen_bubble_bottom_distance_multiplier * CBSConfig.bubble_unit_pixel
		if (_bubble.bubble_number == _bubbles.size() - 1): #屏幕最高处的气泡
			_y_min = _bubble._tf_pos_to.y - (_bubble.n_up_capsule.mesh as CapsuleMesh).radius - CBSConfig.screen_bubble_bottom_distance_multiplier * CBSConfig.bubble_unit_pixel
	var _window_size: Vector2i = Vector2i(viewport_width, int(_y_max - _y_min)) #计算新的窗口尺寸
	_window.max_size = _window_size #设定窗口最大尺寸
	_window.min_size = _window_size #设定窗口最大尺寸
	_window.size = _window_size #设定窗口最大尺寸
	n_background_color.custom_minimum_size = _window_size #设定背景尺寸
	n_bubbles.position.y = _window.size.y - viewport_height #设定气泡显示位置偏移，显示将通过偏移抵消屏幕底部变更的距离

class MessageStruct:
	var content: String
	var sender: bool
	var waiting_time: float
	func _init(__send_from_right: bool, __content: String, __waiting_time: float) -> void:
		sender = __send_from_right
		content = __content
		waiting_time = __waiting_time

class BubbleConfig: #气泡设置
	var fill_color: Color #气泡填充颜色
	var text_color: Color #文本颜色
	func _init(__fill_color: Color, __text_color: Color) -> void:
		fill_color = __fill_color
		text_color = __text_color
