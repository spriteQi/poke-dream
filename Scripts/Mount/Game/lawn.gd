# 渲染草地节点，继承自MapRender包含一些TileMapLayer动态加载的公共方法
extends MapRender

func draw_layer(r = null) -> void:
	clear()
	for x in range(20):
		for y in range(20):
			draw_tile(x - 10, y - 10, 1, 8)
