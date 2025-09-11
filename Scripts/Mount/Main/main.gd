# 这是入口节点，用来显示欢迎界面，start后会切换到game场景
extends Node2D

var game_scene_path: String = "res://Scenes/game.tscn"
@export var start_btn: Button

func _ready() -> void:
	# 配置修改提示 ⚠️由于引擎限制该功能并不完善，建议随override.cfg文件一同拷贝到根目录⚠️
	if Init.setting_change_flag:
		$ChangeTips.visible = true
		$StartBtn.visible = false
	else:
		# 居中按钮，这只是一个临时样式。修改样式需要在ready执行，init时还取不到node
		# 放在else下是因为窗口发生改变时会影响大小读取导致位置异常
		Util.node_center($StartBtn)

func _on_go_on_btn_pressed() -> void:
	# 切换可视性
	$ChangeTips.visible = false
	$StartBtn.visible = true

func _on_reset_btn_pressed() -> void:
	get_tree().quit()	# 结束程序

func _on_start_btn_pressed() -> void:
	# 场景转换
	get_tree().call_deferred("change_scene_to_file", game_scene_path)
