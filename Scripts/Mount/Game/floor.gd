extends TileMapLayer

func init(test: String) -> void:
	print(test)
	var tiles: TileSet = TileSet.new()
	var source_id = add_source(tiles, "res://Assets/Tile/Map/1.png")
	set_tile_set(tiles)
	# 填充地图
	fill_map_with_tiles(source_id)

func add_source(tiles: TileSet, image_path: String):
	# 加载纹理
	var texture: Resource = load(image_path)
	if texture == null:
		print("错误: 无法加载纹理 ", image_path)
		return
	# 创建新的图块源
	var source_id = tiles.get_next_source_id()
	var tile_map_source = TileSetAtlasSource.new()
	# 设置纹理
	tile_map_source.texture = texture
	var tile_pixel = Init.TILE_PIXEL
	tile_map_source.texture_region_size = Vector2i(tile_pixel, tile_pixel)  # TileSet
	tiles.tile_size = Vector2i(tile_pixel, tile_pixel)
	# 添加到 TileSet
	tiles.add_source(tile_map_source, source_id)
	# 创建多个瓦片
	var texture_size = texture.get_size()
	var tiles_x: int = texture_size.x / tile_pixel
	var tiles_y: int = texture_size.y / tile_pixel
	print("纹理尺寸: ", texture_size, " 瓦片大小: ", tile_pixel)
	print("可创建瓦片数量: ", tiles_x, " x ", tiles_y)
	for x in range(tiles_x):
		for y in range(tiles_y):
			# 只需要创建瓦片，纹理区域会自动设置
			tile_map_source.create_tile(Vector2i(x, y))
	print("成功创建 ", tiles_x * tiles_y, " 个瓦片，源ID: ", source_id)
	return source_id

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
				set_cell(Vector2i(x, y), source_id, Vector2i(x % 4, 0))
	else:
		print("错误: 找不到源ID ", source_id)
