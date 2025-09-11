# 渲染地图的TileMapLayer节点脚本父类，封装加载资源和渲染的公共方法
extends TileMapLayer
class_name MapRender

static var tiles: TileSet = TileSet.new()	# 设置为静态可以让所有的渲染图层共享同一个TileSet
static var source_temp: Dictionary = Dictionary()	# ｛source_code: ｛source_id， columns, rows｝｝

func _init() -> void:
	set_tile_set(tiles)	# TileMapLayer节点TileSet属性的setter方法

# 加载资源，子类不需要直接调用该方法，会由draw_tile方法调用，返回source_id
# source_code是资源的文件编号（文件名），加载后会生成source_id，gds不支持声明int|str所以不指定类型（也不支持重载！）
static func load_source(source_code, source_type: String = "png") -> int:
	if source_code is int:
		source_code = str(source_code)
	# 如果缓存中有则直接返回不再加载
	if source_code in source_temp:
		return source_temp[source_code]["source_id"]
	# 加载纹理
	var texture: Resource = Util.dynamic_load_resource(Init.MAP_IMAGE_PATH + source_code + "." + source_type)
	if texture == null:
		printerr("错误: 未读取到map纹理:", source_code)
		return -1
	# 处理纹理底色（将底色视为透明），如果你的资源文件已经处理好了透明则不需要
	texture = Util.transparent_conversion_texture(texture, Color(0, 0, 0))	# 将黑色设为透明
	# 创建新的图块源
	var source_id = tiles.get_next_source_id()
	var tile_map_source = TileSetAtlasSource.new()
	source_temp[source_code] = {"source_id": source_id}	# 缓存信息
	# 设置纹理
	tile_map_source.texture = texture
	var tile_pixel = Init.MAP_TILE_SIZE
	tile_map_source.texture_region_size = Vector2i(tile_pixel, tile_pixel)  # 块大小，要与下一行大小保持一致
	tiles.tile_size = Vector2i(tile_pixel, tile_pixel)
	# 添加到 TileSet
	tiles.add_source(tile_map_source, source_id)
	# 创建多个瓦片
	var texture_size = texture.get_size()
	var columns: int = texture_size.x / tile_pixel
	var rows: int = texture_size.y / tile_pixel
	print("纹理尺寸: ", texture_size, " 瓦片大小: ", tile_pixel)
	source_temp[source_code]["columns"] = columns
	#source_temp[source_code]["rows"] = rows	# 如果在绘制里要检查是否越界则需要rows
	print("可创建瓦片数量: ", columns, " x ", rows)
	for x in range(columns):
		for y in range(rows):
			# 只需要创建瓦片，纹理区域会自动设置
			tile_map_source.create_tile(Vector2i(x, y))
	print("成功创建 ", columns * rows, " 个瓦片，源ID: ", source_id)
	return source_id

# 绘制tile方法，会调用load_source加载资源
# tile_serial为tile块序号，从左至右从上至下，从0开始
func draw_tile(draw_pos_x: int, draw_pos_y: int, source_code, tile_serial: int) -> void:
	if source_code is int:
		source_code = str(source_code)
	var source_id = load_source(source_code)
	var source = tiles.get_source(source_id) as TileSetAtlasSource
	if source:
		# 将序号tile_serial转换成tile坐标，绘制对应tile，这里没有检查是否越界，因为越界不会报错
		var columns = source_temp[source_code]["columns"]
		var tile_pos_y: int = int(tile_serial % columns)
		var tile_pos_x: int = int(tile_serial / columns)
		#print("tile_pos_x:", tile_pos_x, " tile_pos_y:", tile_pos_y)
		var draw_pos = Vector2i(draw_pos_x, draw_pos_y)
		set_cell(draw_pos, source_id, Vector2i(tile_pos_y, tile_pos_x))	# 参数三atlas_coords是Vector2i(水平, 垂直)
	else:
		printerr("错误: 找不到源ID", source_id)
