extends PlayerState

var timer := 0.0

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 00 and timer < body.MAX_JUMP_TIME:
		return "current"
	return "Fall"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	timer = 0.0
	body.velocity.y = -body.JUMP_STRENGTH
	body.move_and_slide()

func physics_function(_delta: float, _new_input: int, _old_input: int):
	timer += _delta
	
	var direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1)
	if abs(body.current_ground_speed + (direction * body.ACCELERATION)) <= body.MAX_GROUND_SPEED:
		body.current_ground_speed += direction * body.ACCELERATION
	body.velocity.x = body.current_ground_speed
	body.move_and_slide()
