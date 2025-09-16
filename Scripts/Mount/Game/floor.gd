# 渲染底板节点,该层不参与碰撞，继承自MapRender，渲染顺序在最下层
extends MapRender

func draw_layer(r = null) -> void:
	clear()
	for x in range(20):
		for y in range(20):
			draw_tile(x - 10, y - 10, 1, 0)
