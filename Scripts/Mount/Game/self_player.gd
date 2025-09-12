extends Character

enum PlayerStatus { stand, move, turn, fake_move }
var status: PlayerStatus	# 角色当前状态，用以控制在某些情况下，不响应移动事件

func _ready() -> void:
	set_character_pos(0, 0)
	set_sprite_frames(load_source(0))
	set_character_dir("RIGHT")
	set_frame(1)
	status = PlayerStatus.stand

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
		if true:	# TODO:判断地块可移动性
			status = PlayerStatus.move	# 修改状态，锁定输入
			var tween_move = create_tween()
			var target_pos: Vector2
			match Direction.get(d):
				Direction.UP: target_pos = position + Vector2(0, -Init.MAP_TILE_SIZE)
				Direction.RIGHT: target_pos = position + Vector2(Init.MAP_TILE_SIZE, 0)
				Direction.DOWN: target_pos = position + Vector2(0, Init.MAP_TILE_SIZE)
				Direction.LEFT: target_pos = position + Vector2(-Init.MAP_TILE_SIZE, 0)
			print("position:", position, " target_pos:", target_pos)
			tween_move.tween_property(self, "position", target_pos, 0.4)
			tween_move.finished.connect(func():	# 倒计时结束回调，解锁输入
				status = PlayerStatus.stand
				print("position:", position)
		)
		else:	# TODO:不可通行，只播放移动帧，不移动，不锁定，接受输入（非同向）会立刻打断
			pass
	else:	# 尝试移动方向与当前面向不相同，执行转向
		status = PlayerStatus.turn	# 修改状态，锁定输入
		var tween_turn = create_tween()
		tween_turn.tween_property(self, "flip_h", false, 0.12)	# 修改属性无意义纯当计时用
		tween_turn.finished.connect(func():	# 倒计时结束回调，执行转向，然后解锁输入
			set_character_dir(d)
			status = PlayerStatus.stand
		)

## 检测是否是可接受移动输入
func is_enable_move() -> bool:
	if status == PlayerStatus.stand or status == PlayerStatus.fake_move:
		return true
	else:
		return false
