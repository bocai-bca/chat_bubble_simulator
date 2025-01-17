# config.gd 变量作用文档  
注：修改窗口大小请在Godot编辑器中的`项目`>`项目设置`>`显示-窗口`>`大小-视口高度`和`大小-视口宽度`上修改，修改此值将影响气泡在画面上的视觉面积占比体现  
  
常用速览：
- 自动搜索字体(auto_search_font)`bool`：开关自动字体搜寻功能
- 时间速率(time_speed)`float`：调整气泡发送计时和气泡动画播放的速度
- **背景颜色(background_color)`Color`：设置背景颜色**
- **左气泡配置(left_bubble_config)和右气泡配置(right_bubble_config)`CBS.BubbleConfig`：设置气泡和文本的颜色**
- **气泡基础像素单位(bubble_unit_pixel)`float`：气泡渲染的终极核心参数，主要影响了气泡的大小、文本清晰度**
- **消息列表(messages)`Array[CBS.MessageStruct]`：消息列表/聊天记录，设置文本、发送时间、发送方**

## 自动搜索字体(auto_search_font)  
> 类型 = `bool`  
> 默认值 = `true`  

是否自动搜索字体，启用时CBS将在每次启动时从项目的"根目录\fonts"文件夹中搜索可用的字体。  
  
详细细节：  
将在"res://fonts"打开DirAccess，如果该文件夹不存在，将自动创建。  
若存在名为"font.\*"的文件，将优先使用它("\*"部分允许tres、fontdata、ttf)。  
当该文件不存在或不可用时，将使用该文件夹中其他符合后缀名的文件作为字体读取。  


## 气泡字体资源(label_font)  
> 类型 = `Font`(Godot自带类，继承自`Resource`)  
> 默认值 = `null`  

给Label节点指定一个字体资源文件，为null时使用Label节点的默认字体。  
本选项是自动搜索字体功能诞生之前，用于指定自定义字体的方式。现版本，当`auto_search_font`为`true`时，本选项无效。  


## 时间速率(time_speed)  
> 类型 = `float`  
> 默认值 = `1.0`  

影响CBS的动画播放速度和气泡计时速度，该值将作为乘数作用于`delta`上。  
例如该值为`0.5`时，动画的速度将减慢为原本的一半；该值为`2.0`时，动画将于原本两倍速度播放。  


## 背景颜色(background_color)  
> 类型 = `Color`  
> 默认值 = `Color.WHITE`(白色)  

设定画面背景的颜色，需要是一个`Color`类的实例，请参考Godot文档中的`Color`类。  
(注：不建议使用`alpha`不为`1.0`的颜色)  
示例：  
`Color.BLACK`，黑色，作为`Color`类的常量使用；  
`Color("#114514")`，一种深绿，作为`Color`类的接受字符串作为参数的构造函数使用；  
`Color(1.0, 1.0, 0.0)`，黄色，作为`Color`类的接受表达RGB值的浮点数的构造函数使用；  


## 左气泡配置(left_bubble_config)和右气泡配置(right_bubble_config)  
> 类型 = `CBS.BubbleConfig`  
> 左气泡默认值 = `CBS.BubbleConfig.new(Color.LIGHT_GRAY, Color.BLACK)`  
> 右气泡默认值 = `CBS.BubbleConfig.new(Color.DODGER_BLUE, Color.WHITE)`  

用于设定画面两侧气泡的胶囊填充颜色和文字颜色。  
只需要修改`CBS.BubbleConfig`构造函数的两个`Color`参数即可，第一个参数是胶囊填充颜色，第二个参数是文字颜色。  


## 气泡渲染圆弧顶点数(bubble_mesh_rings)  
> 类型 = `int`  
> 默认值 = `16`  

设定用于渲染气泡的`MeshInstance2D`节点的`CapsuleMesh`的`rings`属性，该值将影响气泡胶囊四角的圆润程度，值越高越圆滑，相应带来的性能消耗也将更大。  
在CBS使用原厂气泡占画面比例的配置下，该值(`16`)已经属于较高的值，如有需要请酌情降低以节省性能。另外在使用气泡占画面比例较大的配置下，如果感觉胶囊圆角出现线段状，则应当尝试调高此值。  


