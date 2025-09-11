# 这是game场景的根节点
extends Node2D

signal reload_map

func _ready() -> void:
	reload_map.connect($Floor.draw_layer)
	reload_map.connect($Lawn.draw_layer)
	reload_map.emit()
	
	
