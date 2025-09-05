# 这是一个自动加载脚本，本项目并非单例模式，该脚本仅用于初始化和设置一些全局变量
extends Node

const TILE_PIXEL: int = 32
const WIDTH_BLOCK: int = 15
const HEIGHT_BLOCK: int = 11

func _ready() -> void:
	# 根据长宽的块大小和单屏内块数量，设置窗口大小
	set_window_size(TILE_PIXEL * WIDTH_BLOCK, TILE_PIXEL * HEIGHT_BLOCK)

# 修改窗口大小
func set_window_size(width: int, height: int):
	ProjectSettings.set_setting("display/window/size/viewport_width", width)
	ProjectSettings.set_setting("display/window/size/viewport_height", height)
	ProjectSettings.save()
