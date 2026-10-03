extends PlayerState

var still_on_wall := true

func enter_function(_delta: float, _new_input: int, _old_input: int):
	still_on_wall = true
	body.up_direction = Vector2.UP

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 0 and _old_input & 0b010000 == 0 and still_on_wall:
		return "WallJump"
	if not still_on_wall: return "Fall"
	if body.is_on_floor(): return "Walk"
	
	return "current"

func physics_function(_delta: float, _new_input: int, _old_input: int):
	if body.current_falling_speed.y < 0: body.current_falling_speed += body.get_gravity() * _delta
	else: body.current_falling_speed += body.get_gravity() * _delta * body.WALL_SLIDE_GRAVITY
	do_player_horizontal_movement(_new_input, body.MAX_AIR_SPEED)
	if still_on_wall and not body.is_near_wall(): still_on_wall = false
