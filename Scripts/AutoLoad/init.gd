# 这是一个自动加载脚本，本项目并非单例模式，该脚本仅用于初始化和设置一些全局变量
extends Node

# 宏定义，部分数据可以被重定义
# -- 渲染参数 --
static var MAP_TILE_SIZE: int = 32	# 地图tile单个块长宽像素（地图块只能是正方形的）
static var WIDTH_BLOCK: int = 15	# 单屏内宽的块数量（应该为奇数）
static var HEIGHT_BLOCK: int = 11	# 单屏内高的块数量（应该为奇数）
static var CHARACTER_FRAME_SIZE: Vector2 = Vector2(48, 64)	# player单个精灵帧的尺寸
const MAP_IMAGE_PATH = "./Assets/Tile/Map/"	# 地图资源文件的路径
const CHARACTER_IMAGE_PATH = "./Assets/Tile/Player/"	# player资源文件的路径
const DATA_PATH = "./Assets/Data/Json/"	# 导入数据文件，格式为json
# -- 逻辑参数 --
static var MIN_LV: int = 1	# 最小等级
static var MAX_LV: int = 100	# 最大等级
const MAX_CARRY_PM: int = 6	# 最大携带，这个应该是不能改的，至少不能更大了
static var BOX_LIMIT: int = 30	# 箱子总数
static var SINGLE_BOX_LIMIT: int = 40	# 单箱上限
static var SHINE_PERCENT: int = 4096	# 闪光几率
static var SHINE_CUBE_PERCENT: int = 64	# 方块闪，为0则不启用

var transparent_color: Array[Color] = []	# 资源文件需要过滤底色（视为透明）时设置
var setting_change_flag: bool = false

func _init() -> void:
	# TODO:覆盖配置，该配置应该由Config文件夹中读取，现在只是临时写在这里
	# ⚠️⚠️⚠️由于引擎限制该功能并不完善，建议随override.cfg文件一同拷贝到根目录⚠️⚠️⚠️
	transparent_color.append(Color())
	# 根据长宽的块大小和单屏内块数量，设置窗口大小
	var width = MAP_TILE_SIZE * WIDTH_BLOCK
	var height = MAP_TILE_SIZE * HEIGHT_BLOCK
	print("width:", width, " height:", height)
	set_window_size(width, height)

## 修改窗口大小
func set_window_size(width: int, height: int):
	var setting_window_width_path = "display/window/size/viewport_width"
	var setting_window_height_path = "display/window/size/viewport_height"
	if ProjectSettings.get_setting(setting_window_width_path) != width:
		print("窗口宽度发生改变")
		setting_change_flag = true
		ProjectSettings.set_setting(setting_window_width_path, width)
	if ProjectSettings.get_setting(setting_window_height_path) != height:
		print("窗口高度发生改变")
		setting_change_flag = true
		ProjectSettings.set_setting(setting_window_height_path, height)
	ProjectSettings.save()
