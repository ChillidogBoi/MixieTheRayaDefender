extends PlayerState


func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 0 and _old_input & 0b010000 == 0: return "Jump"
	if _new_input & 0b0011 != 0: return "Walk"
	if not body.is_on_floor(): return "Fall"
	
	return "current"