## 气泡变换缓动曲线值(bubble_transform_ease_curve)  
> 类型 = `float`  
> 默认值 = `-2.2`  

通常不建议改动此值。设定使影响气泡胶囊形状、坐标变换的淡入动画的缓动曲线的`curve`参数，详情请参考`@GlobalScope`的`ease()`方法。  


## 气泡淡入时间(bubble_fadein_time)  
> 类型 = `float`  
> 默认值 = `0.25`  

只在视频模式(Video Mode)中生效。设定气泡胶囊形状、坐标变换的淡入动画的持续时间，从气泡被发出开始计时。  
单位为秒。  


## 文本开始淡入时间(text_fadein_start_time)  
> 类型 = `float`  
> 默认值 = `0.2`  

只在视频模式(Video Mode)中生效。设定气泡文本淡入动画开始之前的等待时间，从气泡被发出开始计时。  
单位为秒。  


## 文本淡入时间(text_fadein_time)  
> 类型 = `float`  
> 默认值 = `0.07`  

只在视频模式(Video Mode)中生效。设定气泡文本淡入动画的持续时间，从文本淡入动画开始之后计时。  
单位为秒。  


## 气泡角变换时间(bubble_corner_animation_time)  
> 类型 = `float`  
> 默认值 = `0.5`  

