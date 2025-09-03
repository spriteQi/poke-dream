extends Node

var tile_pixel: int = 32
var width_block: int = 15
var height_block: int = 11

func _ready() -> void:
	set_window_size(tile_pixel * width_block, tile_pixel * height_block)

# 修改窗口大小
func set_window_size(width: int, height: int):
	# 动态更新窗口代销
	ProjectSettings.set_setting("display/window/size/viewport_width", width)
	ProjectSettings.set_setting("display/window/size/viewport_height", height)
	ProjectSettings.save()
