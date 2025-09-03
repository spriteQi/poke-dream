extends Node2D

var game_scene_path: String = "res://Scenes/game.tscn"

func _ready() -> void:
	get_tree().call_deferred("change_scene_to_file", game_scene_path)
