# 这是game场景的根节点
extends Node2D

signal init_floor
#signal init_lawn
#signal init_build

func _ready() -> void:
	init_floor.connect($Floor.draw_layer)
	init_floor.connect($Lawn.draw_layer)
	init_floor.emit("-")
	
	
