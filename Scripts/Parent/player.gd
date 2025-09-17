## 玩家实例，不同于其他基类，该类“可以直接实例化”
class_name Player extends Node

enum State { NONE = 0, SWIM = 1 << 1, FLOAT = 1 << 9, FLY = 1 << 0 }	# 最低位置1会无视任何碰撞
var carry_pokemon: Array[Pokemon]
var save_pokemon: Array[Pokemon]