只在视频模式(Video Mode)中生效。设定气泡角[¹](#mark_1)的凸出和收起动画持续时间。  
单位为秒。  


## 气泡基础像素单位(bubble_unit_pixel)  
> 类型 = `float`  
> 默认值 = `40.0`  

设定气泡基础单位像素，该值与几乎所有渲染步骤相关。  
调整此值会直接影响文本字体的大小和气泡胶囊形状的大小，如需调整气泡大小，调它就对了。  
此值会与项目设置中的窗口分辨率一同作用气泡于效果画面中的大小占比。  


## 气泡角最小半径(bubble_corner_min_radius)  
> 类型 = `float`  
> 默认值 = `4.0`  

设定气泡角[¹](#mark_1)上的圆形的最小半径，值越小气泡角越锐利。该值为`bubble_unit_pixel`时，气泡角将隐藏。  


## 气泡最大宽度乘数(bubble_max_width_multiplier)  
> 类型 = `float`  
> 默认值 = `17.0`  

设定气泡胶囊形状的最大宽度，以胶囊形状的两个横向顶点测距。建议比`bubble_text_max_width_multiplier`的值大`1.0`。  
算法：气泡胶囊最大宽度(像素数) = 本值 * 气泡基础像素单位  


## 气泡文本最大宽度乘数(bubble_text_max_width_multiplier)  
> 类型 = `float`  
> 默认值 = `16.0`  

设定气泡文本的最大宽度，以`Label`节点的两侧测距。建议比`bubble_max_width_multiplier`的值小`1.0`。  
算法：气泡文本最大宽度(像素数) = 本值 * 气泡基础像素单位  


## 气泡胶囊厚度乘数(bubble_capsule_thickness_multiplier)  
> 类型 = `float`  
> 默认值 = `0.85`  

设定气泡胶囊形状上的每个胶囊形状的半径，通常体现为影响气泡胶囊形状的顶部和底部边缘距离文本的长度。  
算法：胶囊形状半径 = 本值 * 气泡基础像素单位  


## 气泡侧向边距长度乘数(screen_bubble_border_distance_multiplier)  
> 类型 = `float`  
> 默认值 = `0.25`  

设定气泡距离自己所贴靠的一侧的屏幕边缘的距离长度。  
算法：长度 = 本值 * 气泡基础像素单位  


## 气泡底部边距长度乘数(screen_bubble_bottom_distance_multiplier)  
> 类型 = `float`  
> 默认值 = `0.25`  

设定气泡在纵向上与其他气泡和屏幕底部的距离长度。  
算法：长度 = 本值 * 气泡基础像素单位  


## 同侧气泡的纵向间距乘数(screen_same_side_bubbles_distance_multiplier)  
> 类型 = `float`  
> 默认值 = `0.25`  

设定气泡在纵向上与相邻的同侧气泡的距离长度。  
算法：长度 = 本值 * 气泡基础像素单位 * 气泡底部边距长度乘数  


## 工作模式(work_mode)  
> 类型 = `int`  
> 默认值 = 常量`CBS.WORK_MODE_VIDEO`  

设定CBS的工作模式，目前只有视频模式可用。  


## 气泡超出屏幕后自动删除(auto_free)  
> 类型 = `bool`  
> 默认值 = `false`  

未完成的功能，此选项暂时无用。  


## 自动退出(auto_exit)  
> 类型 = `bool`  
> 默认值 = `true`  

当对话播放完毕时自动退出运行，方便于使用MovieMaker时相比于手动退出所带来的误差，自动结束视频更为精准。  


## 自动退出等待时间(auto_exit_wait_time)  
> 类型 = `float`  
> 默认值 = `1.0`  

设定自动退出前等待的时间，从最后一个气泡完成淡入动画后开始计时。  
单位为秒。  


## 显示气泡生成调试信息(print_bubble_creating_debug)  
> 类型 = `bool`  
> 默认值 = `false`  

显示气泡构造时的一些调试信息，对普通使用者来说没什么用。  


## 消息列表(messages)  
> 类型 = `Array[CBS.MessageStruct]`  
> 默认值 = 无

定义聊天记录，每个元素代表一个气泡，包含文本、发送时间、发送方。  
`CBS.MessageStruct`类的代码参考：  
```
class MessageStruct:
	var content: String
	var sender: bool
	var waiting_time: float
	func _init(__send_from_right: bool, __content: String, __waiting_time: float) -> void:
		sender = __send_from_right
		content = __content
		waiting_time = __waiting_time
```

每个`CBS.MessageStruct`的构造方法简要概括：  
`CBS.MessageStruct.new(是否发送自右侧:bool, 文本:String, 发送延时:float)`  
在"是否发送自右侧"处填写`true`或`false`，`true`表示右侧，`false`表示左侧。  
"文本"是该气泡的文本，建议使用转义符`\n`或`\r`表示换行，使用转义符`\\`表示符号`\`，使用转义符`\"`表示引号......以此类推，详情请参考Godot文档以了解哪些符号需要在双引号字符串中进行转义。  
CBS中包含两个各自独立的计时器，分别为左侧和右侧气泡计时，每个计时器在己方气泡发出时会重置为0。因此，在编写消息列表时，在"发送延时"处填写该气泡距离同一侧的上一个气泡发出后的时间间隔。例如，想要编写一条第1秒发出的消息A和一条第3秒发出的消息B，那么A所需填写的时间为1.0，B所需填写的时间为2.0(即3-1=2)，如果再要加一条于第6秒发出的消息C，那么需要填写时间为3.0(6-3=3)。  

示例：  
```
CBS.MessageStruct.new(false,"第一条左气泡于0.0秒时发出",0.0),
CBS.MessageStruct.new(true,"第一条右气泡于0.0秒发出",0.0),
CBS.MessageStruct.new(false,"第二条左气泡于2.0秒时发出",2.0),
CBS.MessageStruct.new(true,"第二条右气泡于1.0秒发出",1.0),
CBS.MessageStruct.new(true,"第三条右气泡于1.5秒发出",0.5),
CBS.MessageStruct.new(false,"第三条左气泡于5.0秒时发出",3.0)
```
  

## 
<a name="mark_1"></a>1(气泡角)：气泡模拟从发送一侧拖曳到气泡上的箭头的直角，位于气泡自身贴靠一侧的下方角落。若该气泡的下方紧挨同侧气泡时，该气泡的气泡角将隐藏。  
