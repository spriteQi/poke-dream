class_name Skill extends Node

static var DATA: Dictionary	# 技能数据，视为常量
var skill_id: int	# 技能id
var pp: int	# 剩余pp
var pp_upgrade: int	# pp提升次数，最大值3

static func _static_init() -> void:
	# TODO:初始化DATA
	return
