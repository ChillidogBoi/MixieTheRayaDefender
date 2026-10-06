extends PlayerState

var last_input: int

func enter_function(_delta: float, _new_input: int, _old_input: int):
	last_input = _old_input
	body.current_falling_speed = Vector2.ZERO

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if abs(body.current_ground_speed) < body.CAN_LOOP_SPEED:
		do_player_rotation(Vector2.UP)
		return "Fall"
	return "current"

func physics_function(_delta: float, _new_input: int, _old_input: int):
	do_player_horizontal_movement(_new_input, body.MAX_GROUND_SPEED, true)
	
	if body.ground_ray.is_colliding():
		do_player_rotation(body.ground_ray.get_collision_normal())
