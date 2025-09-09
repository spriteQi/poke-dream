# 渲染地图的TileMapLayer脚本父类，封装加载资源和渲染的公共方法
extends TileMapLayer
class_name MapRender

static var tiles: TileSet = TileSet.new()	# 设置为静态可以让所有的渲染图层共享同一个TileSet
static var source_temp = Dictionary()	# ｛source_code: ｛source_id， x_len, y_len｝"｝

func _init() -> void:
	set_tile_set(tiles)	# TileMapLayer节点TileSet属性的setter方法

# 加载资源，子类不需要直接调用该方法，会由draw_tile方法调用
# source_code是资源的文件编号（文件名），加载后会生成source_id
func load_source(source_code: int, source_type: String = "png") -> int:
	# 如果缓存中有则直接返回不再加载
	if source_code in source_temp:
		return source_temp[source_code]["source_id"]
	# 加载纹理
	var texture: Resource = load(Init.MAP_IMAGE_PATH + str(source_code) + "." + source_type)
	if texture == null:
		printerr("错误: 未读取到纹理:", source_code)
		return -1
	# 处理纹理底色（将底色视为透明），如果你的资源文件已经处理好了透明则不需要
	var image: Image = texture.get_image()
	Util.transparent_conversion(image, Color(0, 0, 0))	# 将黑色设为透明
	texture = ImageTexture.create_from_image(image)
	# 创建新的图块源
	var source_id = tiles.get_next_source_id()
	var tile_map_source = TileSetAtlasSource.new()
	source_temp[source_code] = {"source_id": source_id}	# 缓存信息
	# 设置纹理
	tile_map_source.texture = texture
	var tile_pixel = Init.MAP_TILE_PIXEL
	tile_map_source.texture_region_size = Vector2i(tile_pixel, tile_pixel)  # 块大小，要与下一行大小保持一致
	tiles.tile_size = Vector2i(tile_pixel, tile_pixel)
	# 添加到 TileSet
	tiles.add_source(tile_map_source, source_id)
	# 创建多个瓦片
	var texture_size = texture.get_size()
	var tiles_x: int = texture_size.x / tile_pixel
	var tiles_y: int = texture_size.y / tile_pixel
	print("纹理尺寸: ", texture_size, " 瓦片大小: ", tile_pixel)
	source_temp[source_code]["x_len"] = tiles_x
	#source_temp[source_code]["y_len"] = tiles_y	# 如果在绘制里要检查是否越界则需要y_len
	print("可创建瓦片数量: ", tiles_x, " x ", tiles_y)
	for x in range(tiles_x):
		for y in range(tiles_y):
			# 只需要创建瓦片，纹理区域会自动设置
			tile_map_source.create_tile(Vector2i(x, y))
	print("成功创建 ", tiles_x * tiles_y, " 个瓦片，源ID: ", source_id)
	return source_id

# 绘制tile方法，会调用load_source加载资源
# tile_serial为tile块序号，从左至右从上至下，从0开始
func draw_tile(draw_pos_x: int, draw_pos_y: int, source_code: int, tile_serial: int) -> void:
	var source_id = load_source(source_code)
	var source = tiles.get_source(source_id) as TileSetAtlasSource
	if source:
		# 绘制对应tile，这里没有检查是否越界，因为越界不会报错
		var x_len = source_temp[source_code]["x_len"]
		var tile_pos_y: int = int(tile_serial % x_len)
		var tile_pos_x: int = int(tile_serial / x_len)
		#print("tile_pos_x:", tile_pos_x, " tile_pos_y:", tile_pos_y)
		var draw_pos = Vector2i(draw_pos_x, draw_pos_y)
		set_cell(draw_pos, source_id, Vector2i(tile_pos_y, tile_pos_x))	# 参数三atlas_coords是Vector2i(水平, 垂直)
	else:
		printerr("错误: 找不到源ID", source_id)
