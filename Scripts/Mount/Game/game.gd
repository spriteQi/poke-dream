# 这是game场景的根节点
extends Node2D

signal load_map

func _ready() -> void:
	load_map.connect($Floor.draw_layer)
	load_map.connect($Lawn.draw_layer)
	load_map.emit()
	
	
