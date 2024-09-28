## Copyright (C) 2024 BCASoft. Open source with MIT License.
class_name TypingBubble
extends CanvasGroup

const ClassPackedScene: PackedScene = preload("res://typing_bubble.tscn")

var display: bool = false #控制输入泡是否显示
var _effect_timer: float = 0.0 #圆点效果计时器


@onready var n_capsule: MeshInstance2D = get_node("Capsule") as MeshInstance2D
@onready var n_sphere_left: MeshInstance2D = get_node("SphereLeft") as MeshInstance2D
@onready var n_sphere_middle: MeshInstance2D = get_node("SphereMiddle") as MeshInstance2D
@onready var n_sphere_right: MeshInstance2D = get_node("SphereRight") as MeshInstance2D
