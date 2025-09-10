# 这是一个自动加载脚本，本项目并非单例模式，该脚本仅用于初始化和设置一些全局变量
extends Node

const MAP_TILE_SIZE: int = 32	# 地图tile单个块长宽像素（地图块只能是正方形的）
const WIDTH_BLOCK: int = 15	# 单屏内宽的块数量（应该为奇数）
const HEIGHT_BLOCK: int = 11	# 单屏内高的块数量（应该为奇数）
const MAP_IMAGE_PATH = "res://Assets/Tile/Map/"	# 地图资源文件的路径
const CHARACTER_IMAGE_PATH = "res://Assets/Tile/Player/"	# player资源文件的路径
const CHARACTER_FRAME_SIZE: Vector2 = Vector2(48, 64)	# player单个精灵帧的尺寸


func _ready() -> void:
	# 根据长宽的块大小和单屏内块数量，设置窗口大小
	set_window_size(MAP_TILE_SIZE * WIDTH_BLOCK, MAP_TILE_SIZE * HEIGHT_BLOCK)

# 修改窗口大小
func set_window_size(width: int, height: int):
	ProjectSettings.set_setting("display/window/size/viewport_width", width)
	ProjectSettings.set_setting("display/window/size/viewport_height", height)
	ProjectSettings.save()
