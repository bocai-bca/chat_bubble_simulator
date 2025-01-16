# config.gd 变量作用文档  


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


## 文本开始淡入时间(text_fadein_start_time)  
> 类型 = `float`  
> 默认值 = `0.2`  

只在视频模式(Video Mode)中生效。设定气泡文本淡入动画开始之前的等待时间，从气泡被发出开始计时。  


## 文本淡入时间(text_fadein_time)  
> 类型 = `float`  
> 默认值 = `0.07`  

只在视频模式(Video Mode)中生效。设定气泡文本淡入动画的持续时间，从文本淡入动画开始之后计时。  


## 气泡角变换时间(bubble_corner_animation_time)  
> 类型 = `float`  
> 默认值 = `0.5`  

只在视频模式(Video Mode)中生效。设定气泡模拟发送拖曳箭头的直角的凸出和收起动画持续时间。  


## 气泡基础像素单位(bubble_unit_pixel)   
> 类型 = `float`  
> 默认值 = `40.0`  

设定气泡基础单位像素，该值与几乎所有渲染步骤相关。  
调整此值会直接影响文本字体的大小和气泡胶囊形状的大小，如需调整气泡大小，调它就对了。  
此值会与项目设置中的窗口分辨率一同作用气泡于效果画面中的大小占比。  



# 更多的在施工中🛠️
