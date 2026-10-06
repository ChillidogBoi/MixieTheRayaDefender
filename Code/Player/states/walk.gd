extends PlayerState

var fall_timer: float = 0.0

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 > 0 and _old_input & 0b010000 == 0: return "Jump"
	if _new_input & 0b0011 == 0: return "Slowing"
	if fall_timer <= 0.0 and not body.is_on_floor(): return "Fall"
	
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	fall_timer = body.COYOTE_TIME

func physics_function(_delta: float, _new_input: int, _old_input: int):
	do_player_horizontal_movement(_new_input, body.MAX_GROUND_SPEED)
	
	if body.ground_ray.is_colliding():
		do_player_rotation(body.ground_ray.get_collision_normal())
		fall_timer = body.COYOTE_TIME
	else: fall_timer -= _delta
