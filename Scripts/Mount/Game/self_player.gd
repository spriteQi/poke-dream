extends Character

func _ready() -> void:
	set_character_pos(0, 0)
	set_sprite_frames(load_source(0))
	set_animation("DOWN")
	set_frame(1)
