## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBSConfig
extends Object

## You can only modify below ##
##     |      |      |       ##
##     |      |      |       ##
##     |      |      |       ##
##     V      V      V       ##

#	背景颜色
static var background_color: Color = Color(0.8, 0.8, 0.8)
#	background_color


#	左侧气泡的配置
static var left_bubble_config: CBS.BubbleConfig = CBS.BubbleConfig.new(
	Color.WHITE, # <--- fill color
	Color.BLACK # <--- text color
)
#	left_bubble_config


#	右侧气泡的配置
static var right_bubble_config: CBS.BubbleConfig = CBS.BubbleConfig.new(
	Color.DODGER_BLUE, # <--- fill color
	Color.WHITE # <--- text color
)
#	right_bubble_config


#	气泡渲染的圆弧线段数
static var bubble_mesh_rings: int = 16
#	bubble_mesh_rings, be used at the attribute mesh.rings of MeshInstance2D of each bubble.


#	气泡淡入时间
static var bubble_fadein_time: float = 0.2
#	bubble_fadein_time(seconds), bubbles fade-in animation time.
#	Only work on Video Mode.


#	气泡基础像素单位UnitPixel
static var bubble_unit_pixel: float = 48.0
#	(A bubble.)
#	 ^ Control bubbles' zoom


#	气泡最大宽度乘数
static var bubble_max_width_multiplier: float = 17.0
#	Bubble's max width (pixels) = this * bubble_unit_pixel
#
#	(A max length bubble.)
#	|<------------------>| <-- THE EXAMPLE MAX WIDTH

#	气泡文本最大宽度乘数
static var bubble_text_max_width_multiplier: float = 16.0
#	Bubble's text max width (pixels) = this * bubble_unit_pixel
#
#	(I'm a bubble.)
#	 |<--------------->| <-- THE EXAMPLE MAX WIDTH
#
#	(I can contain more.)
#	 |<--------------->| <-- THE EXAMPLE MAX WIDTH
#
#	⌈I am too large to  ⌉ <- a two lines bubble
#	⌊must warp words.   ⌋
#	 |<--------------->| <-- THE EXAMPLE MAX WIDTH

#	气泡文本最小宽度乘数TextWidthMin

#	气泡侧向边距长度乘数
static var screen_bubble_border_distance_multiplier: float = 0.025
#	| (A left bubble.)      |
#	|     (A right bubble.) |
#	|-|                   |-|
#	 ^   THESE TWO SPACE   ^
#	one of them = viewport_width * this


#	气泡底部边距长度乘数
static var screen_bubble_bottom_distance_multiplier: float = 0.025
#	|     (A right bubble.) |
#	|                    ]<-|--- THE HEIGHT OF HERE
#	|  ⌈Another right     ⌉ |
#	|  ⌊bubble.           ⌋ | <-- the bubble nearest with viewport bottom
#	|                    ]<-|--- THE HEIGHT OF HERE
#	|-----------------------| <-- viewport bottom


#	工作模式WorkMode
static var work_mode: int = CBS.WORK_MODE_VIDEO
#	Value can be:
#		CBS.WORK_MODE_VIDEO
#			for use via Godot Movie Maker
#		CBS.WORK_MODE_IMAGE
#			for create a static image, run project normally


#	消息列表Messages
static var messages: Array[CBS.MessageStruct] = [
	#CBS.MessageStruct.new(false, "Example left.", 0.0, 1.2),
	#CBS.MessageStruct.new(true, "Example right.", 1.7, 0.0),
	CBS.MessageStruct.new(false, "这真的是我第一次知道这件事", 1.0, 0.0),
	CBS.MessageStruct.new(true, "知道什么事呀", 2.0, 0.0),
	CBS.MessageStruct.new(false, "@小豆老师 Python的for循环会保留迭代的变量，没有作用域", 2.0, 0.0),
	CBS.MessageStruct.new(true, "这个我倒是早就知道了", 2.0, 0.0),
	CBS.MessageStruct.new(false, "从来没试过", 1.5, 0.0),
	CBS.MessageStruct.new(true, "python里面声明变量作用域的好像是global和nonlocal两个关键字吧", 3.0, 0.0),
	CBS.MessageStruct.new(true, "只能在函数里面用？", 1.0, 0.0),
]
#	messages, each element is a message bubble.
#	
#	Instantiate elements like this:
#		CBS.MessageStruct.new(A:bool, B:String, C:float, D:float)
#	A: If true, this bubble send from right side, otherwise left.
#	B: The content of this bubble.
#	C: (Seconds) The waiting time to start this bubble's typing effect. Start timing at last same side bubble sent or project finished to launch. (Only work on Video Mode)
#	D: (Seconds) The time from start typing to send, right side bubbles will skip this. (Only work on Video Mode)
#	
#	An example:
#		static var messages: Array[CBS.MessageStruct] = [
#			CBS.MessageStruct.new(true, "hi dear what are you doing?", 0.0, 4.2),
#			CBS.MessageStruct.new(false, "checking a godot project", 2.0, 6.4),
#			CBS.MessageStrcut.new(true, "what project", 3.4, 1.9),
#			CBS.MessageStruct.new(false, "chat bubble simulator", 2.2, 5.3),
#			CBS.MessageStruct.new(false, "it can simulate chatting apps' ui", 0.5, 8.0),
#			CBS.MessageStruct.new(false, "like us right now", 0.3, 4.5),
#			CBS.MessageStruct.new(true, "WOW COOL", 9.0, 0.7)
#		]


#	自动退出
static var auto_exit: bool = false
#	auto_exit, control project auto exit when simulation finished
