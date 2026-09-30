extends PlayerState

var rail_follower: PathFollow2D
var is_finished := false

func test(_delta: float, _new_input: int, _old_input: int) -> String:
	if _new_input & 0b010000 != 0 and _old_input & 0b010000 == 0: return "Jump"
	if is_finished: return "Fall"
	
	return "current"

func enter_function(_delta: float, _new_input: int, _old_input: int):
	is_finished = false

func idle_function(_delta: float, _old_input: int):
	if rail_follower.progress_ratio == 1: is_finished = true
	rail_follower.progress += body.RAIL_SPEED * _delta
	print(rail_follower.progress_ratio)
	
	body.global_position = rail_follower.global_position
	body.global_rotation = rail_follower.global_rotation

func exit_function(_delta: float, _new_input: int, _old_input: int):
	body.current_ground_speed = body.RAIL_SPEED

func _on_mixie_entered_grindrail(new_rail_follower: PathFollow2D):
	rail_follower = new_rail_follower
