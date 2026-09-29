extends PlayerState


func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 > 0 and _old_input & 0b010000 == 0:
		if body.is_on_floor() or body.ground_ray.is_colliding():
			return "Jump"
	if body.is_on_floor(): return "Walk"
	
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	body.up_direction = Vector2.UP

func physics_function(_delta: float, _new_input: int, _old_input: int):
	body.velocity += body.get_gravity() * _delta
	var direction: int = (_new_input & 0b01) - ((_new_input & 0b10) >> 1)
	if abs(body.current_ground_speed + (direction * body.ACCELERATION)) <= body.MAX_AIR_SPEED:
		body.current_ground_speed += direction * body.ACCELERATION
	body.velocity.x = body.current_ground_speed
	body.move_and_slide()

func exit_function(_delta: float, _new_input: int, _old_input: int):
	body.velocity.y = 0
