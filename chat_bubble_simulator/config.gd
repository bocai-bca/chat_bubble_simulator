## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name CBSConfig
extends Object

## 选项行号索引Index:
## 自动搜索字体(auto_search_font) = 47
## 气泡字体资源(label_font) = 52
## 时间速率(time_speed) = 57
## 背景颜色(background_color) = 62
## 左气泡配置(left_bubble_config) = 67
## 右气泡配置(right_bubble_config) = 78
## 气泡渲染圆弧顶点数(bubble_mesh_rings) = 89
## 气泡变换缓动曲线值(bubble_transform_ease_curve) = 94
## 气泡淡入时间(bubble_fadein_time) = 100
## 文本开始淡入时间(text_fadein_start_time) = 106
## 文本淡入时间(text_fadein_time) = 112
## 气泡角变换时间(bubble_corner_animation_time) = 118
## 气泡基础像素单位(bubble_unit_pixel) = 124
## 气泡角最小半径(bubble_corner_min_radius) = 131
## 气泡最大宽度乘数(bubble_max_width_multiplier) = 138
## 气泡文本最大宽度乘数(bubble_text_max_width_multiplier) = 147
## 气泡胶囊厚度乘数(bubble_capsule_thickness_multiplier) = 163
## 气泡侧向边距长度乘数(screen_bubble_border_distance_multiplier) = 172
## 气泡底部边距长度乘数(screen_bubble_bottom_distance_multiplier) = 183
## 同侧气泡的纵向间距乘数(screen_same_side_bubbles_distance_multiplier) = 195
## 工作模式(work_mode) = 204
## 气泡超出屏幕后自动删除(auto_free) = 213
## 自动退出(auto_exit) = 219
## 自动退出等待时间(auto_exit_wait_time) = 225
## 是否显示气泡生成时的调试信息(print_bubble_creating_debug) = 231
## 行间距(line_spacing) = 236
## 消息列表(messages) = 241

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


#	气泡渲染圆弧顶点数
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
static var bubble_max_width_multiplier: float = 23.0
#	Default = 17.0
#	Bubble's max width (pixels) = this * bubble_unit_pixel
#
#	(A max length bubble.)
#	|<------------------>| <-- THE EXAMPLE MAX WIDTH


#	气泡文本最大宽度乘数
static var bubble_text_max_width_multiplier: float = 22.0
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
static var work_mode: int = CBS.WORK_MODE_IMAGE
#	Value can be:
#		CBS.WORK_MODE_VIDEO
#			for use via Godot Movie Maker
#		CBS.WORK_MODE_IMAGE
#			for create a static image, run project normally


#	气泡超出屏幕后自动删除(未完成)
static var auto_free: bool = false
#	Free bubble nodes which are out of viewport automatically.
#	Only work on Video Mode.


#	自动退出
static var auto_exit: bool = true
#	Default = true
#	auto_exit, control project auto exit when simulation finished


#	自动退出等待时间
static var auto_exit_wait_time: float = 1.0
#	Default = 1.0
#	auto_exit_wait_time(seconds)


#	是否显示气泡生成时的调试信息
static var print_bubble_creating_debug: bool = false
#	Default = false


#	行间距
static var line_spacing: float = 3.0
#	Default = -6.0


