# 这是入口节点，用来显示欢迎界面，start后会切换到game场景
extends Node2D

var game_scene_path: String = "res://Scenes/game.tscn"
@export var start_btn: Button

func _ready() -> void:
	# 居中按钮，这只是一个临时样式
	start_btn.position = (Vector2(get_window().size) - start_btn.size) / 2


func _on_button_pressed() -> void:
	# 场景转换
	get_tree().call_deferred("change_scene_to_file", game_scene_path)
