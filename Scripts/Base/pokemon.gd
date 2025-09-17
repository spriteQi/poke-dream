class_name Pokemon extends Node

enum Stat { HP, ATK, DEF, SP_ATK, SP_DEF, SPD }
static var BASE_STATS: Dictionary	# 基础信息，index即为编号，视为常量
var serial: int = 0
var sex: int = 0	# 0.♀ 1.♂ 2.NA
var iv: Array[int] = []	# 个体值
var ev: Array[int] = []	# 努力值
var lv: int = 0	# 等级
var nature: int = 0	# 性格
var stats: Array[int] = []	# 属性值
var skill: Array[Skill] = []	# 技能
var shine: int = 0	# 0.no 1.star 2.cube

static func _static_init() -> void:
	# TODO:初始化BASE_STATS
	return

## 实例化一个pokemon（构造方法）
static func new_pokemon(iv_: Array, ev_: Array, lv_: int, nature_: int, skill_: Array, stats_: Array = []) -> Pokemon:
	var pokemon: Pokemon = Pokemon.new()
	if stats_.is_empty():
		pass
	return pokemon

## 随机生成一个pokemon
static func generate(serial_: int, min_lv: int, max_lv: int) -> Pokemon:
	var pokemon: Pokemon = Pokemon.new()
	pokemon.serial = serial_
	pokemon.sex = rand_sex(serial_)
	# 随机生成0~31个体值
	for stat_ in Stat:
		pokemon.iv.append(randi() % 32)
	pokemon.ev = [0, 0, 0, 0, 0, 0, 0]	# 初始化努力值
	pokemon.lv = clamp(randi_range(min_lv, max_lv), Init.MIN_LV, Init.MAX_LV)	# 随机生成等级
	pokemon.nature = randi() % 25
	pokemon.stats = re_calc_stats(pokemon.iv, pokemon.ev, pokemon.lv, pokemon.nature)
	# TODO:skill也需要生成
	pokemon.shine = rand_shine()	# 闪光判定

	return pokemon

## 随机获取性别，需要传入编号，根据编号读取BASE_STATS中的性别比
static func rand_sex(serial_: int) -> int:
	return 0

## 随机获取一个是否闪光的结果
static func rand_shine() -> int:
	if randi() % Init.SHINE_PERCENT == 0:	# 判定是否闪光
		if Init.SHINE_CUBE_PERCENT == 0:	# 没有开启方块闪
			return 1
		else:
			if randi() % Init.SHINE_CUBE_PERCENT == 0:	# 判定是否方块闪
				return 2
	return 0
	
## 重算属性值
static func re_calc_stats(iv_:Array, ev_:Array, lv_:int, nature_: int) -> Array[int]:
	return []
