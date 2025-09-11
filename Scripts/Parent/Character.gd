# 渲染player的AnimatedSprite2D节点对象父类，通过sprites数组共享给所有动态创建的player使用
extends AnimatedSprite2D
class_name Character

static var sprites_temp: Dictionary = Dictionary()	# ｛source_code: SpriteFrames｝
enum Direction { UP, RIGHT, DOWN, LEFT }

func _init() -> void:
	set_offset(Vector2(Init.MAP_TILE_SIZE / 2.0, 0))	# 偏移对齐tile

# 加载资源，会返回一个SpriteFrames，可以复用
# 继承该方法的类实例化后直接set_sprite_frames(load_source())初始化或改变主题
static func load_source(source_code, source_type: String = "png") -> SpriteFrames:
	if source_code is int:	# 相当于重载
		source_code = str(source_code)
	# 已经加载过的资源直接返回缓存
	if source_code in sprites_temp:
		return sprites_temp[source_code]
	var sprites = SpriteFrames.new()
	var texture: Resource = Util.dynamic_load_resource(Init.CHARACTER_IMAGE_PATH + source_code + "." + source_type)
	if texture == null:
		printerr("错误: 未读取到character纹理:", source_code)
		return
	var frame_size = Init.CHARACTER_FRAME_SIZE
	var columns = texture.get_width() / frame_size.x
	var rows = texture.get_height() / frame_size.y
	for y in range(rows):
		var dir_name = str(Direction.keys()[y])	# animation只能接受str类型的名称所以要转换
		sprites.add_animation(dir_name)	# 添加animation（相当于分组）
		for x in range(columns):
			var region = Rect2(x * frame_size.x, y * frame_size.y, frame_size.x, frame_size.y)
			var atlas = AtlasTexture.new()
			# 处理纹理底色（将底色视为透明），如果你的资源文件已经处理好了透明则不需要
			if not Init.transparent_color.is_empty():
				texture = Util.transparent_conversion_texture(texture, Init.transparent_color)	# 将黑色设为透明	# 将黑色设为透明
			atlas.atlas = texture
			atlas.region = region
			sprites.add_frame(dir_name, atlas, 0.5)	# 对该组中添加帧
	sprites_temp[source_code] = sprites
	return sprites

# 设置角色的实际坐标左上角是(0, 0)
func set_character_pos(pos_x, pos_y) -> void:
	position = Vector2(pos_x * Init.MAP_TILE_SIZE, pos_y * Init.MAP_TILE_SIZE)
	return
