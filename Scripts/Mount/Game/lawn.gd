# 渲染草地节点，继承自MapRender包含一些TileMapLayer动态加载的公共方法
extends MapRender

func draw_layer(r = null) -> void:
	clear()
	for x in range(10):
		for y in range(10):
			draw_tile(x, y, 1, 8)
