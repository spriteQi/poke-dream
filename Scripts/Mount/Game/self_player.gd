# 玩家自身类，继承自Character类，一些通用方法（NPC也适用的）属性方法写在父类里了
extends Character

enum PlayerState { stand, move, turn, fake_move }	# fake_move是撞墙表现，有
var state: PlayerState	# 角色当前状态，用以控制在某些情况下，不响应移动事件

func _ready() -> void:
	set_character_pos(0, 0)
	set_sprite_frames(load_source(0))
	set_character_dir("RIGHT")
	set_frame(1)
	state = PlayerState.stand

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	# 接收处理角色移动事件
	if is_enable_move():
		for d in Direction.keys():
			if Input.is_action_pressed(d):
				try_move(d)
				break  # 执行一个方向后退出，避免冲突
	return

## 角色尝试移动
func try_move(d: StringName) -> void:
	if Direction.get(d) == dir:	# 移动方向与当前面向相同，尝试移动一格（前提是前一格是可达位置）
		var target_pos: Vector2
		match Direction.get(d):
			Direction.UP: target_pos = pos + Vector2i(0, -1)
			Direction.RIGHT: target_pos = pos + Vector2i(1, 0)
			Direction.DOWN: target_pos = pos + Vector2i(0, 1)
			Direction.LEFT: target_pos = pos + Vector2i(-1, 0)
		print("pos:", pos, " target_pos:", target_pos / Init.MAP_TILE_SIZE)
		if true:	# TODO:判断target_pos地块可移动性
			state = PlayerState.move	# 修改状态，锁定输入
			var tween_move = create_tween()
			var duration = 0.25 / speed
			tween_move.tween_callback(show_move)	# 伸出脚
			tween_move.tween_method(move_show_end, 0.0, 1.0, duration)	# 回调结束表现
			tween_move.parallel().tween_property(self, "position", pos_to_position(target_pos), duration)	# 移动补间动画
			tween_move.finished.connect(func():	# 倒计时结束回调
				state = PlayerState.stand	# 解锁输入
				print("pos:", position / Init.MAP_TILE_SIZE)
		)
		else:	# TODO:不可通行，只播放移动帧，不移动，不锁定，接受输入（非同向）会立刻打断
			pass
	else:	# 尝试移动方向与当前面向不相同，执行转向
		state = PlayerState.turn	# 修改状态，锁定输入
		var tween_turn = create_tween()
		tween_turn.tween_callback(show_move)
		tween_turn.tween_property(self, "flip_h", false, 0.08 / speed)	# 修改属性无意义纯当计时用
		tween_turn.finished.connect(func():	# 倒计时结束回调
			set_character_dir(d)	# 执行转向
			state = PlayerState.stand	# 解锁输入
			frame=1	# 复位动作表现
		)

## 检测是否是可接受移动输入
func is_enable_move() -> bool:
	if state == PlayerState.stand or state == PlayerState.fake_move:
		return true
	else:
		return false