#	消息列表Messages
static var messages: Array[CBS.MessageStruct] = [
	#CBS.MessageStruct.new(false, "Example left.", 0.0, 1.2),
	#CBS.MessageStruct.new(true, "Example right.", 1.7, 0.0),
	CBS.MessageStruct.new(false, "《聊天气泡模拟器》0.2.8", 0.0),
	CBS.MessageStruct.new(true, "来看看更新了什么", 0.0),
	CBS.MessageStruct.new(false, "1.新增图片模式", 0.0),
	CBS.MessageStruct.new(true, "哎~，config.gd里的work_mode选项终于有作用了", 0.0),
	CBS.MessageStruct.new(true, "而且本张图就是这个模式生成的，你可以用它产生聊天记录长图", 0.0),
	CBS.MessageStruct.new(true, "在图片模式中消息列表的时间参数将被无视，而是按照元素在数组中的排序来决定发送顺序", 0.0),
	CBS.MessageStruct.new(false, "不用绞尽脑汁计算相对时间真是人性化多了", 0.0),
	CBS.MessageStruct.new(true, "是啊，现在config.gd里看起来直观多了", 0.0),
	CBS.MessageStruct.new(true, "以后视频模式的消息列表写法或许也会大改", 0.0),
	CBS.MessageStruct.new(false, "让我们来看下一条", 0.0),
	CBS.MessageStruct.new(false, "2.config.gd增加了一个调整行间距的选项", 0.0),
	CBS.MessageStruct.new(true, "不同的字体在CBS中表现出不同纵向长度，唉我目前不知道怎么实现自动设置行间距，所以留了个选项可以让大家自己观察效果手调行间距", 0.0),
	CBS.MessageStruct.new(true, "Godot默认中文字体是-6.0，本张图片使用的苹方字体是3.0，大家可以以此作为参考", 0.0),
	CBS.MessageStruct.new(false, "没了", 0.0),
	CBS.MessageStruct.new(true, "接下来演示一下长图的效果", 0.0),
	CBS.MessageStruct.new(false, "不叫", 0.0),
	CBS.MessageStruct.new(false, "叫地主", 0.0),
	CBS.MessageStruct.new(true, "不抢", 0.0),
	CBS.MessageStruct.new(false, "连对: 554433", 0.0),
	CBS.MessageStruct.new(true, "要不起", 0.0),
	CBS.MessageStruct.new(false, "连对: JJ十十99", 0.0),
	CBS.MessageStruct.new(false, "不要", 0.0),
	CBS.MessageStruct.new(false, "单走: 3", 0.0),
	CBS.MessageStruct.new(false, "单走: 7", 0.0),
	CBS.MessageStruct.new(true, "单走: 8", 0.0),
	CBS.MessageStruct.new(false, "单走: J", 0.0),
	CBS.MessageStruct.new(false, "单走: K", 0.0),
	CBS.MessageStruct.new(true, "要不起", 0.0),
	CBS.MessageStruct.new(false, "要不起", 0.0),
	CBS.MessageStruct.new(false, "飞机: QQQQ十十88", 0.0),
	CBS.MessageStruct.new(true, "炸弹: AAAA", 0.0),
	CBS.MessageStruct.new(false, "要不起", 0.0),
	CBS.MessageStruct.new(false, "不要", 0.0),
	CBS.MessageStruct.new(true, "对子: 44", 0.0),
	CBS.MessageStruct.new(false, "对子: 77", 0.0),
	CBS.MessageStruct.new(false, "王炸: 大王小王", 0.0),
	CBS.MessageStruct.new(true, "要不起", 0.0),
	CBS.MessageStruct.new(false, "要不起", 0.0),
	CBS.MessageStruct.new(false, "对子: 22", 0.0),
	CBS.MessageStruct.new(false, "地主胜利", 0.0),
	CBS.MessageStruct.new(true, "你丫的牌打得也忒好了", 0.0),
	CBS.MessageStruct.new(false, "你丫的牌打得也忒好了", 0.0),
]
#	messages, each element is a message bubble.
#
#	Instantiate elements like this:
#		CBS.MessageStruct.new(A:bool, B:String, C:float)
#	A: If true, this bubble send from right side, otherwise left.
#	B: The content of this bubble.
#	C: (Seconds) The waiting time to start this bubble's typing effect. Start timing at last same side bubble sent or project finished to launch. (Only work on Video Mode)
#
#	An video mode example:
#		static var messages: Array[CBS.MessageStruct] = [
#			CBS.MessageStruct.new(true, "hi dear what are you doing?", 1.0),
#			CBS.MessageStruct.new(false, "checking a godot project", 3.0),
#			CBS.MessageStruct.new(true, "what project", 3.0),
#			CBS.MessageStruct.new(false, "chat bubble simulator", 2.5),
#			CBS.MessageStruct.new(false, "it can simulate chatting apps' ui", 1.0),
#			CBS.MessageStruct.new(false, "like us right now", 0.5),
#			CBS.MessageStruct.new(true, "WOW COOL", 5.0)
#		]
#
#	An image mode example:
#		static var messages: Array[CBS.MessageStruct] = [
#			CBS.MessageStruct.new(false, "Bubble No.1", 0.0),
#			CBS.MessageStruct.new(false, "Bubble No.2", 0.0),
#			CBS.MessageStruct.new(true, "Bubble No.3", 0.0),
#			CBS.MessageStruct.new(true, "Bubble No.4", 0.0),
#			CBS.MessageStruct.new(false, "Bubble No.5", 0.0),
#			CBS.MessageStruct.new(true, "Like you see, time argument is not effective anymore", 0.0)
#		]
