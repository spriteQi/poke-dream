# 渲染草地节点，继承自MapRender包含一些TileMapLayer动态加载的公共方法
extends MapRender

func init(test: String) -> void:
	print(test)
	clear()
	draw_tile(Vector2(0,0),1,1)
	#var tiles: TileSet = TileSet.new()
	#var source_id = load_source(1)
	#if source_id >= 0:
		#set_tile_set(tiles)
		#set_tile_set(tiles)
		## 填充地图
		#fill_map_with_tiles(source_id)
	#else:
		#pass	# TODO:UI显示错误提示

func fill_map_with_tiles(source_id: int):
	# 清除当前图层
	clear()
	# 获取源信息以确定有多少瓦片可用
	var source = tile_set.get_source(source_id) as TileSetAtlasSource
	if source:
		var texture_size = source.texture.get_size()
		var tile_size = source.texture_region_size
		var tiles_x: int = texture_size.x / tile_size.x
		var tiles_y: int = texture_size.y / tile_size.y
		print("填充地图，可用瓦片: ", tiles_x, " x ", tiles_y)
		# 填充地图
		for x in range(tiles_x):
			for y in range(tiles_y):
				set_cell(Vector2i(x, y), source_id, Vector2i(x % tiles_x, y % tiles_y))
	else:
		printerr("错误: 找不到源ID", source_id)
