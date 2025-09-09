# 渲染底板节点，继承自MapRender包含一些TileMapLayer动态加载的公共方法
extends MapRender

func draw_layer(test: String) -> void:
	print(test)
	clear()
	#for x in range(8):
		#for y in range(32):
			#draw_tile(x, y, 1, y * 8 + x)
			#draw_tile(x + 8, y, 2, y * 8 + x)
	draw_tile(0, 0, 1, 0)
