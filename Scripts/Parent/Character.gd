# 渲染player的AnimatedSprite2D节点对象父类，通过sprites数组共享给所有动态创建的player使用
@abstract
class_name Character extends AnimatedSprite2D

static var sprites_temp: Dictionary = Dictionary()	# ｛source_code: SpriteFrames｝
enum Direction { UP, RIGHT, DOWN, LEFT }
var pos: Vector2i = Vector2i.ZERO	# 逻辑坐标，不同于self.position是渲染坐标
var dir: Direction = Direction.DOWN	# 面向
var speed: float = 1.0	# 速度倍率
var move_step: bool	# 在两个动作帧（0、2）之间切换，不一定完全还原了原作表现
var move_counter: int = 0	# 移动计数器，用来序列化移动id，当一个移动执行中如果改变了该值则直接终止当前move

func _init() -> void:
	set_offset(Vector2(0, -Init.MAP_TILE_SIZE / 2.0))	# 偏移对齐窗口

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

## 设置角色的实际坐标左上角是(0, 0)，X轴朝→增大，Y轴朝↓增大，一般只有初始化一个角色才会使用
func set_character_pos(pos_x: int, pos_y: int) -> void:
	pos = Vector2i(pos_x, pos_y)
	position = pos_to_position(pos)
	return

## 逻辑坐标pos转换渲染坐标position
static func pos_to_position(pos_: Vector2i) -> Vector2:
	var position_: Vector2 = Vector2(pos_.x * Init.MAP_TILE_SIZE, pos_.y * Init.MAP_TILE_SIZE)
	return position_

## 设置角色面向，自己一般是初始化才会直接调用，因为是直接改变没有动作，其他个体没有限制
func set_character_dir(d: StringName) -> void:
	dir = Direction.get(d)
	set_animation(d)
	set_frame(1)	# 切换了面向需要重新定位到帧（1是站立）

## 非自身角色移动，并不保证current_pos是当前位置（异常时会瞬移），也不保证target_pos相邻
func character_move(current_pos: Vector2i, target_pos: Vector2i, d: StringName = "") -> void:
	move_counter += 1
	var tween_id: int = move_counter	# 序列化
	set_character_pos(current_pos.x, current_pos.y)
	if d != "":
		set_character_dir(d)
	var tween_move = create_tween()
	var duration = 0.25 / speed	# 基础速度1秒4格
	tween_move.tween_callback(show_move)	# 伸出脚
	tween_move.tween_method(move_conflict_check.bind(tween_move, tween_id), 0.0, 1.0, duration)
	tween_move.parallel().tween_method(move_show_end, 0.0, 1.0, duration)	# 回调某个进度表现为stand
	tween_move.parallel().tween_property(self, "position", pos_to_position(target_pos), duration)	# 移动补间动画

## 将frame切换至移动状态表现，并且置反move_step
func show_move() -> void:
	if move_step:
		frame = 0
	else:
		frame = 2
	move_step = !move_step

## 复原stand的表现，会比动作结束时机早
func move_show_end(progress: float) -> void:
	if progress >= 0.6 and frame != 1:
		frame = 1

## 每帧回调检查是否产生新的move，如有则停止终止move
@warning_ignore("unused_parameter")
func move_conflict_check(progress: float, tween: Tween, tween_id: int) -> void:
	if tween_id != move_counter:
		tween.kill()
