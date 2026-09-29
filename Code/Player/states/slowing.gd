extends PlayerState


func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 0 and _old_input & 0b010000 == 0: return "Jump"
	if _new_input & 0b0011 != 0: return "Walk"
	if body.current_ground_speed == 0: return "Idle"
	if not body.is_on_floor(): return "Fall"
	
	return "current"

func physics_function(_delta: float, _new_input: int, _old_input: int):
	body.current_ground_speed -= sign(body.current_ground_speed) * body.ACCELERATION
	
	body.velocity.x = body.current_ground_speed
	body.move_and_slide()
