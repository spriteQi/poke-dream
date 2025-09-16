# 渲染草地层节点，也包括树等组件，继承自MapRender，渲染顺序在floor之上，build之下
extends MapRender

func draw_layer(r = null) -> void:
	clear()
	for x in range(20):
		for y in range(20):
			draw_tile(x - 10, y - 10, 1, 8)
