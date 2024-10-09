## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBSConfig
extends Object

## You can only modify below ##
##     |      |      |       ##
##     |      |      |       ##
##     |      |      |       ##
##     V      V      V       ##

#	时间速率TimeSpeed
static var time_speed: float = 0.75
#

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


#	气泡变换缓动曲线值
static var bubble_transform_ease_curve: float = -2.2
#	bubble_transform_ease_curve
#	ease(x, this)


#	气泡淡入时间
static var bubble_fadein_time: float = 0.2
#	bubble_fadein_time(seconds), bubbles fade-in animation time.
#	Only work on Video Mode.


#	文本开始淡入时间
static var text_fadein_start_time: float = 0.15
#	text_fadein_start_time(seconds).
#	Only work on Video Mode.


#	文本淡入时间
static var text_fadein_time: float = 0.05
#	text_fadein_time(seconds).
#	Only work on Video Mode.


#	气泡角变换时间
static var bubble_corner_animation_time: float = 0.4
#	bubble_corner_animation_time(seconds).
#	Only work on Video Mode.


#	气泡基础像素单位UnitPixel
static var bubble_unit_pixel: float = 48.0
#	(A bubble.)
#	 ^ Control bubbles' zoom


#	气泡角最小半径CornerRadius
static var bubble_corner_min_radius: float = 4.0
#	L A bubble.)
#	^ Control bubbles' corner's radius
#	Standalone to bubble_unit_pixel, cannot larger than bubble_unit_pixel


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


#	气泡输入宽度乘数TypingWidth
#static var bubble_typing_width_multiplier: float = 4.0 / 3.0


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


#	同侧气泡的纵向间距乘数
static var screen_same_side_bubbles_distance_multiplier: float = 0.2
#	the distance = this * screen_bubble_bottom_distance_multiplier * viewport_height
#	0.0 - 1.0
#
#	|     (A right bubble.) |
#	|                    ]<-|--- THE HEIGHT OF HERE
#	|     (A right bubble.) |


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
	CBS.MessageStruct.new(true, "hi dear what are you doing?", 1.0, 0.0),
	CBS.MessageStruct.new(false, "checking a godot project", 3.0, 0.0),
	CBS.MessageStruct.new(true, "what project", 3.0, 0.0),
	CBS.MessageStruct.new(false, "chat bubble simulator", 2.5, 0.0),
	CBS.MessageStruct.new(false, "it can simulate chatting apps' ui", 2.0, 0.0),
	CBS.MessageStruct.new(false, "like us right now", 1.5, 0.0),
	CBS.MessageStruct.new(true, "WOW COOL", 7.0, 0.0)
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
#			CBS.MessageStruct.new(true, "hi dear what are you doing?", 1.0, 0.0),
#			CBS.MessageStruct.new(false, "checking a godot project", 3.0, 0.0),
#			CBS.MessageStruct.new(true, "what project", 3.0, 0.0),
#			CBS.MessageStruct.new(false, "chat bubble simulator", 2.5, 0.0),
#			CBS.MessageStruct.new(false, "it can simulate chatting apps' ui", 1.0, 0.0),
#			CBS.MessageStruct.new(false, "like us right now", 0.5, 0.0),
#			CBS.MessageStruct.new(true, "WOW COOL", 5.0, 0.0)
#		]


#	气泡超出屏幕后自动删除
static var auto_free: bool = false
#	Free bubble nodes which are out of viewport automatically.
#	Only work on Video Mode.


#	自动退出
static var auto_exit: bool = false
#	auto_exit, control project auto exit when simulation finished
