## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBSConfig
extends Object

## You can only modify below ##
##     |      |      |       ##
##     |      |      |       ##
##     |      |      |       ##
##     V      V      V       ##

#	These default values are adapt to Viewport size (1080, 1080)


#	是否自动搜索字体，启用时CBS将在每次启动时从项目的"根目录\fonts"文件夹中搜索可用的字体
#	详细细节：
#		将在"res://fonts"打开DirAccess，如果该文件夹不存在，将自动创建
#		若存在名为"font.*"的文件，将优先使用它("*"部分允许tres、fontdata、ttf)
#		当该文件不存在或不可用时，将使用该文件夹中其他符合后缀名的文件作为字体读取
static var auto_search_font: bool = true
#	Default = true


#	气泡字体资源，为null时使用Label节点的默认字体
static var label_font: Font = null
#	Default = null


#	时间速率TimeSpeed
static var time_speed: float = 1.0
#	Default = 1.0


#	背景颜色
static var background_color: Color = Color.WHITE
#	Default = Color.WHITE


#	左侧气泡的配置
static var left_bubble_config: CBS.BubbleConfig = CBS.BubbleConfig.new(
	Color.LIGHT_GRAY, # <--- fill color
	Color.BLACK # <--- text color
)
#	Default = CBS.BubbleConfig.new(
#	Color.LIGHT_GRAY, # <--- fill color
#	Color.BLACK # <--- text color
#)


#	右侧气泡的配置
static var right_bubble_config: CBS.BubbleConfig = CBS.BubbleConfig.new(
	Color.DODGER_BLUE, # <--- fill color
	Color.WHITE # <--- text color
)
#	Default = CBS.BubbleConfig.new(
#	Color.DODGER_BLUE, # <--- fill color
#	Color.WHITE # <--- text color
#)


#	气泡渲染的圆弧线段数
static var bubble_mesh_rings: int = 16
#	bubble_mesh_rings, be used at the attribute mesh.rings of MeshInstance2D of each bubble.


#	气泡变换缓动曲线值
static var bubble_transform_ease_curve: float = -2.2
#	bubble_transform_ease_curve
#	ease(x, this)


#	气泡淡入时间
static var bubble_fadein_time: float = 0.25
#	bubble_fadein_time(seconds), bubbles fade-in animation time.
#	Only work on Video Mode.


#	文本开始淡入时间
static var text_fadein_start_time: float = 0.2
#	text_fadein_start_time(seconds).
#	Only work on Video Mode.


#	文本淡入时间
static var text_fadein_time: float = 0.07
#	text_fadein_time(seconds).
#	Only work on Video Mode.


#	气泡角变换时间
static var bubble_corner_animation_time: float = 0.5
#	bubble_corner_animation_time(seconds).
#	Only work on Video Mode.


#	气泡基础像素单位UnitPixel
static var bubble_unit_pixel: float = 40.0
#	Default = 40.0
#	(A bubble.)
#	 ^ Control bubbles' zoom


#	气泡角最小半径CornerRadius
static var bubble_corner_min_radius: float = 4.0
#	L A bubble.)
#	^ Control bubbles' corner's radius
#	Standalone to bubble_unit_pixel, cannot larger than bubble_unit_pixel


#	气泡最大宽度乘数
static var bubble_max_width_multiplier: float = 17.0
#	Default = 17.0
#	Bubble's max width (pixels) = this * bubble_unit_pixel
#
#	(A max length bubble.)
#	|<------------------>| <-- THE EXAMPLE MAX WIDTH


#	气泡文本最大宽度乘数
static var bubble_text_max_width_multiplier: float = 16.0
#	Default = 16.0
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


#	气泡胶囊厚度乘数
static var bubble_capsule_thickness_multiplier: float = 0.85
#	Default = 0.85
#	The width of empty areas where between text and bubbles' bound (pixels) = this * bubble_unit_pixel
#
#	⌈              ⌉ <--- THIS AREA
#	| I'm a bubble |
#	⌊              ⌋ <--- THIS AREA

#	气泡侧向边距长度乘数
static var screen_bubble_border_distance_multiplier: float = 0.25
#	the distance = this * bubble_unit_pixel
#
#	| (A left bubble.)      |
#	|     (A right bubble.) |
#	|-|                   |-|
#	 ^   THESE TWO SPACE   ^
#	one of them = viewport_width * this


#	气泡底部边距长度乘数
static var screen_bubble_bottom_distance_multiplier: float = 0.25
#	the distance = this * bubble_unit_pixel
#
#	|     (A right bubble.) |
#	|                    ]<-|--- THE HEIGHT OF HERE
#	|  ⌈Another right     ⌉ |
#	|  ⌊bubble.           ⌋ | <-- the bubble nearest with viewport bottom
#	|                    ]<-|--- THE HEIGHT OF HERE
#	|-----------------------| <-- viewport bottom


#	同侧气泡的纵向间距乘数
static var screen_same_side_bubbles_distance_multiplier: float = 0.25
#	the distance = this * bubble_unit_pixel * screen_bubble_bottom_distance_multiplier
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
	CBS.MessageStruct.new(false, "欢迎来到《聊天气泡模拟器》", 1.0),
	CBS.MessageStruct.new(false, "这是一个GodotEngine 4.3项目", 0.5),
	CBS.MessageStruct.new(false, "本视频将带你一览本项目的效果和玩法", 0.5),
	
	CBS.MessageStruct.new(true, "我准备好了", 3.5),
]
#	messages, each element is a message bubble.
#
#	Instantiate elements like this:
#		CBS.MessageStruct.new(A:bool, B:String, C:float)
#	A: If true, this bubble send from right side, otherwise left.
#	B: The content of this bubble.
#	C: (Seconds) The waiting time to start this bubble's typing effect. Start timing at last same side bubble sent or project finished to launch. (Only work on Video Mode)
#
#	An example:
#		static var messages: Array[CBS.MessageStruct] = [
#			CBS.MessageStruct.new(true, "hi dear what are you doing?", 1.0),
#			CBS.MessageStruct.new(false, "checking a godot project", 3.0),
#			CBS.MessageStruct.new(true, "what project", 3.0),
#			CBS.MessageStruct.new(false, "chat bubble simulator", 2.5),
#			CBS.MessageStruct.new(false, "it can simulate chatting apps' ui", 1.0),
#			CBS.MessageStruct.new(false, "like us right now", 0.5),
#			CBS.MessageStruct.new(true, "WOW COOL", 5.0)
#		]


#	气泡超出屏幕后自动删除(未完成)
static var auto_free: bool = false
#	Free bubble nodes which are out of viewport automatically.
#	Only work on Video Mode.


#	自动退出
static var auto_exit: bool = false
#	Default = true
#	auto_exit, control project auto exit when simulation finished


#	自动退出等待时间
static var auto_exit_wait_time: float = 1.0
#	Default = 1.0
#	auto_exit_wait_time(seconds)


#	是否显示气泡生成时的调试信息
static var print_bubble_creating_debug: bool = false
#	Default = false
